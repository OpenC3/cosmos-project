#!/bin/bash

set +e

if ! command -v docker &> /dev/null
then
  if command -v podman &> /dev/null
  then
    function docker() {
      podman $@
    }
  else
    echo "Neither docker nor podman found!!!"
    exit 1
  fi
fi

export DOCKER_COMPOSE_COMMAND="docker compose"
${DOCKER_COMPOSE_COMMAND} version &> /dev/null
if [ "$?" -ne 0 ]; then
  export DOCKER_COMPOSE_COMMAND="docker-compose"
fi

docker info | grep -e "rootless$" -e "rootless: true"
if [ "$?" -ne 0 ]; then
  export OPENC3_ROOTFUL=1
  export OPENC3_USER_ID=`id -u`
  export OPENC3_GROUP_ID=`id -g`
else
  export OPENC3_ROOTLESS=1
  export OPENC3_USER_ID=0
  export OPENC3_GROUP_ID=0
fi

set -e

usage() {
  echo "Usage: $1 [cli, start, stop, cleanup, run, util]" >&2
  echo "*  cli: run a cli command as the default user ('cli help' for more info)" 1>&2
  echo "*  start: alias for run" >&2
  echo "*  stop: stop the containers (compose stop)" >&2
  echo "*  cleanup [local] [force]: REMOVE volumes / data (compose down -v)" >&2
  echo "*  run: run the containers (compose up)" >&2
  echo "*  util: various helper commands" >&2
  exit 1
}

if [ "$#" -eq 0 ]; then
  usage $0
fi

case $1 in
  cli )
    # Source the .env file to setup environment variables
    set -a
    . "$(dirname -- "$0")/.env"
    # Start (and remove when done --rm) the openc3-cosmos-cmd-tlm-api container with the current working directory
    # mapped as volume (-v) /openc3/local and container working directory (-w) also set to /openc3/local.
    # This allows tools running in the container to have a consistent path to the current working directory.
    # Run the command "ruby /openc3/bin/openc3cli" with all parameters starting at 2 since the first is 'openc3'
    args=`echo $@ | { read _ args; echo $args; }`
    ${DOCKER_COMPOSE_COMMAND} -f "$(dirname -- "$0")/compose.yaml" run -it --rm -v `pwd`:/openc3/local:z -w /openc3/local -e OPENC3_API_PASSWORD=$OPENC3_API_PASSWORD --no-deps openc3-cosmos-cmd-tlm-api ruby /openc3/bin/openc3cli $args
    set +a
    ;;
  stop )
    ${DOCKER_COMPOSE_COMMAND} -f "$(dirname -- "$0")/compose.yaml" stop openc3-operator
    ${DOCKER_COMPOSE_COMMAND} -f "$(dirname -- "$0")/compose.yaml" stop openc3-cosmos-script-runner-api
    ${DOCKER_COMPOSE_COMMAND} -f "$(dirname -- "$0")/compose.yaml" stop openc3-cosmos-cmd-tlm-api
    sleep 5
    ${DOCKER_COMPOSE_COMMAND} -f "$(dirname -- "$0")/compose.yaml" down -t 30
    ;;
  cleanup )
    # They can specify 'cleanup force' or 'cleanup local force'
    if [ "$2" == "force" ] || [ "$3" == "force" ]
    then
      ${DOCKER_COMPOSE_COMMAND} -f "$(dirname -- "$0")/compose.yaml" down -t 30 -v
    else
      echo "Are you sure? Cleanup removes ALL docker volumes and all COSMOS data! (1-Yes / 2-No)"
      select yn in "Yes" "No"; do
        case $yn in
          Yes ) ${DOCKER_COMPOSE_COMMAND} -f "$(dirname -- "$0")/compose.yaml" down -t 30 -v; break;;
          No ) exit;;
        esac
      done
    fi
    if [ "$2" == "local" ]
    then
      cd plugins/DEFAULT
      ls | grep -xv "README.md" | xargs rm -r
      cd ../..
    fi
    ;;
  start | run )
    ${DOCKER_COMPOSE_COMMAND} -f "$(dirname -- "$0")/compose.yaml" up -d
    ;;
  run-ubi )
    OPENC3_IMAGE_SUFFIX=-ubi OPENC3_REDIS_VOLUME=/home/data ${DOCKER_COMPOSE_COMMAND} -f "$(dirname -- "$0")/compose.yaml" up -d
    ;;
  util )
    set -a
    . "$(dirname -- "$0")/.env"
    scripts/linux/openc3_util.sh "${@:2}"
    set +a
    ;;
  * )
    usage $0
    ;;
esac

#!/usr/bin/env sh

set -e

usage() {
  echo "Usage: $1 [cli, cliroot, start, stop, cleanup, build, deploy]" >&2
  echo "*  cli: run a cli command as the default user ('cli help' for more info)" 1>&2
  echo "*  cliroot: run a cli command as the root user ('cli help' for more info)" 1>&2
  echo "*  start: start the docker-compose openc3" >&2
  echo "*  stop: stop the running dockers for openc3" >&2
  echo "*  cleanup: cleanup network and volumes for openc3" >&2
  echo "*  run: run the prebuilt containers for openc3" >&2
  echo "*  util: various helper commands" >&2
  echo "*    encode: encode a string to base64" >&2
  echo "*    hash: hash a string using SHA-256" >&2
  echo "*    save: save images to tar files" >&2
  echo "*    load: load images to tar files" >&2
  echo "*    clean: remove node_modules, coverage, etc" >&2
  echo "*    hostsetup: setup host for redis" >&2
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
    # Start (and remove when done --rm) the openc3-base container with the current working directory
    # mapped as volume (-v) /openc3/local and container working directory (-w) also set to /openc3/local.
    # This allows tools running in the container to have a consistent path to the current working directory.
    # Run the command "ruby /openc3/bin/openc3cli" with all parameters starting at 2 since the first is 'openc3'
    args=`echo $@ | { read _ args; echo $args; }`
    docker run --rm -v `pwd`:/openc3/local -w /openc3/local openc3inc/openc3-base:$OPENC3_TAG ruby /openc3/bin/openc3cli $args
    set +a
    ;;
  cliroot )
    set -a
    . "$(dirname -- "$0")/.env"
    args=`echo $@ | { read _ args; echo $args; }`
    docker run --rm --user=root -v `pwd`:/openc3/local -w /openc3/local openc3inc/openc3-base:$OPENC3_TAG ruby /openc3/bin/openc3cli $args
    set +a
    ;;
  start )
    chmod -R 775 plugins
    docker-compose -f compose.yaml up -d
    ;;
  stop )
    docker-compose -f compose.yaml down -t 30
    ;;
  cleanup )
    docker-compose -f compose.yaml down -t 30 -v
    ;;
  run )
    chmod -R 775 plugins
    docker-compose -f compose.yaml up -d
    ;;
  util )
    scripts/linux/openc3_util.sh $2 $3
    ;;
  * )
    usage $0
    ;;
esac

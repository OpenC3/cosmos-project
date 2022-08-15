#!/usr/bin/env sh

set -e

usage() {
  echo "Usage: $1 [encode, hash, save, load, clean, hostsetup]" >&2
  echo "*  encode: encode a string to base64" >&2
  echo "*  hash: hash a string using SHA-256" >&2
  echo "*  save: save images to a tar file" >&2
  echo "*  load: load images from a tar file" >&2
  echo "*  clean: remove node_modules, coverage, etc" >&2
  echo "*  hostsetup: configure host for redis" >&2
  exit 1
}

saveTar() {
  mkdir -p tmp
  if [ -z "$1" ]; then
    tag='latest'
  else
    tag=$1
    docker pull openc3/openc3-enterprise-gem:$tag
    docker pull openc3/openc3-enterprise-operator:$tag
    docker pull openc3/openc3-enterprise-cmd-tlm-api:$tag
    docker pull openc3/openc3-enterprise-script-runner-api:$tag
    docker pull openc3/openc3-enterprise-traefik:$tag
    docker pull openc3/openc3-enterprise-redis:$tag
    docker pull openc3/openc3-enterprise-minio:$tag
    docker pull openc3/openc3-enterprise-init:$tag
    docker pull openc3/openc3-enterprise-keycloak:$tag
    docker pull openc3/openc3-enterprise-postgresql:$tag
  fi
  docker save openc3/openc3-enterprise-gem:$tag -o tmp/openc3-enterprise-gem-$tag.tar
  docker save openc3/openc3-enterprise-operator:$tag -o tmp/openc3-enterprise-operator-$tag.tar
  docker save openc3/openc3-enterprise-cmd-tlm-api:$tag -o tmp/openc3-enterprise-cmd-tlm-api-$tag.tar
  docker save openc3/openc3-enterprise-script-runner-api:$tag -o tmp/openc3-enterprise-script-runner-api-$tag.tar
  docker save openc3/openc3-enterprise-traefik:$tag -o tmp/openc3-enterprise-traefik-$tag.tar
  docker save openc3/openc3-enterprise-redis:$tag -o tmp/openc3-enterprise-redis-$tag.tar
  docker save openc3/openc3-enterprise-minio:$tag -o tmp/openc3-enterprise-minio-$tag.tar
  docker save openc3/openc3-enterprise-init:$tag -o tmp/openc3-enterprise-init-$tag.tar
  docker save openc3/openc3-enterprise-keycloak:$tag -o tmp/openc3-enterprise-keycloak-$tag.tar
  docker save openc3/openc3-enterprise-postgresql:$tag -o tmp/openc3-enterprise-postgresql-$tag.tar
}

loadTar() {
  if [ -z "$1" ]; then
    tag='latest'
  else
    tag=$1
  fi
  docker load -i tmp/openc3-enterprise-gem-$tag.tar
  docker load -i tmp/openc3-enterprise-operator-$tag.tar
  docker load -i tmp/openc3-enterprise-cmd-tlm-api-$tag.tar
  docker load -i tmp/openc3-enterprise-script-runner-api-$tag.tar
  docker load -i tmp/openc3-enterprise-traefik-$tag.tar
  docker load -i tmp/openc3-enterprise-redis-$tag.tar
  docker load -i tmp/openc3-enterprise-minio-$tag.tar
  docker load -i tmp/openc3-enterprise-init-$tag.tar
  docker load -i tmp/openc3-enterprise-keycloak-$tag.tar
  docker load -i tmp/openc3-enterprise-postgresql-$tag.tar
}

cleanFiles() {
  find . -type d -name "node_modules" | xargs -I {} echo "Removing {}"; rm -rf {}
  find . -type d -name "coverage" | xargs -I {} echo "Removing {}"; rm -rf {}
  # Prompt for removing yarn.lock files
  find . -type f -name "yarn.lock" | xargs -I {} rm -i {}
  # Prompt for removing Gemfile.lock files
  find . -type f -name "Gemfile.lock" | xargs -I {} rm -i {}
}

if [ "$#" -eq 0 ]; then
  usage $0
fi

case $1 in
  encode )
    echo -n $2 | base64
    ;;
  hash )
    echo -n $2 | shasum -a 256 | sed 's/-//'
    ;;
  save )
    saveTar $2
    ;;
  load )
    loadTar $2
    ;;
  clean )
    cleanFiles
    ;;
  hostsetup )
    docker run --rm --privileged --pid=host justincormack/nsenter1 /bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
    docker run --rm --privileged --pid=host justincormack/nsenter1 /bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/defrag"
    docker run --rm --privileged --pid=host justincormack/nsenter1 /bin/sh -c "sysctl -w vm.max_map_count=262144"
    ;;
  * )
    usage $0
    ;;
esac

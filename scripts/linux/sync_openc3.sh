#!/usr/bin/env sh

set -e

echo "Usage: scripts/linux/sync_openc3.sh"

cp ../openc3/compose.yaml .
cp ../openc3/LICENSE.txt .
cp ../openc3/openc3-redis/users.acl openc3-redis/.
cp ../openc3/openc3-traefik/traefik-allow-http.yaml openc3-traefik/.
cp ../openc3/openc3-traefik/traefik-letsencrypt.yaml openc3-traefik/.
cp ../openc3/openc3-traefik/traefik-ssl.yaml openc3-traefik/.
cp ../openc3/openc3-traefik/traefik.yaml openc3-traefik/.
cp ../openc3/plugins/README.md plugins/.
cp ../openc3/plugins/DEFAULT/README.md plugins/DEFAULT/.
cp ../openc3/scripts/linux/openc3_util.sh scripts/linux/.
cp ../openc3/scripts/windows/openc3_util.bat scripts/windows/.
cp ../openc3/.env .

echo "Must manually sync applicable parts of openc3.sh and openc3.bat"
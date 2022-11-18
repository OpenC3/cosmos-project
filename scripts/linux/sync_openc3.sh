#!/usr/bin/env sh

set -e

echo "Usage: scripts/linux/sync_openc3.sh"

cp ../cosmos/compose.yaml .
cp ../cosmos/LICENSE.txt .
cp ../cosmos/cacert.pem .
cp ../cosmos/openc3-redis/users.acl openc3-redis/.
cp ../cosmos/openc3-traefik/traefik-allow-http.yaml openc3-traefik/.
cp ../cosmos/openc3-traefik/traefik-letsencrypt.yaml openc3-traefik/.
cp ../cosmos/openc3-traefik/traefik-ssl.yaml openc3-traefik/.
cp ../cosmos/openc3-traefik/traefik.yaml openc3-traefik/.
cp ../cosmos/plugins/README.md plugins/.
cp ../cosmos/plugins/DEFAULT/README.md plugins/DEFAULT/.
cp ../cosmos/scripts/linux/openc3_util.sh scripts/linux/.
cp ../cosmos/scripts/windows/openc3_util.bat scripts/windows/.
cp ../cosmos/.env .

echo "Must manually sync applicable parts of openc3.sh and openc3.bat"
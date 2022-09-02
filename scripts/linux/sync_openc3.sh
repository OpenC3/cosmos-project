#!/usr/bin/env sh

set -e

echo "Usage: scripts/linux/sync_openc3.sh"

cp ../openc3-enterprise/compose.yaml .
cp ../openc3-enterprise/LICENSE.txt .
cp ../openc3-enterprise/openc3-enterprise-redis/users.acl openc3-enterprise-redis/.
cp ../openc3-enterprise/openc3-enterprise-traefik/traefik-allow-http.yaml openc3-enterprise-traefik/.
cp ../openc3-enterprise/openc3-enterprise-traefik/traefik-letsencrypt.yaml openc3-enterprise-traefik/.
cp ../openc3-enterprise/openc3-enterprise-traefik/traefik-ssl.yaml openc3-enterprise-traefik/.
cp ../openc3-enterprise/openc3-enterprise-traefik/traefik.yaml openc3-enterprise-traefik/.
cp ../openc3-enterprise/plugins/README.md plugins/.
cp ../openc3-enterprise/plugins/DEFAULT/README.md plugins/DEFAULT/.
cp ../openc3-enterprise/scripts/linux/openc3_util.sh scripts/linux/.
cp ../openc3-enterprise/scripts/windows/openc3_util.bat scripts/windows/.
cp ../openc3-enterprise/.env .

echo "Must manually sync applicable parts of openc3.sh and openc3.bat"

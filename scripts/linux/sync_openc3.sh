#!/usr/bin/env sh

set -e

echo "Usage: scripts/linux/sync_openc3.sh"

cp ../cosmos-enterprise/compose.yaml .
cp ../cosmos-enterprise/LICENSE.txt .
cp ../cosmos-enterprise/openc3-enterprise-redis/users.acl openc3-enterprise-redis/.
cp ../cosmos-enterprise/openc3-enterprise-traefik/traefik-allow-http.yaml openc3-enterprise-traefik/.
cp ../cosmos-enterprise/openc3-enterprise-traefik/traefik-letsencrypt.yaml openc3-enterprise-traefik/.
cp ../cosmos-enterprise/openc3-enterprise-traefik/traefik-ssl.yaml openc3-enterprise-traefik/.
cp ../cosmos-enterprise/openc3-enterprise-traefik/traefik.yaml openc3-enterprise-traefik/.
cp ../cosmos-enterprise/plugins/README.md plugins/.
cp ../cosmos-enterprise/plugins/DEFAULT/README.md plugins/DEFAULT/.
cp ../cosmos-enterprise/scripts/linux/openc3_util.sh scripts/linux/.
cp ../cosmos-enterprise/scripts/windows/openc3_util.bat scripts/windows/.
cp ../cosmos-enterprise/.env .

echo "Must manually sync applicable parts of openc3.sh and openc3.bat"

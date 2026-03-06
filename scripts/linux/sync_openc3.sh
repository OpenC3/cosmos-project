#!/usr/bin/env sh

set -e

cp ../cosmos/compose.yaml .
cp ../cosmos/LICENSE.md .
cp ../cosmos/cacert.pem .
cp ../cosmos/openc3-redis/users.acl openc3-redis/.
cp ../cosmos/openc3-traefik/traefik-letsencrypt.yaml openc3-traefik/.
cp ../cosmos/openc3-traefik/traefik-ssl.yaml openc3-traefik/.
cp ../cosmos/openc3-traefik/traefik.yaml openc3-traefik/.
cp ../cosmos/plugins/README.md plugins/.
cp ../cosmos/plugins/DEFAULT/README.md plugins/DEFAULT/.
cp ../cosmos/scripts/linux/openc3_util.sh scripts/linux/.
cp ../cosmos/scripts/linux/openc3_upgrade.sh scripts/linux/.
cp ../cosmos/scripts/windows/openc3_util.bat scripts/windows/.
cp ../cosmos/scripts/windows/openc3_upgrade.bat scripts/windows/.
cp ../cosmos/.env .
cp ../cosmos/openc3.sh .
cp ../cosmos/openc3.bat .
cp ../cosmos/_openc3 .

echo "Copies complete. Edit .env and set OPENC3_TAG and review other changes."

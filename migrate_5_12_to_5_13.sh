#!/bin/bash

# This script is designed to migrate from OpenC3 COSMOS 5.12.0 to 5.13.0 from a cosmos-project folder

# You must run this script as the same user as you usually run COSMOS

# Note this script is designed for docker and would need to change the user_id to a hardcoded 0 for rootless podman
# And probably replace "docker" with "podman" everywhere

# This is potentially risky and you should backup all of your docker volumes before continuing. Details on how to backup
# docker volumes can be found here: https://docs.docker.com/storage/volumes/#back-up-a-volume

# Legal Notice:

# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Stop running
./openc3.sh stop

# Update relevant 5.13.0 files - You could also do this manually
curl -G https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/compose.yaml > ./compose.yaml
curl -G https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/openc3-traefik/traefik-allow-http.yaml > ./openc3-traefik/traefik-allow-http.yaml
curl -G https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/openc3-traefik/traefik-letsencrypt.yaml > ./openc3-traefik/traefik-letsencrypt.yaml
curl -G https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/openc3-traefik/traefik-ssl.yaml > ./openc3-traefik/traefik-ssl.yaml
curl -G https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/openc3-traefik/traefik.yaml > ./openc3-traefik/traefik.yaml
curl -G https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/.env > ./.env

# Determine current directory for docker compose naming of volumes
currentdir=${PWD##*/}

# Get current user id 
userid=`id -u`

# Adjust file permissions in Redis volumes
docker run --rm -v "${currentdir}_openc3-redis-v:/original" --user root docker.io/openc3inc/openc3-operator:5.13.0 sh -c "chown -R $userid /original"
docker run --rm -v "${currentdir}_openc3-redis-ephemeral-v:/original" --user root docker.io/openc3inc/openc3-operator:5.13.0 sh -c "chown -R $userid /original"
  
# Handle rename and adjust file permissions in Minio bucket volume
docker run --rm -v "${currentdir}_openc3-minio-v:/original" -v "${currentdir}_openc3-bucket-v:/new" --user root docker.io/openc3inc/openc3-operator:5.13.0 sh -c "cp -R /original/* /new/ && chown -R $userid:$userid /new"

# All Done! - At this point you should be able to startup successfully with ./openc3.sh run
# Check "docker ps" to make sure none of your containers are restarting. If so, please reach out to support@openc3.com
# You also may want to delete the old postgres volume if everything was successful

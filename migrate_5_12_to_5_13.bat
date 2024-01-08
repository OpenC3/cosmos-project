REM This script is designed to migrate from OpenC3 COSMOS 5.12.0 to 5.13.0 from a cosmos-project folder

REM You must run this script as the same user as you usually run COSMOS

REM Note this script is designed for docker and would need to change the user_id to a hardcoded 0 for rootless podman
REM And probably replace "docker" with "podman" everywhere

REM This is potentially risky and you should backup all of your docker volumes before continuing. Details on how to backup
REM docker volumes can be found here: https://docs.docker.com/storage/volumes/#back-up-a-volume

REM Legal Notice:

REM THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
REM INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
REM PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
REM FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
REM ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

REM Stop running
call openc3.bat stop

REM Update relevant 5.13.0 files - You could also do this manually
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/compose.yaml', '.\compose.yaml')"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/openc3-traefik/traefik-allow-http.yaml', '.\openc3-traefik\traefik-allow-http.yaml')"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/openc3-traefik/traefik-letsencrypt.yaml', '.\openc3-traefik\traefik-letsencrypt.yaml')"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/openc3-traefik/traefik-ssl.yaml', '.\openc3-traefik\traefik-ssl.yaml')"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/openc3-traefik/traefik.yaml', '.\openc3-traefik\traefik.yaml')"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OpenC3/cosmos-project/v5.13.0/.env', '.\.env')"

REM Determine current directory for docker compose naming of volumes
for %%I in (.) do set CurrDirName=%%~nxI

REM Adjust file permissions on gem volume
docker run --rm -v "%CurrDirName%_openc3-gems-v:/original" --user root docker.io/openc3inc/openc3-operator:5.13.0 sh -c "chown -R 1001 /original"

REM Adjust file permissions in Redis volumes
docker run --rm -v "%CurrDirName%_openc3-redis-v:/original" --user root docker.io/openc3inc/openc3-operator:5.13.0 sh -c "chown -R 1001 /original"
docker run --rm -v "%CurrDirName%_openc3-redis-ephemeral-v:/original" --user root docker.io/openc3inc/openc3-operator:5.13.0 sh -c "chown -R 1001 /original"

REM Handle rename and adjust file permissions in Minio bucket volume
docker volume create --label "com.docker.compose.project"="%CurrDirName%" --label "com.docker.compose.version"="2.23.0" --label "com.docker.compose.volume"="openc3-bucket-v" "%CurrDirName%_openc3-bucket-v"
docker run --rm -v "%CurrDirName%_openc3-minio-v:/original" -v "%CurrDirName%_openc3-bucket-v:/new" --user root docker.io/openc3inc/openc3-operator:5.13.0 sh -c "cp -R /original/* /new/ && chown -R 1001:1001 /new"

REM All Done! - At this point you should be able to startup successfully with openc3.bat run
REM Check "docker ps" to make sure none of your containers are restarting. If so, please reach out to support@openc3.com

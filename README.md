# OpenC3 COSMOS Project

This git repo is used as a starting point for running and configuring OpenC3 COSMOS for your specific project. It includes the necessary scripts to run OpenC3 COSMOS, but does not come with all the source code and relies on running released containers rather than building containers from source. This is the recommended starting place for any project who wants to use OpenC3 COSMOS, but not develop the core system.

## Quick Start

1. git clone https://github.com/openc3/cosmos-project.git cosmos-myprojectname
2. Checkout the version tag you want.
   ```
   git checkout v6.9.1
   ```
3. Start OpenC3 COSMOS
   - On Linux/Mac: ./openc3.sh run
   - On Windows: openc3.bat run
4. After approximately 2 minutes, open a web browser to http://localhost:2900
   - If you run "docker ps", you can watch until the openc3-cosmos-init container completes, at which point the system should be fully configured and ready to use.

## Run without the Demo project

1. Edit .env and remove the OPENC3_DEMO line
2. If you have already ran with the demo also uninstall the demo plugin from the Admin tool.

## Upgrade to a Specific Version

See [Upgrading](https://docs.openc3.com/docs/getting-started/upgrading) for more information.

1. Stop OpenC3
   - On Linux/Mac: `./openc3.sh stop`
   - On Windows: `openc3.bat stop`
2. Upgrade to the requested version
   - On Linux/Mac: `./openc3.sh upgrade v6.9.2`
   - On Windows: `openc3.bat ugprade v6.9.2`
3. Start OpenC3
   - On Linux/Mac: `./openc3.sh run`
   - On Windows: `openc3.bat run`

## Change all default credentials and secrets

1. Edit .env and change:
   1. SECRET_KEY_BASE
   2. OPENC3_SERVICE_PASSWORD
   3. OPENC3_REDIS_PASSWORD
   4. OPENC3_BUCKET_PASSWORD
   5. OPENC3_SR_REDIS_PASSWORD
   6. OPENC3_SR_BUCKET_PASSWORD
2. Edit ./openc3-redis/users.acl and change the password for each account. Note passwords for openc3/scriptrunner must match the REDIS passwords in the .env file:
   1. openc3
   2. admin
   3. scriptrunner
3. Edit any passwords in compose.yaml

Passwords stored in `./openc3-redis/users.acl` use a sha256 hash.
To generate a new hash use the following method, and then copy / paste into users.acl

```bash
echo -n 'adminpassword' | openssl dgst -sha256
SHA2-256(stdin)= 749f09bade8aca755660eeb17792da880218d4fbdc4e25fbec279d7fe9f65d70
```

## Opening to the Network

Important: Before exposing OpenC3 COSMOS to any network, even a local network, make sure you have changed all default credentials and secrets!!!

### Open to the network using https/SSL and your own certificates

1. Copy your public SSL certicate to ./openc3-traefik/cert.crt
2. Copy your private SSL certicate to ./openc3-traefik/cert.key
3. Edit compose.yaml
   1. Comment out this openc3-traefik line: `./openc3-traefik/traefik.yaml:/etc/traefik/traefik.yaml:z`
   2. Uncomment this openc3-traefik line: `./openc3-traefik/traefik-ssl.yaml:/etc/traefik/traefik.yaml`
   3. Uncomment this openc3-traefik line: `./openc3-traefik/cert.key:/etc/traefik/cert.key`
   4. Uncomment this openc3-traefik line: `./openc3-traefik/cert.crt:/etc/traefik/cert.crt`
4. If you are able to run as the standard browser ports 80/443, edit compose.yaml:
   1. Comment out this openc3-traefik line: `127.0.0.1:2900:2900`
   2. Comment out this openc3-traefik line: `127.0.0.1:2943:2943`
   3. Uncomment out this openc3-traefik line: `80:2900`
   4. Uncomment out this openc3-traefik line: `443:2943`
5. If not, edit compose.yaml:
   1. Remove 127.0.0.1 from this line: `127.0.0.1:2900:2900`
   2. Remove 127.0.0.1 from this line: `127.0.0.1:2943:2943`
6. Edit ./openc3-traefik/traefik-ssl.yaml
   1. Update line 14 to the first port number in step 4 or 5: to: ":2943" # This should match port forwarding in your compose.yaml
   2. Update line 22 to your domain: - main: "mydomain.com" # Update with your domain
7. Start OpenC3
   1. On Linux/Mac: ./openc3.sh run
   2. On Windows: openc3.bat run
8. After approximately 2 minutes, open a web browser to `https://<Your IP Address>` (or `https://<Your IP Address>:2943` if you can't use standard ports)
   1. If you run "docker ps", you can watch until the openc3-init container completes, at which point the system should be fully configured and ready to use.

### Open to the network using a global certificate from Let's Encrypt

Warning: These directions only work when exposing COSMOS to the internet. Make sure you understand the risks and have properly configured your server settings and firewall.

1. Make sure that your DNS settings are mapping your domain name to your server
2. Edit compose.yaml
   1. Comment out this openc3-traefik line: `./openc3-traefik/traefik.yaml:/etc/traefik/traefik.yaml:z`
   2. Uncomment this openc3-traefik line: `./openc3-traefik/traefik-letsencrypt.yaml:/etc/traefik/traefik.yaml`
3. Edit compose.yaml:
   1. Comment out this openc3-traefik line: `127.0.0.1:2900:2900`
   2. Comment out this openc3-traefik line: `127.0.0.1:2943:2943`
   3. Uncomment out this openc3-traefik line: `80:2900`
   4. Uncomment out this openc3-traefik line: `443:2943`
4. Start OpenC3
   1. On Linux/Mac: ./openc3.sh run
   2. On Windows: openc3.bat run
5. After approximately a few minutes, open a web browser to `https://<Your Domain Name>`
   1. If you run "docker ps", you can watch until the openc3-init container completes, at which point the system should be fully configured and ready to use.

### Open to the network insecurely using http

Warning: This is not recommended except for temporary testing on a local network. This will send plain text passwords over the network!

1. Edit compose.yaml
   1. Comment out this openc3-traefik line: `./openc3-traefik/traefik.yaml:/etc/traefik/traefik.yaml:z`
   2. Uncomment this openc3-traefik line: `./openc3-traefik/traefik-allow-http.yaml:/etc/traefik/traefik.yaml`
   3. Remove 127.0.0.1 from this line: `127.0.0.1:2900:2900`
2. Start OpenC3
   1. On Linux/Mac: ./openc3.sh run
   2. On Windows: openc3.bat run
3. After approximately 2 minutes, open a web browser to `https://<Your IP Address>:2900`
   1. If you run "docker ps", you can watch until the openc3-cosmos-init container completes, at which point the system should be fully configured and ready to use.

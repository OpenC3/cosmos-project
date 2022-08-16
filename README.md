# OpenC3 Enterprise Project

This git repo is used as a starting point for running and configuring OpenC3 Enterprise Edition for your specific project.
It includes the necessary scripts to run OpenC3 Enterprise Edition, but does not come with all the source code and relies on
running released containers rather than building containers from source.  This is the recommended starting
place for any project who wants to use OpenC3 Enterprise Edition, but not develop the core system.

## Prerequisites

Installing OpenC3 Enterprise is very similar to installing OpenC3. The Enterprise containers are stored here as [Packages](https://github.com/orgs/OpenC3/packages?repo_name=openc3-enterprise) rather than on Docker Hub. Follow these instructions to pull and run the containers:

1. Create a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token). Make sure to click the "repo" box and the "read:packages" box.

1. Save the PAT as an environment variable. You might want to put this in your .bashrc or .zshrc on unix platforms.  Or just an environment variable on Windows.

        export GITHUB_PAT=YOUR_TOKEN

1. Authenticate to Github Packages registry

        $ echo $GITHUB_PAT | docker login ghcr.io -u USERNAME --password-stdin
        > Login Succeeded
        
1. Once you've seen "Login Succeeded", you should be good to go for all the scenarios below.

## Quick Start

1. git clone https://github.com/openc3/openc3-enterprise-project.git openc3-myprojectname
2. Edit .env and change OPENC3_ENTERPRISE_TAG to the specific version you would like to run (ie. OPENC3_ENTERPRISE_TAG=5.0.8)
    1. This will allow you to upgrade versions when you choose rather than following latest
3. Start OpenC3
    1. On Linux/Mac: ./openc3.sh run
    2. On Windows: openc3.bat run
4. After approximately 2 minutes, open a web browser to http://localhost:2900/auth/
    1. If you run "docker ps", you can watch until the openc3-enterprise-init container completes, at which point the system should be fully configured and ready to use.
5. IMPORTANT: You must configure Keycloak before accessing http://localhost:2900 to get to the main OpenC3 app will work (you'll just see a white page until you do this) - Please follow our Keycloak documentation

## Run without the Demo project

1. Edit .env and remove the OPENC3_DEMO line
2. If you have already ran with the demo also uninstall the demo plugin from the Admin tool.

## Upgrade or Downgrade to a Specific Version

1. Stop OpenC3
    1. On Linux/Mac: ./openc3.sh stop
    2. On Windows: openc3.bat stop
2. Edit .env and change OPENC3_ENTERPRISE_TAG to the specific version you would like to run (ie. OPENC3_ENTERPRISE_TAG=5.0.8)
3. Start OpenC3
    1. On Linux/Mac: ./openc3.sh run
    2. On Windows: openc3.bat run

## Change all default credentials and secrets

1. Edit .env and change:
    1. SECRET_KEY_BASE
    2. OPENC3_SERVICE_PASSWORD
    3. OPENC3_REDIS_PASSWORD
    4. OPENC3_MINIO_PASSWORD
    5. OPENC3_SR_REDIS_PASSWORD
    6. OPENC3_SR_MINIO_PASSWORD
2. Edit ./openc3-enterprise-redis/users.acl and change the password for each account.  Note passwords for openc3/scriptrunner must match the REDIS passwords in the .env file:
    1. openc3
    2. admin
    3. scriptrunner
3. Edit any passwords in compose.yaml

## Opening to the Network

Important: Before exposing OpenC3 to any network, even a local network, make sure you have changed all default credentials and secrets!!!

### Open to the network using https/SSL and your own certificates

1. Copy your public SSL certicate to ./openc3-enterprise-traefik/cert.crt
2. Copy your private SSL certicate to ./openc3-enterprise-traefik/cert.key
3. Edit compose.yaml
    1. Comment out this openc3-enterprise-traefik line: ```- "./openc3-enterprise-traefik/traefik.yaml:/etc/traefik/traefik.yaml:z"```
    2. Uncomment this openc3-enterprise-traefik line: ```- "./openc3-enterprise-traefik/traefik-ssl.yaml:/etc/traefik/traefik.yaml"```
    3. Uncomment this openc3-enterprise-traefik line: ```- "./openc3-enterprise-traefik/cert.key:/etc/traefik/cert.key"```
    4. Uncomment this openc3-enterprise-traefik line: ```- "./openc3-enterprise-traefik/cert.crt:/etc/traefik/cert.crt"```
4. If you are able to run as the standard browser ports 80/443, edit compose.yaml:
    1. Comment out this openc3-enterprise-traefik line: ```- "127.0.0.1:2900:80"```
    2. Comment out this openc3-enterprise-traefik line: ```- "127.0.0.1:2943:443"```
    3. Uncomment out this openc3-enterprise-traefik line: ```- "80:80"```
    4. Uncomment out this openc3-enterprise-traefik line: ```- "443:443"```
5. Edit ./openc3-enterprise-traefik/traefik-ssl.yaml
    2. Update line 22 to your domain: - main: "mydomain.com" # Update with your domain
6. Start OpenC3
    1. On Linux/Mac: ./openc3.sh run
    2. On Windows: openc3.bat run
7. After approximately 2 minutes, open a web browser to https://mydomain.com/auth/
    1. If you run "docker ps", you can watch until the openc3-enterprise-init container completes, at which point the system should be fully configured and ready to use.
8. IMPORTANT: You must configure Keycloak before accessing https://mydomain.com to get to the main OpenC3 app will work (you'll just see a white page until you do this) - Please follow our Keycloak documentation

### Open to the network using a global certificate from Let's Encrypt

Warning: These directions only work when exposing OpenC3 to the internet.  Make sure you understand the risks and have properly configured your server settings and firewall.

1. Make sure that your DNS settings are mapping your domain name to your server
2. Edit compose.yaml
    1. Comment out this openc3-enterprise-traefik line: ```- "./openc3-enterprise-traefik/traefik.yaml:/etc/traefik/traefik.yaml:z"```
    2. Uncomment this openc3-enterprise-traefik line: ```- "./openc3-enterprise-traefik/traefik-letsencrypt.yaml:/etc/traefik/traefik.yaml"```
3. Edit compose.yaml:
    1. Comment out this openc3-enterprise-traefik line: ```- "127.0.0.1:2900:80"```
    2. Comment out this openc3-enterprise-traefik line: ```- "127.0.0.1:2943:443"```
    3. Uncomment out this openc3-enterprise-traefik line: ```- "80:80"```
    4. Uncomment out this openc3-enterprise-traefik line: ```- "443:443"```
4. Start OpenC3
    1. On Linux/Mac: ./openc3.sh run
    2. On Windows: openc3.bat run
5. After approximately 2 minutes, open a web browser to https://mydomain.com/auth/
    1. If you run "docker ps", you can watch until the openc3-enterprise-init container completes, at which point the system should be fully configured and ready to use.
6. IMPORTANT: You must configure Keycloak before accessing https://mydomain.com to get to the main OpenC3 app will work (you'll just see a white page until you do this) - Please follow our Keycloak documentation

### Open to the network insecurely using http

Warning: This is not recommended except for temporary testing on a local network. This will send plain text passwords over the network!

1. Edit compose.yaml
    1. Comment out this openc3-enterprise-traefik line: ```- "./openc3-enterprise-traefik/traefik.yaml:/etc/traefik/traefik.yaml:z"```
    2. Uncomment this openc3-enterprise-traefik line: ```- "./openc3-enterprise-traefik/traefik-allow-http.yaml:/etc/traefik/traefik.yaml"```
    3. Remove 127.0.0.1: from this line and replace 2900 with 80: ```- "127.0.0.1:2900:80"```
2. Start OpenC3
    1. On Linux/Mac: ./openc3.sh run
    2. On Windows: openc3.bat run
3. After approximately 2 minutes, open a web browser to http://mydomain.com/auth/
    1. If you run "docker ps", you can watch until the openc3-enterprise-init container completes, at which point the system should be fully configured and ready to use.
4. IMPORTANT: You must configure Keycloak before accessing https://mydomain.com to get to the main OpenC3 app will work (you'll just see a white page until you do this) - Please follow our Keycloak documentation

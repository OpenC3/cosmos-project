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

> [!IMPORTANT]
> Before exposing COSMOS to the network please read the [Opening to the Network](./NetworkConfiguration.md) document.
>

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
   - On Windows: `openc3.bat upgrade v6.9.2`
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

## Documentation

- [Opening to the Network](./NetworkConfiguration.md) - Open COSMOS to the network with SSL/TLS

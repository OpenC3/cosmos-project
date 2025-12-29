# Opening to the Network

Important: Before exposing OpenC3 COSMOS to any network, even a local network, make sure you have changed all default credentials and secrets!!!

We support three different configurations for COSMOS networking:

1. Only accessible from localhost - **default development configuration** - great for single terminal access
2. Open to the network with user provided SSL certificates - **recommended production configuration**
3. Open to the network using Let's Encrypt generated SSL certificates - **requires the server being available on the public internet - generally not recommended**
4. Open to the network without encryption - **Insecure and will expose passwords!!!**

## Open to the network using https/SSL and your own certificates

Note: For local testing you can use mkcert to make certificates. In general you should ask your IT department for a domain name, and associated certificates.

Using mkcert:

1. Install mkcert (brew install mkcert on MacOs)
1. mkcert -install
1. mkcert "your ip or domain name here"
1. cat "`mkcert -CAROOT`"/rootCA.pem >> cacert.pem
1. The previous step will add the local certificate authority to your cacert.pem file so that COSMOS will accept it as not self-signed.

You now have certificates to test with.

1. Copy your public SSL certificate to ./openc3-traefik/cert.crt
2. Copy your private SSL certificate to ./openc3-traefik/cert.key
3. Edit compose.yaml
   1. Comment out this openc3-traefik line: `./openc3-traefik/traefik.yaml:/etc/traefik/traefik.yaml:z`
   2. Uncomment this openc3-traefik line: `./openc3-traefik/traefik-ssl.yaml:/etc/traefik/traefik.yaml`
   3. Uncomment this openc3-traefik line: `./openc3-traefik/cert.key:/etc/traefik/cert.key`
   4. Uncomment this openc3-traefik line: `./openc3-traefik/cert.crt:/etc/traefik/cert.crt`
   5. Modify this openc3-traefik line to remove the ip address and modify the first port number if desired **(Note: leave the last :2900)**: `127.0.0.1:2900:2900`
   6. Modify this openc3-traefik line to remove the ip address and modify the first port number if desired **(Note: leave the last :2943)**: `127.0.0.1:2943:2943`
4. Edit ./openc3-traefik/traefik-ssl.yaml
   1. Update line 22 to your domain: - main: "mydomain.com" # Update with your domain
5. Start OpenC3
   - On Linux/Mac: ./openc3.sh run
   - On Windows: openc3.bat run
6. After approximately 2 minutes, open a web browser to https://mydomain.com
   - If you run "docker ps", you can watch until the openc3-cosmos-init container completes, at which point the system should be fully configured and ready to use.

## Open to the network using a global certificate from Let's Encrypt

Warning: These directions only work when exposing COSMOS to the internet. Make sure you understand the risks and have properly configured your server settings and firewall.

1. Make sure that your public DNS settings are mapping your domain name to your server
2. Edit compose.yaml
   1. Comment out this openc3-traefik line: `./openc3-traefik/traefik.yaml:/etc/traefik/traefik.yaml:z`
   2. Uncomment this openc3-traefik line: `./openc3-traefik/traefik-letsencrypt.yaml:/etc/traefik/traefik.yaml`
   3. Comment out this openc3-traefik line: `127.0.0.1:2900:2900`
   4. Comment out this openc3-traefik line: `127.0.0.1:2943:2943`
   5. Uncomment out this openc3-traefik line: `80:2900`
   6. Uncomment out this openc3-traefik line: `443:2943`
3. Start OpenC3
   - On Linux/Mac: ./openc3.sh run
   - On Windows: openc3.bat run
4. After approximately 2 minutes, open a web browser to https://mydomain.com
   - If you run "docker ps", you can watch until the openc3-cosmos-init container completes, at which point the system should be fully configured and ready to use.

## Open to the network insecurely using http

Warning: This is not recommended except for temporary testing on a local network. This will send plain text passwords over the network!

1. Edit compose.yaml
   1. Comment out this openc3-traefik line: `./openc3-traefik/traefik.yaml:/etc/traefik/traefik.yaml:z`
   2. Uncomment this openc3-traefik line: `./openc3-traefik/traefik-allow-http.yaml:/etc/traefik/traefik.yaml`
   3. Modify this openc3-traefik line to remove the ip address and optionally modify the first port number if desired **(Note: leave the last :2900)**: `127.0.0.1:2900:2900`
2. Start OpenC3
   - On Linux/Mac: ./openc3.sh run
   - On Windows: openc3.bat run
3. In the Chrome Browser go to: chrome://flags/#unsafely-treat-insecure-origin-as-secure or Edge go to: edge://flags/#unsafely-treat-insecure-origin-as-secure
   1. Add your `http://<Your IP Address>:2900`
   2. Enable the Setting
   3. Completely restart Chrome. On MacOS make sure the dot below the icon in chrome is gone by long pressing the icon and choosing Quit.
4. After approximately 2 minutes, open a web browser to `http://<Your IP Address>:2900` (or different port if changed above)
   - If you run "docker ps", you can watch until the openc3-cosmos-init container completes, at which point the system should be fully configured and ready to use.

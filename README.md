# OpenC3 Project

This git repo is used as a starting point for running and configuring OpenC3 for your specific project.
It includes the necessary scripts to run OpenC3, but does not come with all the source code and relies on
running released containers rather than building containers from source.  This is the recommended starting
place for any project who wants to use OpenC3, but not develop the core system.

## Quick Start

1. Edit .env and change OPENC3_TAG to the specific version you would like to run (ie. OPENC3_TAG=5.0.8)
    1. This will allow you to upgrade versions when you choose rather than following latest
2. Start OpenC3
    1. On Linux/Mac: ./openc3.sh run
    2. On Windows: openc3.bat run
3. After approximately 2 minutes, open a web browser to http://localhost:2900
    1. If you run "docker ps", you can watch until the openc3-init container completes, at which point the system should be fully configured and ready to use.
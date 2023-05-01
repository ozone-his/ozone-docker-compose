# Ozone FOSS Manual setup

Welcome to the Ozone FOSS manual setup guide. This guide details the setup of Ozone FOSS step by step.

- [Prerequisites](#prerequisites)
- [Manual Setup Steps](#manual-setup-steps)
  * [Step 1. Create your working directory](#step-1-create-your-working-directory)
  * [Step 2. Clone the ozone-docker project](#step-2-clone-the-ozone-docker-project)
  * [Step 3. Destroy the running instance containers](#step-3-destroy-the-running-instance-containers)
  * [Step 4. Download and extract the distribution](#step-4-download-and-extract-the-distribution)
  * [Step 5. Export all needed environment variables](#step-5-export-all-needed-environment-variables)
  * [Step 6. Setting up Traefik](#step-6-setting-up-traefik)
  * [Step 7. Start Ozone](#step-7-start-ozone)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>(Table of contents generated with markdown-toc)</a></i></small>


## Prerequisites
* Install Git, Maven and Docker Compose
* ⚠️ On Linux: create the `docker` user group and add your user to it. Checkout the guide [here](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).
  * we assume in our setup instructions that you run the `docker` command as the same user and in the same window in which you exported your variables. If Docker is run as `sudo` (which is not recommended), your user's envvars will not have any effect as `su` (or `root`). Make sure to either export them as `su` as well, or use `sudo -E docker` to preserve the user envvars as `su`.


## Manual Setup Steps
### Step 1. Create your working directory

Move to the location of your choice, e.g., your home folder:

```bash
cd ~/
```

Then create the Ozone working directory and save the path:
```bash
export OZONE_DIR=$PWD/ozone && \
mkdir -p $OZONE_DIR && cd $OZONE_DIR
```
### Step 2. Clone the ozone-docker project

```bash
git clone https://github.com/ozone-his/ozone-docker
```

```bash
cd ozone-docker
```

### Step 3. Destroy the running instance containers
If you have already set up Ozone before you may need to clean up your local environment first:

```bash
./destroy-demo.sh
```

### Step 4. Download and extract the distribution

```bash
export VERSION=1.0.0-alpha.1 && \
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:get -DremoteRepositories=https://nexus.mekomsolutions.net/repository/maven-public -Dartifact=com.ozonehis:ozone-distro:$VERSION:zip -Dtransitive=false --legacy-local-repository && \
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:unpack -Dproject.basedir=$OZONE_DIR -Dartifact=com.ozonehis:ozone-distro:$VERSION:zip -DoutputDirectory=$OZONE_DIR/ozone-distro-$VERSION
```

### Step 5. Export all needed environment variables

The Ozone Docker project relies on a number of environment variables (env vars) to document where the distro assets are expected to be found.
For the sample demo you can export the following env vars:
```bash
export DISTRO_GROUP=ozone-demo; \

export DISTRO_PATH=$OZONE_DIR/ozone-distro-$VERSION;  \

export OPENMRS_CONFIG_PATH=$DISTRO_PATH/openmrs_config;  \
export OZONE_CONFIG_PATH=$DISTRO_PATH/ozone_config;  \
export OPENMRS_CORE_PATH=$DISTRO_PATH/openmrs_core;  \
export OPENMRS_MODULES_PATH=$DISTRO_PATH/openmrs_modules;  \
export EIP_PATH=$DISTRO_PATH/eip_config; \
export SPA_PATH=$DISTRO_PATH/spa;\
export SENAITE_CONFIG_PATH=$DISTRO_PATH/senaite_config; \
export SUPERSET_CONFIG_PATH=$DISTRO_PATH/superset_config;\

export ODOO_EXTRA_ADDONS=$DISTRO_PATH/odoo_config/addons;\
export ODOO_CONFIG_PATH=$DISTRO_PATH/odoo_config/odoo_csv;\
export ODOO_INITIALIZER_CONFIG_FILE_PATH=$DISTRO_PATH/odoo_config/config/initializer_config.json;\
export ODOO_CONFIG_FILE_PATH=$DISTRO_PATH/odoo_config/config/odoo.conf
export O3_FRONTEND_TAG=3.0.0-beta.2
```
#### For developers: Override of `DISTRO_PATH`

If you are doing development on Ozone and are building the Ozone distro in your local environment, then you would need to override `DISTRO_PATH` to point to your distro build folder. For example if your working folder is `/your/path/to/ozone-distro` for the distro then you would want to do something like this:
```bash
export DISTRO_PATH=/your/path/to/ozone-distro/target/ozone-distro-$VERSION
```
### Step 6. Setting up Traefik

#### Using Traefik Proxy

⚠️ This will not work in Gitpod.

When you are running a project with Traefik, it assumes that there is already a properly configured Traefik reverse proxy that is running in the `web` Docker network. To simplify this process for development purposes, you can use the pre-configured Traefik reverse proxy provided by `https://github.com/mekomsolutions/traefik-docker-compose-dev`.

However, in a production environment, Traefik needs to be configured with a wildcard domain that points to it. This allows for the configuration of subdomains for different components. 

For development purposes using Traefik, you also need to use domains, and the special domain `traefik.me` is relied upon for this purpose.

#### Traefik hostnames on macOS

In Linux, the domain `app-172-17-0-1.traefik.me` will resolve the Docker host IP `172.17.0.1` without any special considerations. However, Docker desktop for macOS does not provide a static IP address, which makes it challenging to use the `traefik.me` domain in the same way.

The only way to use the `traefik.me` domain with Docker on macOS is to use the IP address assigned to the host. This means that instead of using `app-172-17-0-1.traefik.me`, you would need to use the IP address of the Docker host machine in your configuration.

The default hostnames 
```bash
O3_HOSTNAME=emr-172-17-0-1.traefik.me
ODOO_HOSTNAME=erp-172-17-0-1.traefik.me
SENAITE_HOSTNAME=lims-172-17-0-1.traefik.me
SUPERSET_HOSTNAME=analytics-172-17-0-1.traefik.me
```
will work only on Linux. On macOS you have to set the IP to your ethernet IP by setting the following envvars:
```bash
export IP="${$(ipconfig getifaddr en0)//./-}"; \
export O3_HOSTNAME=emr-"${IP}.traefik.me"; \
export ODOO_HOSTNAME=erp-"${IP}.traefik.me";  \
export SENAITE_HOSTNAME=lims-"${IP}.traefik.me";  \
export SUPERSET_HOSTNAME=analytics-"${IP}.traefik.me";  
```

### Step 7. Start Ozone
#### With Traefik

```bash
docker compose -p $DISTRO_GROUP up
```
#### With Apache 2

```bash
docker compose -f docker-compose.yml -f docker-compose-proxy.yml -p $DISTRO_GROUP up
```

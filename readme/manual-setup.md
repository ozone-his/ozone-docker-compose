# Ozone FOSS Manual setup

Welcome to the Ozone FOSS manual setup guide. This guide details the setup of Ozone FOSS step by step.

- [Ozone FOSS Manual setup](#ozone-foss-manual-setup)
  * [Prerequisites](#prerequisites)
  * [Manual Setup Steps](#manual-setup-steps)
    + [Step 1. Clone the ozone-docker project](#step-1-clone-the-ozone-docker-project)
    + [Step 2. (Optional) Destroy any running containers from previous trials](#step-2--optional--destroy-any-running-containers-from-previous-trials)
    + [Step 3. Download the Ozone distribution](#step-3-download-the-ozone-distribution)
    + [Step 4. Export needed environment variables](#step-4-export-needed-environment-variables)
    + [Step 5. (Optional) Activate Ozone demo data generation](#step-5--optional--activate-ozone-demo-data-generation)
    + [Step 6. Create the public Docker network](#step-6-create-the-public-docker-network)
    + [Step 7. (Optional) Set up Traefik](#step-7--optional--set-up-traefik)
    + [Step 8. Start Ozone](#step-8-start-ozone)
    + [Step 9. Browse Ozone](#step-9-browse-ozone)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>




## Prerequisites
* Install Git, Maven and Docker Compose
* ⚠️ On Linux: create the `docker` user group and add your user to it. Checkout the guide [here](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).
  * We assume in our setup instructions that you run the `docker` command as the same user and in the same window in which you exported your variables. If Docker is run as `sudo` (which is not recommended), your user's envvars will not have any effect as `su` (or `root`). Make sure to either export them as `su` as well, or use `sudo -E docker` to preserve the user envvars as `su`.


## Manual Setup Steps
### Step 1. Clone the ozone-docker project
```bash
git clone https://github.com/ozone-his/ozone-docker
```

```bash
cd ozone-docker
```

### Step 2. (Optional) Destroy any running containers from previous trials
If you have already set up Ozone before you may need to clean up your local environment first:

```bash
./destroy-demo.sh
```

### Step 3. Download the Ozone distribution

Create a directory to download Ozone distro:
```bash
export OZONE_DIR=$PWD/ozone && \
mkdir -p $OZONE_DIR
```

Set the Ozone distro version to use:
```bash
export VERSION=1.0.0-alpha.7&& \
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:get -DremoteRepositories=https://nexus.mekomsolutions.net/repository/maven-public -Dartifact=com.ozonehis:ozone-distro:$VERSION:zip -Dtransitive=false --legacy-local-repository && \
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:unpack -Dproject.basedir=$OZONE_DIR -Dartifact=com.ozonehis:ozone-distro:$VERSION:zip -DoutputDirectory=$OZONE_DIR/ozone-distro-$VERSION
```

### Step 4. Export needed environment variables

The Ozone Docker project relies on a number of environment variables (env vars) to document where the distro assets are expected to be found.
For the sample demo those vars are provided in the [start-demo.env](../start-demo.env) file.
```bash
source start-demo.env
```

### Step 5. (Optional) Activate Ozone demo data generation

The generation of demo data is handled by a separate service that can be opted in or out. This service is configured with an EIP route that takes care of generating demo data 10 minutes after Ozone has started.

⚠️ The demo data service currently only handles _OpenMRS_ demo data.

To set the number of demo patients to be generated:
```bash
export NUMBER_OF_DEMO_PATIENTS=50
```

### Step 6. Create the public Docker network
```bash
docker network create web
```

### Step 7. (Optional) Set up Traefik

This step is optional but recommended since Traefik brings many benefits as a reverse proxy for your Ozone project. 

Traefik solves a known URL redirection issue that will show up when using Apache 2. Incorrect `/spahome` redirections occur (instead of of the correct `/spa/home` path), leading to disrupting 404 errors that need to be corrected manually by changing the incorrect URL in the browser's address bar.

⚠️ Traefik will not work in Gitpod.

#### Using Traefik proxy

When you select to use Traefik as the proxy for this project, it requires a properly configured Traefik reverse proxy that is already running in the `web` Docker network that was created earlier.
To make things easier for development purposes, you can use a pre-configured Traefik reverse proxy that is provided at [mekomsolutions/traefik-docker-compose-dev](https://github.com/mekomsolutions/traefik-docker-compose-dev). This saves you the time and effort required to set up and configure a new Traefik reverse proxy from scratch.

It is better to use domains with Traefik and we will rely on the special domain `traefik.me` for this purpose.

⚠️ The special domain `traefik.me` requires access to the Internet.

#### Traefik hostnames on macOS

In Linux, the domain `app-172-17-0-1.traefik.me` will resolve the Docker host IP `172.17.0.1` without any special considerations. However, Docker desktop for macOS does not provide a static IP address, which makes it challenging to use the `traefik.me` domain in the same way.

The only way to use the `traefik.me` domain with Docker on macOS is to use the IP address assigned to the host. This means that instead of using `app-172-17-0-1.traefik.me`, you would need to use the IP address of the Docker host machine in your configuration.

The default hostnames below will only work on Linux:
```bash
export O3_HOSTNAME=emr-172-17-0-1.traefik.me; \
export ODOO_HOSTNAME=erp-172-17-0-1.traefik.me; \
export SENAITE_HOSTNAME=lims-172-17-0-1.traefik.me; \
export SUPERSET_HOSTNAME=analytics-172-17-0-1.traefik.me;
```
On macOS you need the extra step to set the IP to your ethernet IP like this:
```bash
export IP="${$(ipconfig getifaddr en0)//./-}"; \
export O3_HOSTNAME=emr-"${IP}.traefik.me"; \
export ODOO_HOSTNAME=erp-"${IP}.traefik.me";  \
export SENAITE_HOSTNAME=lims-"${IP}.traefik.me";  \
export SUPERSET_HOSTNAME=analytics-"${IP}.traefik.me";  
```

### Step 8. Start Ozone

#### With Apache 2

```bash
docker compose -f docker-compose-common.yml -f docker-compose-openmrs.yml -f docker-compose-senaite.yml -f docker-compose-odoo.yml -f docker-compose-superset.yml -f demo/docker-compose.yml -f proxy/docker-compose.yml up -d --build
```
#### With Traefik

```bash
docker compose -f docker-compose-common.yml -f docker-compose-openmrs.yml -f docker-compose-senaite.yml -f docker-compose-odoo.yml -f docker-compose-superset.yml -f demo/docker-compose.yml up -d
```

### Step 9. Browse Ozone
Ozone FOSS requires you to log into each component separately:

| HIS Component     | Apache 2 URL                  | Traefik (Linux) URL                       | Username | Password |
|-------------------|-------------------------------|-------------------------------------------|----------|----------|
| OpenMRS 3         | http://localhost/openmrs/spa  | https://emr-172-17-0-1.traefik.me         | admin    | Admin123 |
| OpenMRS Legacy UI | http://localhost/openmrs      | https://emr-172-17-0-1.traefik.me/openmrs | admin    | Admin123 |
| SENAITE           | http://localhost:8081/senaite | https://lims-172-17-0-1.traefik.me        | admin    | password |
| Odoo              | http://localhost:8069         | https://erp-172-17-0-1.traefik.me         | admin    | admin    |
| Superset          | http://localhost:8088         | https://analytics-172-17-0-1.traefik.me   | admin    | password |

⚠️ If you started the project with Traefik on macOS the coordinates for the components will be different and you will have to replace "`172-17-0-1`" with your host IP.
E.g. if your host IP is 192.168.200.197, https://emr-172-17-0-1.traefik.me will have to become https://emr-192-168-200-197.traefik.me, etc.


# Ozone HIS - The Docker Compose Project

>_The entreprise-grade health information system that augments OpenMRS 3._

This is the official Docker Compose project to start and run an Ozone HIS server.

## Quick Start
```
$ git clone https://github.com/ozone-his/ozone-docker
$ cd ozone-docker
$ ./start-demo.sh
```
It may take some time to download and setup Ozone, so hang tight :-)

Then [start browsing](#browse-ozone-his) Ozone FOSS.

## Manual Setup

### Create your working directory

Move to the location of your choice, e.g., your home folder:
```
$ cd ~/
```
Then create the working directory and save the path:
```
$ export OZONE_DIR=$PWD/ozone && \
mkdir -p $OZONE_DIR && cd $OZONE_DIR
```
### Clone the docker-compose project

```
$ git clone https://github.com/ozone-his/ozone-docker
```

```
$ cd ozone-docker
```

### Download and extract the distro

```
$ export VERSION=1.0.0-SNAPSHOT && \
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:get -DremoteRepositories=https://nexus.mekomsolutions.net/repository/maven-public -Dartifact=net.mekomsolutions:ozone-distro:$VERSION:zip -Dtransitive=false --legacy-local-repository && \
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:unpack -Dproject.basedir=$OZONE_DIR -Dartifact=net.mekomsolutions:ozone-distro:$VERSION:zip -DoutputDirectory=$OZONE_DIR/ozone-distro-$VERSION
```

### Export all needed env vars

The Ozone Docker project relies on a number of environment variables to document where the distro sources assets are to be found.
For the sample demo you can export the following variables:
```
DISTRO_GROUP=ozone-demo; \
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
export ODOO_CONFIG_FILE_PATH=$DISTRO_PATH/odoo_config/config/initializer_config.json
```

### Start Ozone HIS

```
$ docker-compose -p $DISTRO_GROUP up
```

**Important:** This assumes that you run the `docker` command as the same user and in the same window in which you exported your variables.
If Docker is run as `sudo` the variables will not be defined. Make sure to either export them as `root`, or run `docker` with `sudo -E` option to preserve the user environment. See also ['Post-installation steps for Linux'](https://docs.docker.com/engine/install/linux-postinstall/).

### Browse Ozone HIS

| HIS Component     | URL                            | Username | Password |
|-------------------|--------------------------------|----------|----------|
| OpenMRS 3         | http://172.17.0.1/openmrs/spa  | admin    | Admin123 |
| OpenMRS Legacy UI | http://172.17.0.1/openmrs      | admin    | Admin123 |
| SENAITE           | http://172.17.0.1:8081/senaite | admin    | admin    |
| Odoo              | http://172.17.0.1:8069         | admin    | admin    |

## Find Us
[Website](http://ozone-his.com) - [Forum](https://talk.openmrs.org/c/software/ozone-his) - [Slack](https://openmrs.slack.com/archives/C02PYQD5D0A)

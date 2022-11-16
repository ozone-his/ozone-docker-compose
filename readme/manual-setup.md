## Ozone FOSS Manual setup

Welcome to the Ozone FOSS manual setup guide. This guide details the setup of Ozone FOSS step by step.

### Create your working directory

Move to the location of your choice, e.g., your home folder:
```bash
$ cd ~/
```
Then create the Ozone working directory and save the path:
```bash
$ export OZONE_DIR=$PWD/ozone && \
mkdir -p $OZONE_DIR && cd $OZONE_DIR
```
### Clone the docker-compose project

```bash
$ git clone https://github.com/ozone-his/ozone-docker
```

```bash
$ cd ozone-docker
```

### Download and extract the distro

```bash
$ export VERSION=1.0.0-SNAPSHOT && \
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:get -DremoteRepositories=https://nexus.mekomsolutions.net/repository/maven-public -Dartifact=net.mekomsolutions:ozone-distro:$VERSION:zip -Dtransitive=false --legacy-local-repository && \
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:unpack -Dproject.basedir=$OZONE_DIR -Dartifact=net.mekomsolutions:ozone-distro:$VERSION:zip -DoutputDirectory=$OZONE_DIR/ozone-distro-$VERSION
```

### Export all needed environment variables

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
```
### I am developper with a local build of Ozone

If you are developing on Ozone and are building the Ozone distro in your local environment, then you would need to override `DISTRO_PATH` to point to where your distro build folder actually is. For example if your working folder is `/your/path/to/ozone-distro` for the distro then you would want to do something like this:
```bash
export DISTRO_PATH=/your/path/to/ozone-distro/target/ozone-distro-1.0.0-SNAPSHOT
```

### Start Ozone
```bash
$ docker-compose -p $DISTRO_GROUP up
```

**Important:** This assumes that you run the `docker` command as the same user and in the same window in which you exported your variables. The variables will not be defined if Docker is run as `sudo`. Make sure to either export them as `root`, or run `docker` with `sudo -E` option to preserve the user environment. See also ['Post-installation steps for Linux'](https://docs.docker.com/engine/install/linux-postinstall/) for more details.

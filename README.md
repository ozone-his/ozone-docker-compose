# Ozone HIS - The Docker Compose Project

This is the official Docker Compose project to start and run an Ozone HIS server.

## Quick Start
### Gathering the distro artifacts:
First, you need to gather all required artifacts out of [ozone-distro](https://github.com/ozone-his/ozone-distro):
```
$ git clone  https://github.com/ozone-his/ozone-distro
$ cd ozone-distro
$ mvn clean package
```
Let us name your sample demo Ozone instance "demo" by exporting the envvar `DISTRO_GROUP`:
```
export DISTRO_GROUP="demo"
```
Then unzip the demo distro .zip artifact in a temp folder:
```
$ unzip target/ozone-distro-1.0.0-SNAPSHOT.zip -d /tmp/ozone-distro-$DISTRO_GROUP/
```  

### Clone the project:
Switch to another terminal window then:
```
git clone https://github.com/ozone-his/ozone-docker
cd ozone-docker
```

Export your sample distro name as envvar here as well:
```
export DISTRO_GROUP="demo"
```

### Export all needed envvars:

The Ozone Docker project relies on a number of environment variables to document where the distro sources assets are to be found.
For the sample demo you can export the following variables:
```
export DISTRO_PATH=/tmp/ozone-distro-$DISTRO_GROUP;  \
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
export ODOO_CONFIG_FILE_PATH=$DISTRO_PATH/odoo_config/config/initializer_config.json;\
```

### Start Ozone HIS:

```
docker-compose -p $DISTRO_GROUP up
```

**Important:** This assumes that you run the `docker` command as the same user and in the same window in which you exported your variables.
If Docker is run as `sudo` the variables will not be defined. Make sure to either export them as `root`, or run `docker` with `sudo -E` option to preserve the user environment. See also ['Post-installation steps for Linux'](https://docs.docker.com/engine/install/linux-postinstall/).

### Start Browsing Ozone HIS:

| HIS Component     | URL                            | Username | Password |
|-------------------|--------------------------------|----------|----------|
| OpenMRS 3         | http://172.17.0.1/openmrs/spa  | admin    | Admin123 |
| OpenMRS Legacy UI | http://172.17.0.1/openmrs      | admin    | Admin123 |
| SENAITE           | http://172.17.0.1:8081/senaite | admin    | admin    |
| Odoo              | http://172.17.0.1:8069         | admin    | admin    |
| Superset          | http://172.17.0.1:8088         | admin    | admin    |

## Find Us
[Website](http://ozone-his.com) - [Forum](https://talk.openmrs.org/c/software/ozone-his) - [Slack](https://openmrs.slack.com/archives/C02PYQD5D0A)
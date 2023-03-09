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
### Clone the ozone-docker project

```bash
$ git clone https://github.com/ozone-his/ozone-docker
```

```bash
$ cd ozone-docker
```

### Destroy the running instance containers
If you have already set up Ozone before you may need to clean up your local environment first:

<table>
<tr>
<td> macOS </td> <td> Linux </td>
</tr>
<tr>
<td>

```bash
$ ./destroy-demo.sh
```

</td>
<td>

```bash
$ sudo -E ./destroy-demo.sh
```

</td>
</tr>
</table>

### Download and extract the distro

```bash
$ export VERSION=1.0.0-alpha.1 && \
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:get -DremoteRepositories=https://nexus.mekomsolutions.net/repository/maven-public -Dartifact=com.ozonehis:ozone-distro:$VERSION:zip -Dtransitive=false --legacy-local-repository && \
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:unpack -Dproject.basedir=$OZONE_DIR -Dartifact=com.ozonehis:ozone-distro:$VERSION:zip -DoutputDirectory=$OZONE_DIR/ozone-distro-$VERSION
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
### I am a developer with a local build of Ozone

If you are developing on Ozone and are building the Ozone distro in your local environment, then you would need to override `DISTRO_PATH` to point to your distro build folder. For example if your working folder is `/your/path/to/ozone-distro` for the distro then you would want to do something like this:
```bash
$ export DISTRO_PATH=/your/path/to/ozone-distro/target/ozone-distro-1.0.0-SNAPSHOT
```

### Start Ozone
<table>
<tr>
<td> macOS </td> <td> Linux </td>
</tr>
<tr>
<td>

```bash
$ docker compose -p $DISTRO_GROUP up
```

</td>
<td>

```bash
$ sudo -E docker compose -p $DISTRO_GROUP up
```

</td>
</tr>
</table>

**Note:** On Linux we advise to run `docker` with `sudo -E` option to preserve the user environment. See also ['Post-installation steps for Linux'](https://docs.docker.com/engine/install/linux-postinstall/) for more details.

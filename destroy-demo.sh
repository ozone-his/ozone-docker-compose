#!/usr/bin/env bash
export OZONE_DIR=$PWD/ozone && \
mkdir -p $OZONE_DIR
# Download the project && \
export VERSION=1.0.0-SNAPSHOT
export DISTRO_PATH=$OZONE_DIR/ozone-distro-$VERSION
export OPENMRS_CONFIG_PATH=$DISTRO_PATH/openmrs_config
export OZONE_CONFIG_PATH=$DISTRO_PATH/ozone_config
export OPENMRS_CORE_PATH=$DISTRO_PATH/openmrs_core
export OPENMRS_MODULES_PATH=$DISTRO_PATH/openmrs_modules
export EIP_PATH=$DISTRO_PATH/eip_confi
export SPA_PATH=$DISTRO_PATH/spa
export SENAITE_CONFIG_PATH=$DISTRO_PATH/senaite_config
export ODOO_EXTRA_ADDONS=$DISTRO_PATH/odoo_config/addons
export ODOO_CONFIG_PATH=$DISTRO_PATH/odoo_config/odoo_csv
export ODOO_CONFIG_FILE_PATH=$DISTRO_PATH/odoo_config/config/inializer_config.json;
DOCKER_SERVER_VERSION=$(docker version -f "{{.Server.Version}}")
DOCKER_SERVER_VERSION_MAJOR=$(echo "$DOCKER_SERVER_VERSION"| cut -d'.' -f 1)
DOCKER_SERVER_VERSION_MINOR=$(echo "$DOCKER_SERVER_VERSION"| cut -d'.' -f 2)
DOCKER_SERVER_VERSION_BUILD=$(echo "$DOCKER_SERVER_VERSION"| cut -d'.' -f 3)

if [ "${DOCKER_SERVER_VERSION_MAJOR}" -ge 20 ] && \
   [ "${DOCKER_SERVER_VERSION_MINOR}" -ge 10 ]  && \
   [ "${DOCKER_SERVER_VERSION_BUILD}" -ge 13 ]; then
    echo "Docker version >= 20.10.13 using docker compose v2"
    docker compose down -v
else
    echo "Docker version < 20.10.13 using docker compose v1"
    docker-compose down -v
fi
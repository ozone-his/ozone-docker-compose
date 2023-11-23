#!/usr/bin/env bash

function setupDirs () {
    # Create the Ozone directory
    source ozone-dir.env
    mkdir -p $OZONE_DIR

    # Export the DISTRO_PATH value
    export DISTRO_PATH=$OZONE_DIR
}

function exportPaths () {
    export OPENMRS_CONFIG_PATH=$DISTRO_PATH/configs/openmrs/initializer_config
    export OPENMRS_PROPERTIES_PATH=$DISTRO_PATH/configs/openmrs/properties
    export OPENMRS_MODULES_PATH=$DISTRO_PATH/binaries/openmrs/modules
    export SPA_PATH=$DISTRO_PATH/spa
    export SENAITE_CONFIG_PATH=$DISTRO_PATH/configs/senaite/initializer_config
    export ODOO_EXTRA_ADDONS=$DISTRO_PATH/binaries/odoo/addons
    export ODOO_CONFIG_PATH=$DISTRO_PATH/configs/odoo/initializer_config/
    export ODOO_CONFIG_FILE_PATH=$DISTRO_PATH/configs/odoo/config/odoo.conf
    export EIP_ODOO_OPENMRS_ROUTES_PATH=$DISTRO_PATH/binaries/eip-odoo-openmrs/routes
    export EIP_ODOO_OPENMRS_PROPERTIES_PATH=$DISTRO_PATH/configs/eip-odoo-openmrs/properties
    export EIP_OPENMRS_SENAITE_ROUTES_PATH=$DISTRO_PATH/binaries/eip-openmrs-senaite/routes
    export EIP_OPENMRS_SENAITE_PROPERTIES_PATH=$DISTRO_PATH/configs/eip-openmrs-senaite/properties
    export OPENMRS_FRONTEND_CONFIG_PATH=$DISTRO_PATH/configs/openmrs/frontend_config/
    export SQL_SCRIPTS_PATH=$DISTRO_PATH/data/
    export SUPERSET_CONFIG_PATH=$DISTRO_PATH/configs/superset/
}

function setDockerComposeCLIOptions () {
    # Parse 'docker-compose-files.txt' to get the list of Docker Compose files to run
    dockerComposeFiles=$(cat docker-compose-files.txt)
    for file in ${dockerComposeFiles}
    do
        export dockerComposeFilesCLIOptions="$dockerComposeFilesCLIOptions -f ../$file"
    done

    # Use the concatenated.env file if one is provided
    concatenatedEnvFilePath="../concatenated.env"
    if [ -f "$concatenatedEnvFilePath" ]; then
        export dockerComposeEnvFileCLIOption="--env-file $concatenatedEnvFilePath"
    fi

    export dockerComposeOzoneCLIOptions="$dockerComposeEnvFileCLIOption $dockerComposeFilesCLIOptions"

    # Set args for the proxy service
    export dockerComposeProxyCLIOptions="--env-file ../.env -f ../proxy/docker-compose.yml"

    # Set args for the demo service
    export dockerComposeDemoCLIOptions="--env-file ../.env -f ../demo/docker-compose.yml"
}

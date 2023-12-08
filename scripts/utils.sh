#!/usr/bin/env bash

export TEXT_BLUE=`tput setaf 4`
export TEXT_RED=`tput setaf 1`
export BOLD=`tput bold`
export RESET_FORMATTING=`tput sgr0`
INFO="$TEXT_BLUE$BOLD[INFO]$RESET_FORMATTING"
ERROR="$TEXT_RED$BOLD[ERROR]$RESET_FORMATTING"

function setupDirs () {
    # Create the Ozone directory
    source ozone-dir.env
    mkdir -p $OZONE_DIR

    # Export the DISTRO_PATH value
    export DISTRO_PATH=$OZONE_DIR
    echo "→ DISTRO_PATH=$DISTRO_PATH"
}

function exportPaths () {

    echo "$INFO Exporting distro paths..."
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

    echo "→ OPENMRS_CONFIG_PATH=$OPENMRS_CONFIG_PATH"
    echo "→ OPENMRS_PROPERTIES_PATH=$OPENMRS_PROPERTIES_PATH"
    echo "→ OPENMRS_MODULES_PATH=$OPENMRS_MODULES_PATH"
    echo "→ SPA_PATH=$SPA_PATH"
    echo "→ SENAITE_CONFIG_PATH=$SENAITE_CONFIG_PATH"
    echo "→ ODOO_EXTRA_ADDONS=$ODOO_EXTRA_ADDONS"
    echo "→ ODOO_CONFIG_PATH=$ODOO_CONFIG_PATH"
    echo "→ ODOO_CONFIG_FILE_PATH=$ODOO_CONFIG_FILE_PATH"
    echo "→ EIP_ODOO_OPENMRS_ROUTES_PATH=$EIP_ODOO_OPENMRS_ROUTES_PATH"
    echo "→ EIP_ODOO_OPENMRS_PROPERTIES_PATH=$EIP_ODOO_OPENMRS_PROPERTIES_PATH"
    echo "→ EIP_OPENMRS_SENAITE_ROUTES_PATH=$EIP_OPENMRS_SENAITE_ROUTES_PATH"
    echo "→ EIP_OPENMRS_SENAITE_PROPERTIES_PATH=$EIP_OPENMRS_SENAITE_PROPERTIES_PATH"
    echo "→ OPENMRS_FRONTEND_CONFIG_PATH=$OPENMRS_FRONTEND_CONFIG_PATH"
    echo "→ SQL_SCRIPTS_PATH=$SQL_SCRIPTS_PATH"
    echo "→ SUPERSET_CONFIG_PATH=$SUPERSET_CONFIG_PATH"
    
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
    export dockerComposeProxyCLIOptions="--env-file $concatenatedEnvFilePath -f ../proxy/docker-compose.yml"

    # Set args for the demo service
    export dockerComposeDemoCLIOptions="--env-file $concatenatedEnvFilePath -f ../demo/docker-compose.yml"
}

function setTraefikIP {

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        # Using the static Docker IP
        export IP="172.17.0.1"
        echo "$INFO 'linux-gnu' OS detected, using Docker static IP ($IP) in Traefik hostnames..."
        export IP="172.17.0.1"
        export IP_WITH_DASHES="${IP//./-}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        # Fetching the LAN IP
        export IP=$(ipconfig getifaddr en0)
        echo "$INFO 'darwin' OS detected, using LAN IP ($IP) in Traefik hostnames..."
        export IP_WITH_DASHES="${IP//./-}"
    fi
}

function setTraefikHostnames {
    echo "$INFO Exporting Traefik hostnames..."

    export O3_HOSTNAME=emr-"${IP_WITH_DASHES}.traefik.me"
    export ODOO_HOSTNAME=erp-"${IP_WITH_DASHES}.traefik.me"
    export SENAITE_HOSTNAME=lims-"${IP_WITH_DASHES}.traefik.me"
    export SUPERSET_HOSTNAME=analytics-"${IP_WITH_DASHES}.traefik.me"
    echo "→ O3_HOSTNAME=$O3_HOSTNAME"
    echo "→ ODOO_HOSTNAME=$ODOO_HOSTNAME"
    echo "→ SENAITE_HOSTNAME=$SENAITE_HOSTNAME"
    echo "→ SUPERSET_HOSTNAME=$SUPERSET_HOSTNAME"

}

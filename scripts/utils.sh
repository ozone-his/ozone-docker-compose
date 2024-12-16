#!/usr/bin/env bash

export TEXT_BLUE=`tput setaf 4`
export TEXT_RED=`tput setaf 1`
export TEXT_YELLOW=`tput setaf 3`
export BOLD=`tput bold`
export RESET_FORMATTING=`tput sgr0`
INFO="$TEXT_BLUE$BOLD[INFO]$RESET_FORMATTING"
ERROR="$TEXT_RED$BOLD[ERROR]$RESET_FORMATTING"
WARN="$TEXT_YELLOW$BOLD[WARN]$RESET_FORMATTING"

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
    export OPENMRS_TOMCAT_CONFIG_PATH=$DISTRO_PATH/configs/openmrs/tomcat
    export OPENMRS_MODULES_PATH=$DISTRO_PATH/binaries/openmrs/modules
    export SPA_PATH=/openmrs/spa
    export SENAITE_CONFIG_PATH=$DISTRO_PATH/configs/senaite/initializer_config
    export SENAITE_OIDC_CONFIG_PATH=$DISTRO_PATH/configs/senaite/oidc
    export ODOO_EXTRA_ADDONS=$DISTRO_PATH/binaries/odoo/addons
    export ODOO_CONFIG_PATH=$DISTRO_PATH/configs/odoo/initializer_config/
    export ODOO_CONFIG_FILE_PATH=$DISTRO_PATH/configs/odoo/config/odoo.conf
    export EIP_ODOO_OPENMRS_ROUTES_PATH=$DISTRO_PATH/binaries/eip-odoo-openmrs
    export EIP_OPENMRS_SENAITE_ROUTES_PATH=$DISTRO_PATH/binaries/eip-openmrs-senaite
    export EIP_ERPNEXT_OPENMRS_ROUTES_PATH=$DISTRO_PATH/binaries/eip-erpnext-openmrs
    export OPENMRS_FRONTEND_BINARY_PATH=$DISTRO_PATH/binaries/openmrs/frontend
    export OPENMRS_FRONTEND_CONFIG_PATH=$DISTRO_PATH/configs/openmrs/frontend_config
    export SQL_SCRIPTS_PATH=$DISTRO_PATH/data/
    export ERPNEXT_CONFIG_PATH=$DISTRO_PATH/configs/erpnext/initializer_config/
    export ERPNEXT_SCRIPTS_PATH=$DISTRO_PATH/binaries/erpnext/scripts/
    export KEYCLOAK_CONFIG_PATH=$DISTRO_PATH/configs/keycloak
    export BAHMNI_OPENMRS_MODULES_PATH=$DISTRO_PATH/binaries/bahmniemr/modules
    export BAHMNI_CONFIG_OVERRIDE_VOLUME=$DISTRO_PATH/configs/bahmni

    echo "→ OPENMRS_CONFIG_PATH=$OPENMRS_CONFIG_PATH"
    echo "→ OPENMRS_PROPERTIES_PATH=$OPENMRS_PROPERTIES_PATH"
    echo "→ OPENMRS_MODULES_PATH=$OPENMRS_MODULES_PATH"
    echo "→ OPENMRS_TOMCAT_CONFIG_PATH=$OPENMRS_TOMCAT_CONFIG_PATH"
    echo "→ SPA_PATH=$SPA_PATH"
    echo "→ SENAITE_CONFIG_PATH=$SENAITE_CONFIG_PATH"
    echo "→ SENAITE_OIDC_CONFIG_PATH=$SENAITE_OIDC_CONFIG_PATH"
    echo "→ ODOO_EXTRA_ADDONS=$ODOO_EXTRA_ADDONS"
    echo "→ ODOO_CONFIG_PATH=$ODOO_CONFIG_PATH"
    echo "→ ODOO_CONFIG_FILE_PATH=$ODOO_CONFIG_FILE_PATH"
    echo "→ EIP_ODOO_OPENMRS_ROUTES_PATH=$EIP_ODOO_OPENMRS_ROUTES_PATH"
    echo "→ EIP_OPENMRS_SENAITE_ROUTES_PATH=$EIP_OPENMRS_SENAITE_ROUTES_PATH"
    echo "→ EIP_ERPNEXT_OPENMRS_ROUTES_PATH=$EIP_ERPNEXT_OPENMRS_ROUTES_PATH"
    echo "→ OPENMRS_FRONTEND_CONFIG_PATH=$OPENMRS_FRONTEND_CONFIG_PATH"
    echo "→ SQL_SCRIPTS_PATH=$SQL_SCRIPTS_PATH"
    echo "→ ERPNEXT_CONFIG_PATH=$ERPNEXT_CONFIG_PATH"
    echo "→ ERPNEXT_SCRIPTS_PATH=$ERPNEXT_SCRIPTS_PATH"
    echo "→ KEYCLOAK_CONFIG_PATH=$KEYCLOAK_CONFIG_PATH"
    echo "→ BAHMNI_OPENMRS_MODULES_PATH=$BAHMNI_OPENMRS_MODULES_PATH"
    echo "→ BAHMNI_CONFIG_OVERRIDE_VOLUME=$CONFIG_OVERRIDE_VOLUME"
}

function setDockerComposeCLIOptions () {
    # Parse 'docker-compose-files.txt' to get the list of Docker Compose files to run
    dockerComposeFiles=$(cat docker-compose-files.txt)

    if [ "$RUN_WITH_BAHMNI_EMR" == "true" ]; then
        export ENABLE_SSO=false
    fi

    for file in ${dockerComposeFiles}
    do
        if [ "$ENABLE_SSO" != "true" ]; then
            if [[ "$file" == *"-sso.yml" || "$file" == "docker-compose-keycloak.yml" ]]; then
                continue
            fi
        fi

        if [[ "$file" == *"-bahmniemr.yml" && "$RUN_WITH_BAHMNI_EMR" == "false" ]]; then
            continue
        fi

        if [[ "$file" == *"-openmrs.yml" && "$RUN_WITH_BAHMNI_EMR" == "true" ]]; then
            continue
        fi
        
        export dockerComposeFilesCLIOptions="$dockerComposeFilesCLIOptions -f ../$file"
    done

    # Add restore file if restore env is set
    if [ "$RESTORE" == "true" ]; then
        export dockerComposeFilesCLIOptions="$dockerComposeFilesCLIOptions -f ../docker-compose-restore.yml"
    fi

    # Set the default env file
    export dockerComposeEnvFilePath="../.env"

    # Override the default with the concatenated.env file if it is provided
    concatenatedEnvFilePath="../concatenated.env"
    if [ -f "$concatenatedEnvFilePath" ]; then
        export dockerComposeEnvFilePath="$concatenatedEnvFilePath"
    fi

    export dockerComposeOzoneCLIOptions="--env-file $dockerComposeEnvFilePath $dockerComposeFilesCLIOptions"

    # Set args for the proxy service
    export dockerComposeProxyCLIOptions="--env-file $dockerComposeEnvFilePath -f ../proxy/docker-compose.yml"

    # Set args for the demo service
    if [ "$ENABLE_SSO" == "true" ]; then
        export dockerComposeDemoCLIOptions="--env-file $dockerComposeEnvFilePath -f ../demo/docker-compose.yml -f ../demo/docker-compose-sso.yml"
    else
        export dockerComposeDemoCLIOptions="--env-file $dockerComposeEnvFilePath -f ../demo/docker-compose.yml"
    fi
}

function exportHostIP() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        export HOST_IP_ADDRESS=$(hostname -I | awk '{print $1}')
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        export HOST_IP_ADDRESS=$(ipconfig getifaddr en0)
    else
        echo "$ERROR Unsupported OS type: $OSTYPE"
        return 1
    fi
    echo "$INFO IP address set to: $HOST_IP_ADDRESS"
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

    export USE_HTTPS="true"
    export O3_HOSTNAME=emr-"${IP_WITH_DASHES}.traefik.me"
    export ODOO_HOSTNAME=erp-"${IP_WITH_DASHES}.traefik.me"
    export SENAITE_HOSTNAME=lims-"${IP_WITH_DASHES}.traefik.me"
    export ERPNEXT_HOSTNAME=erpnext-"${IP_WITH_DASHES}.traefik.me"
    export KEYCLOAK_HOSTNAME=auth-"${IP_WITH_DASHES}.traefik.me"
    export FHIR_ODOO_HOSTNAME=fhir-erp-"${IP_WITH_DASHES}.traefik.me"
    echo "→ O3_HOSTNAME=$O3_HOSTNAME"
    echo "→ ODOO_HOSTNAME=$ODOO_HOSTNAME"
    echo "→ SENAITE_HOSTNAME=$SENAITE_HOSTNAME"
    echo "→ ERPNEXT_HOSTNAME=$ERPNEXT_HOSTNAME"
    echo "→ KEYCLOAK_HOSTNAME=$KEYCLOAK_HOSTNAME"
    echo "→ FHIR_ODOO_HOSTNAME=$FHIR_ODOO_HOSTNAME"

}

function setNginxHostnames {
    echo "$INFO Exporting Nginx hostnames..."

    export O3_HOSTNAME="${HOST_IP_ADDRESS:-localhost}"
    export ODOO_HOSTNAME="${HOST_IP_ADDRESS:-localhost}:8069"
    export SENAITE_HOSTNAME="${HOST_IP_ADDRESS:-localhost}:8081"
    export ERPNEXT_HOSTNAME="${HOST_IP_ADDRESS:-localhost}:8082"
    export FHIR_ODOO_HOSTNAME="${HOST_IP_ADDRESS:-localhost}:8083"
    export KEYCLOAK_HOSTNAME="${HOST_IP_ADDRESS:-localhost}:8084"

    echo "→ O3_HOSTNAME=$O3_HOSTNAME"
    echo "→ ODOO_HOSTNAME=$ODOO_HOSTNAME"
    echo "→ SENAITE_HOSTNAME=$SENAITE_HOSTNAME"
    echo "→ ERPNEXT_HOSTNAME=$ERPNEXT_HOSTNAME"
    echo "→ FHIR_ODOO_HOSTNAME=$FHIR_ODOO_HOSTNAME"
    echo "→ KEYCLOAK_HOSTNAME=$KEYCLOAK_HOSTNAME"

}

function exportScheme() {
    if [ "$USE_HTTPS" == "true" ]; then
        export SERVER_SCHEME="https"
    else
        export SERVER_SCHEME="http"
    fi
    echo "$INFO Scheme set to: $SERVER_SCHEME"
}

function isOzoneRunning {
    local projectName=$1
    runningContainers=$(docker ps --filter "name=${projectName}" --format "{{.Names}}")
    if [ -n "$runningContainers" ]; then
        return 0  # true
    else
        return 1  # false
    fi
}

function displayAccessURLsWithCredentials {
    services=()
    is_defined=()

    # Read docker-compose-files.txt and extract the list of services run
    while read -r line; do
        if [[ $line != *-sso.yml ]]; then
            serviceWithoutExtension=${line%.yml}
            service=${serviceWithoutExtension#docker-compose-}

            services+=("$service")
            is_defined+=(1)
        fi
    done < docker-compose-files.txt

    echo "HIS Component,URL,Username,Password" > .urls_1.txt
    echo "-,-,-,-" >> .urls_1.txt
    tail -n +2 ozone-urls-template.csv | while IFS=',' read -r component url username password service ; do
        for i in "${!services[@]}"; do
            if [[ "${services[$i]}" == "$service" && "${is_defined[$i]}" == 1 ]]; then
                if [[ "$service" == "keycloak" && "$ENABLE_SSO" == "false" ]]; then
                  continue
                fi
                echo "$component,$url,$username,$password" >> .urls_1.txt
                break
            fi
        done
    done

    envsubst < .urls_1.txt > .urls_2.txt

    echo ""
    echo "$INFO 🔗 Access each ${OZONE_LABEL:-Ozone FOSS} components at the following URL:"
    echo ""
    if [ "$ENABLE_SSO" == "true" ]; then
        awk -F, 'NR==1 {printf "%-15s %-40s\n", $1, $2} NR>2 && $1 != "Keycloak" {printf "%-15s %-40s\n", $1, $2} END {print "-\nUsername: jdoe\nPassword: password\n-\nIdentity Provider(IDP)\nKeycloak -", $2, " Username:", $3, " Password:", $4}' .urls_2.txt
    else
        awk -F, 'NR==1 {printf "%-15s %-40s %-15s %-15s\n", $1, $2, $3, $4} NR>2 && $1 != "Keycloak" {printf "%-15s %-40s %-15s %-15s\n", $1, $2, $3, $4}' .urls_2.txt
    fi
}

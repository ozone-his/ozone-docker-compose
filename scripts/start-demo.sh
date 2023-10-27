#!/usr/bin/env bash
set -e

# Export the DISTRO_PATH variable
source setup-dirs.sh

# Export the demo environment variables
source export-demo-env.sh

# Set the demo patients props
export NUMBER_OF_DEMO_PATIENTS=50

INSTALLED_DOCKER_VERSION=$(docker version -f "{{.Server.Version}}")
MINIMUM_REQUIRED_DOCKER_VERSION_REGEX="^((([2-9][1-9]|[3-9][0]|[0-9]{3,}).*)|(20\.([0-9]{3,}|[1-9][1-9]|[2-9][0]).*)|(20\.10\.([0-9]{3,}|[2-9][0-9]|[1][3-9])))"
if [[ $INSTALLED_DOCKER_VERSION =~ $MINIMUM_REQUIRED_DOCKER_VERSION_REGEX ]]; then
    if command -v gp version &> /dev/null; then
        export PROXY_TLS="-DgitPodEnvironment"
    fi
    docker network inspect web >/dev/null 2>&1 ||  docker network create web
    
    dockerComposeCommand() {
        docker compose -p ozone -f ../docker-compose-common.yml -f ../docker-compose-openmrs.yml -f ../docker-compose-senaite.yml -f ../docker-compose-odoo.yml -f ../docker-compose-superset.yml -f ../demo/docker-compose.yml -f ../proxy/docker-compose.yml up -d --build
        }
    echo "[INFO] $(declare -f dockerComposeCommand)"
    dockerComposeCommand

else
    echo "Docker versions < 20.10.13 are not supported"
fi

#
# The following lines will display the Ozone access URLs to the user.
# However, the commands differ when running from the Maven package or directly from source.
# Handling this by using Maven filtering to define if operating in a Maven package or from source.
#
#
echo ""
if [ "${true}" != "" ]; then
    # Run from package
    cat ../ozone-urls.md
else
    # Run from source
    ./get-urls-from-readme.sh ../README.md /tmp/urls.md
    cat /tmp/urls.md && rm /tmp/urls.md
fi
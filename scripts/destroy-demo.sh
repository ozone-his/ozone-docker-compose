#!/usr/bin/env bash

# Export the DISTRO_PATH variable
source setup-dirs.sh

# Export more environment variables
source export-demo-env.sh

INSTALLED_DOCKER_VERSION=$(docker version -f "{{.Server.Version}}")
MINIMUM_REQUIRED_DOCKER_VERSION_REGEX="^((([2-9][1-9]|[3-9][0]|[0-9]{3,}).*)|(20\.([0-9]{3,}|[1-9][1-9]|[2-9][0]).*)|(20\.10\.([0-9]{3,}|[2-9][0-9]|[1][3-9])))"
if [[ $INSTALLED_DOCKER_VERSION =~ $MINIMUM_REQUIRED_DOCKER_VERSION_REGEX ]]; then
    docker compose -p ozone -f ../docker-compose-common.yml -f ../docker-compose-openmrs.yml -f ../docker-compose-senaite.yml -f ../docker-compose-odoo.yml -f ../docker-compose-superset.yml -f ../demo/docker-compose.yml  -f ../proxy/docker-compose.yml down -v
else
    echo "Docker versions < 20.10.13 are not supported"
fi

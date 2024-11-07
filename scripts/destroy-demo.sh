#!/usr/bin/env bash

source utils.sh

# Set CLI options
setDockerComposeCLIOptions

# Export the DISTRO_PATH variable
setupDirs

# Export more environment variables
exportPaths

# Read PROJECT_NAME from the temporary file
PROJECT_NAME=$(cat /tmp/project_name.txt)
# Unset the BACKUP_RESTORE variable if it is set, as the restore Docker Compose files introduces restore specific profiles that will make the  Docker Compose file invalid
unset BACKUP_RESTORE

echo "$INFO Destroying $PROJECT_NAME project..."

INSTALLED_DOCKER_VERSION=$(docker version -f "{{.Server.Version}}")
MINIMUM_REQUIRED_DOCKER_VERSION_REGEX="^((([2-9][1-9]|[3-9][0]|[0-9]{3,}).*)|(20\.([0-9]{3,}|[1-9][1-9]|[2-9][0]).*)|(20\.10\.([0-9]{3,}|[2-9][0-9]|[1][3-9])))"
if [[ $INSTALLED_DOCKER_VERSION =~ $MINIMUM_REQUIRED_DOCKER_VERSION_REGEX ]]; then
    echo "$INFO Destroying demo service..."
    docker compose -p $PROJECT_NAME $dockerComposeDemoCLIOptions down -v
    echo "$INFO Destroying proxy service..."
    docker compose -p $PROJECT_NAME $dockerComposeProxyCLIOptions down -v
    echo "$INFO Destroying Ozone services..."
    docker compose -p $PROJECT_NAME $dockerComposeOzoneCLIOptions down -v  --remove-orphans
else
    echo "$ERROR Docker versions < 20.10.13 are not supported"
fi

#!/usr/bin/env bash
set -e

source utils.sh

# Export the DISTRO_PATH variable
setupDirs

# Export IP address of the host machine
if [ "$ENABLE_SSO" == "true" ]; then
  exportHostIP
fi

# Set the Traefik host names
if [ "$TRAEFIK" == "true" ]; then
    echo "$INFO \$TRAEFIK=true, setting Traefik hostnames..."
    setTraefikIP
    setTraefikHostnames
else
    echo "$INFO \$TRAEFIK!=true, setting Nginx hostnames..."
    setNginxHostnames
fi

setupProjectName

if ! isOzoneRunning "$PROJECT_NAME"; then
    echo "$INFO Starting Ozone project with name: $PROJECT_NAME"
else
  echo "$WARN Ozone project with name: $PROJECT_NAME is already running"
  echo "$INFO Re-applying Docker Compose up command to ensure all services are up-to-date..."
fi

INSTALLED_DOCKER_VERSION=$(docker version -f "{{.Server.Version}}")
MINIMUM_REQUIRED_DOCKER_VERSION_REGEX="^((([2-9][1-9]|[3-9][0]|[0-9]{3,}).*)|(20\.([0-9]{3,}|[1-9][1-9]|[2-9][0]).*)|(20\.10\.([0-9]{3,}|[2-9][0-9]|[1][3-9])))"
if [[ $INSTALLED_DOCKER_VERSION =~ $MINIMUM_REQUIRED_DOCKER_VERSION_REGEX ]]; then
  # Export scheme
  exportScheme
  # Create the networks
  docker network inspect web >/dev/null 2>&1 ||  docker network create web
  # Run the docker compose command
  docker compose -p $PROJECT_NAME --env-file ../.env -f ../docker-compose-bundled.yml -f ../docker-compose-bundled-sso.yml up -d
else
  echo "$ERROR Docker version $INSTALLED_DOCKER_VERSION is not supported. Please install Docker version >= 20.10.0"
  exit 1
fi

# Static list of services
definedServices=("openmrs" "odoo" "senaite" "keycloak")
printf "%s\n" "${definedServices[@]}" > /tmp/defined_services.txt
displayAccessURLsWithCredentials

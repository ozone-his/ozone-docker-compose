#!/usr/bin/env bash
set -e

source utils.sh

# Set CLI options
setDockerComposeCLIOptions

# Export the DISTRO_PATH variable
setupDirs

# Export the paths variables to point to distro artifacts
exportPaths

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

# Set the demo patients props
if [ "$DEMO" == "true" ]; then
    echo "$INFO DEMO=true, setting the number of demo patients..."
    export NUMBER_OF_DEMO_PATIENTS=50
    echo "→ NUMBER_OF_DEMO_PATIENTS=$NUMBER_OF_DEMO_PATIENTS"
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
    INSTALLED_DOCKER_COMPOSE_VERSION=$(docker compose version --short 2>/dev/null)
    MINIMUM_REQUIRED_DOCKER_COMPOSE_VERSION_REGEX="^([2-9]|[1-9][0-9]+)\.*"
    if [[ $INSTALLED_DOCKER_COMPOSE_VERSION =~ $MINIMUM_REQUIRED_DOCKER_COMPOSE_VERSION_REGEX ]]; then
        if command -v gp version &> /dev/null; then
            export GITPOD_ENV="true"
            export USE_HTTPS="true"
        else
            export GITPOD_ENV="false"
        fi

    # Export the scheme
    exportScheme

    # Pull Ozone Docker images
    echo "$INFO Pulling ${OZONE_LABEL:-Ozone FOSS} images..."
    docker compose -p $PROJECT_NAME $dockerComposeOzoneCLIOptions pull
    
    # Set the Docker Compose command for Ozone
    dockerComposeOzoneCommand="docker compose -p $PROJECT_NAME $dockerComposeOzoneCLIOptions up -d --build"
    echo "$INFO Running ${OZONE_LABEL:-Ozone FOSS}..."
    echo ""
    echo "$dockerComposeOzoneCommand"
    echo ""

    # Create the networks
    docker network inspect web >/dev/null 2>&1 ||  docker network create web

    # Run Ozone
    ($dockerComposeOzoneCommand)

    # Run the Nginx Proxy service, if $TRAEFIK!=true
    if [ "$TRAEFIK" != "true" ]; then
        dockerComposeProxyCommand="docker compose -p $PROJECT_NAME $dockerComposeProxyCLIOptions up -d --build"
        echo "$INFO Running Nginx proxy service (\$TRAEFIK!=true)..."
        echo ""
        echo "$dockerComposeProxyCommand"
        echo ""
        ($dockerComposeProxyCommand)
    else
        echo "$INFO Skipping running Nginx proxy... (\$TRAEFIK=true)"
    fi

    # Run the Demo service
    if [ "$DEMO" == "true" ]; then
        # Pull the demo image
        echo "$INFO Pulling ${OZONE_LABEL:-Ozone FOSS} demo data image..."
        docker compose -p $PROJECT_NAME $dockerComposeDemoCLIOptions pull
        # Set the Docker Compose command for the demo
        dockerComposeDemoCommand="docker compose -p $PROJECT_NAME $dockerComposeDemoCLIOptions up -d"
        echo "$INFO Running demo service..."
        echo ""
        echo "$dockerComposeDemoCommand"
        echo ""
        ($dockerComposeDemoCommand)
    fi

    else
        echo "$ERROR Docker compose versions < 2.x are not supported"
    fi
else
    echo "$ERROR Docker versions < 20.10.13 are not supported"
fi

extractServicesFromComposeFiles
displayAccessURLsWithCredentials

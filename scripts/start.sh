#!/usr/bin/env bash
set -e

source utils.sh

# Set CLI options
setDockerComposeCLIOptions

# Export the DISTRO_PATH variable
setupDirs

# Export the paths variables to point to distro artifacts
exportPaths

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

# Check if ozone-info.json exists and read project name from it
ozoneInfo="../$DISTRO_PATH/ozone-info.json"
if [ -f "$ozoneInfo" ]; then
    export PROJECT_NAME=$(grep -o '"name":\s*"[^\"]*"' "$ozoneInfo" | cut -d'"' -f4)
else
    export PROJECT_NAME="ozone"
fi
echo "$PROJECT_NAME" > /tmp/project_name.txt

if ! isOzoneRunning "$PROJECT_NAME"; then
    echo "$INFO Starting Ozone project with name: $PROJECT_NAME"
fi

# Check if an instance of Ozone is already running
suffix=0
while isOzoneRunning "$PROJECT_NAME"; do
    echo "$WARN An instance of Ozone is already running with the name: $PROJECT_NAME"
    suffix=$((suffix + 1))
    export PROJECT_NAME="$PROJECT_NAME-$suffix"
    echo "$INFO Starting a new instance of Ozone with name: $PROJECT_NAME"
    echo "$PROJECT_NAME" > /tmp/project_name.txt
done

INSTALLED_DOCKER_VERSION=$(docker version -f "{{.Server.Version}}")
MINIMUM_REQUIRED_DOCKER_VERSION_REGEX="^((([2-9][1-9]|[3-9][0]|[0-9]{3,}).*)|(20\.([0-9]{3,}|[1-9][1-9]|[2-9][0]).*)|(20\.10\.([0-9]{3,}|[2-9][0-9]|[1][3-9])))"
if [[ $INSTALLED_DOCKER_VERSION =~ $MINIMUM_REQUIRED_DOCKER_VERSION_REGEX ]]; then
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
        dockerComposeDemoCommand="docker compose -p $PROJECT_NAME $dockerComposeDemoCLIOptions up -d"
        echo "$INFO Running demo service..."
        echo ""
        echo "$dockerComposeDemoCommand"
        echo ""
        ($dockerComposeDemoCommand)
    fi

else
    echo "$ERROR Docker versions < 20.10.13 are not supported"
fi

displayAccessURLsWithCredentials

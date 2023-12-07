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
    echo "[INFO] \$TRAEFIK=true, setting Traefik hostnames..."
    setTraefikHostnames
fi

# Set the demo patients props
export NUMBER_OF_DEMO_PATIENTS=50

INSTALLED_DOCKER_VERSION=$(docker version -f "{{.Server.Version}}")
MINIMUM_REQUIRED_DOCKER_VERSION_REGEX="^((([2-9][1-9]|[3-9][0]|[0-9]{3,}).*)|(20\.([0-9]{3,}|[1-9][1-9]|[2-9][0]).*)|(20\.10\.([0-9]{3,}|[2-9][0-9]|[1][3-9])))"
if [[ $INSTALLED_DOCKER_VERSION =~ $MINIMUM_REQUIRED_DOCKER_VERSION_REGEX ]]; then
    if command -v gp version &> /dev/null; then
        export PROXY_TLS="-DgitPodEnvironment"
    fi

    # Pull Ozone Docker images
    echo "[INFO] Pulling Ozone images..."
    docker compose -p ozone $dockerComposeOzoneCLIOptions pull
    
    # Set the Docker Compose command for Ozone
    dockerComposeOzoneCommand="docker compose -p ozone $dockerComposeOzoneCLIOptions up -d --build"
    echo "[INFO] Running Ozone..."
    echo ""
    echo "$dockerComposeOzoneCommand"
    echo ""

    # Create the networks
    docker network inspect web >/dev/null 2>&1 ||  docker network create web

    # Run Ozone
    ($dockerComposeOzoneCommand)

    # Run the Apache2 Proxy service, if $TRAEFIK!=true
    if [ "$TRAEFIK" != "true" ]; then
        dockerComposeProxyCommand="docker compose -p ozone $dockerComposeProxyCLIOptions up -d --build"
        echo "[INFO] Running Apache2 proxy service (\$TRAEFIK!=true)..."
        echo ""
        echo "$dockerComposeProxyCommand"
        echo ""
        ($dockerComposeProxyCommand)
    else
        echo "[INFO] Skipping running Apache 2 proxy... (\$TRAEFIK=true)"
    fi

    # Run the Demo service
    dockerComposeDemoCommand="docker compose -p ozone $dockerComposeDemoCLIOptions up -d"
    echo "[INFO] Running demo service..."
    echo ""
    echo "$dockerComposeDemoCommand"
    echo ""
    ($dockerComposeDemoCommand)

else
    echo "Docker versions < 20.10.13 are not supported"
fi

#
# The following lines will display the Ozone access URLs in the terminal.
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
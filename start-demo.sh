#!/usr/bin/env bash
set -e

# Read command line parameter
if [ -z "$1" ]
then
      echo "Missing parameter. Please provide the Ozone Distro version as a parameter"
      echo "Eg: $0 1.0.0-SNAPSHOT"
      exit 1
fi

export OZONE_DIR=$PWD/ozone
mkdir -p $OZONE_DIR

# Download Ozone distro
export OZONE_DISTRO_VERSION=$1
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:get -DremoteRepositories=https://nexus.mekomsolutions.net/repository/maven-public -Dartifact=com.ozonehis:ozone-distro:$OZONE_DISTRO_VERSION:zip -Dtransitive=false --legacy-local-repository && \
./mvnw clean org.apache.maven.plugins:maven-dependency-plugin:3.2.0:unpack -Dproject.basedir=$OZONE_DIR -Dartifact=com.ozonehis:ozone-distro:$OZONE_DISTRO_VERSION:zip -DoutputDirectory=$OZONE_DIR/ozone-distro-$OZONE_DISTRO_VERSION

# Source the required environment variables
source start-demo.env

INSTALLED_DOCKER_VERSION=$(docker version -f "{{.Server.Version}}")
MINIMUM_REQUIRED_DOCKER_VERSION_REGEX="^((([2-9][1-9]|[3-9][0]|[0-9]{3,}).*)|(20\.([0-9]{3,}|[1-9][1-9]|[2-9][0]).*)|(20\.10\.([0-9]{3,}|[2-9][0-9]|[1][3-9])))"
if [[ $INSTALLED_DOCKER_VERSION =~ $MINIMUM_REQUIRED_DOCKER_VERSION_REGEX ]]; then
    echo "Docker version >= 20.10.13, using Docker Compose V2"
    if command -v gp version &> /dev/null; then
        export PROXY_TLS="-DgitPodEnvironment"
    fi
   docker network inspect web >/dev/null 2>&1 ||  docker network create web
   docker compose -f docker-compose-common.yml -f docker-compose-openmrs.yml -f docker-compose-senaite.yml -f docker-compose-odoo.yml -f docker-compose-superset.yml -f demo/docker-compose.yml  -f proxy/docker-compose.yml up -d --build
else
    echo "Docker versions < 20.10.13 are not supported"
fi

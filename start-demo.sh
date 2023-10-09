#!/usr/bin/env bash
export OZONE_DIR=$PWD/ozone && \
mkdir -p $OZONE_DIR

remoteRepoUrl=https://nexus.mekomsolutions.net/repository/maven-public

# Parse artifact details from project pom.xml
echo "Parsing details from project pom.xml..."
version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
artifactId=$(mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout)
groupId=$(mvn help:evaluate -Dexpression=project.groupId -q -DforceStdout)
artifact=${groupId}:${artifactId}:${version}:zip


# Downloads the project
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:get -DremoteRepositories=${remoteRepoUrl} -Dartifact=${artifact} -Dtransitive=false --legacy-local-repository
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:unpack -Dproject.basedir=$OZONE_DIR -Dartifact=${artifact} -DoutputDirectory=$OZONE_DIR/ozone-distro-${version}
# Exports required environment variables
export DISTRO_PATH=$OZONE_DIR/ozone-distro-${version}
export OPENMRS_CONFIG_PATH=$DISTRO_PATH/openmrs_config
export OZONE_CONFIG_PATH=$DISTRO_PATH/ozone_config
export OPENMRS_CORE_PATH=$DISTRO_PATH/openmrs_core
export OPENMRS_MODULES_PATH=$DISTRO_PATH/openmrs_modules
export EIP_PATH=$DISTRO_PATH/eip_config
export SPA_PATH=$DISTRO_PATH/spa
export SENAITE_CONFIG_PATH=$DISTRO_PATH/senaite_config
export ODOO_EXTRA_ADDONS=$DISTRO_PATH/odoo_config/addons
export ODOO_CONFIG_PATH=$DISTRO_PATH/odoo_config/odoo_csv
export ODOO_INITIALIZER_CONFIG_FILE_PATH=$DISTRO_PATH/odoo_config/config/initializer_config.json
export ODOO_CONFIG_FILE_PATH=$DISTRO_PATH/odoo_config/config/odoo.conf
export O3_FRONTEND_TAG=
export O3_BACKEND_TAG=

mkdir -p $EIP_PATH/routes/demo
mkdir -p $EIP_PATH/config/demo

cp ./demo/eip/routes/generate-demo-data-route.xml $EIP_PATH/routes/demo/
cp ./demo/eip/config/application.properties $EIP_PATH/config/demo/

export NUMBER_OF_DEMO_PATIENTS=50

INSTALLED_DOCKER_VERSION=$(docker version -f "{{.Server.Version}}")
MINIMUM_REQUIRED_DOCKER_VERSION_REGEX="^((([2-9][1-9]|[3-9][0]|[0-9]{3,}).*)|(20\.([0-9]{3,}|[1-9][1-9]|[2-9][0]).*)|(20\.10\.([0-9]{3,}|[2-9][0-9]|[1][3-9])))"
if [[ $INSTALLED_DOCKER_VERSION =~ $MINIMUM_REQUIRED_DOCKER_VERSION_REGEX ]]; then
    echo "Docker version >= 20.10.13, using Docker Compose V2"
    if command -v gp version &> /dev/null; then
        export PROXY_TLS="-DgitPodEnvironment"
    fi
   docker network create web
   docker compose -f docker-compose.yml -f docker-compose-proxy.yml -f docker-compose-senaite.yml -f docker-compose-odoo.yml -f docker-compose-demo.yml up -d --build
else
    echo "Docker versions < 20.10.13 are not supported"
fi

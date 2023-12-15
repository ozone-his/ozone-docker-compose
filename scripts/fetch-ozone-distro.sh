#!/usr/bin/env bash
set -e

# Read command line parameter
if [ -z "$1" ]
then
      echo "Missing parameter. Please provide the Ozone Distro version as a parameter"
      echo "Eg: $0 1.0.0-alpha.6"
      exit 1
fi

source utils.sh

# Create the OZONE_DIR and export DISTRO_PATH
setupDirs

# Download Ozone distro
export OZONE_DISTRO_VERSION=$1
echo "$INFO Fetching Ozone distro $OZONE_DISTRO_VERSION..."
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:get -DremoteRepositories=https://nexus.mekomsolutions.net/repository/maven-public -Dartifact=com.ozonehis:ozone-distro:$OZONE_DISTRO_VERSION:zip -Dtransitive=false

# Remove the Maven Dependency plugin markers
rm -rf $OZONE_DIR/target/dependency-maven-plugin-markers/
# Unpack the Ozone distro
./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.2.0:unpack -Dproject.basedir=$OZONE_DIR -Dartifact=com.ozonehis:ozone-distro:$OZONE_DISTRO_VERSION:zip -DoutputDirectory=$DISTRO_PATH

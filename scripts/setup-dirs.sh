#!/usr/bin/env bash
set -e

# Create the Ozone directory
export OZONE_DIR=$PWD/ozone
mkdir -p $OZONE_DIR

# Export the DISTRO_PATH value
export DISTRO_PATH=$OZONE_DIR/ozone-distro

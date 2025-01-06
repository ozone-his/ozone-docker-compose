#!/usr/bin/env bash
set -e

source utils.sh

# Enable SSO
export ENABLE_SSO=true
echo "$INFO Setting ENABLE_SSO=true..."
echo "→ ENABLE_SSO=$ENABLE_SSO"

source start-bundled.sh

#!/usr/bin/env bash
set -e

# Enable SSO
export ENABLE_SSO=true
echo "$INFO Setting ENABLE_SSO=true..."
echo "→ ENABLE_SSO=$ENABLE_SSO"

source start.sh

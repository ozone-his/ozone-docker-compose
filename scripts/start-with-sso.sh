# Enable sso
export ENABLE_SSO=true
export OAUTH_ENABLED=true
echo "$INFO Setting ENABLE_SSO=true..."
echo "→ ENABLE_SSO=$ENABLE_SSO"
echo "$INFO Setting OAUTH_ENABLED=true..."
echo "→ OAUTH_ENABLED=$OAUTH_ENABLED"

source start.sh

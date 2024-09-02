#!/bin/sh
set -e
# if [ -f "/usr/share/nginx/html/ozone/ozone-frontend-config.json" ]; then
#   envsubst < "/usr/share/nginx/html/ozone/ozone-frontend-config.json" | sponge "/usr/share/nginx/html/ozone/ozone-frontend-config.json"
# fi
for f in /usr/share/nginx/html/ozone/*.json; do
  echo "processing===> $f";
  envsubst < $f | sponge $f;
done
/usr/local/bin/startup.sh

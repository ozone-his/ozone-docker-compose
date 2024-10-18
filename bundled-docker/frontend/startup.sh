#!/bin/sh
set -e

for f in /usr/share/nginx/html/configs/*.json; do
  echo "processing===> $f";
  envsubst < $f | sponge $f;
done
/usr/local/bin/startup.sh

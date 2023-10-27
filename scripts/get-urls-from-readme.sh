#!/usr/bin/env bash
set -e

# Read command line parameter
if [ -z "$1" ]
then
      echo "Missing parameter(s). Please provide the path to the README file and the path where to save the URL table"
      echo "Eg: $0 ../README.md target/urls.md"
      exit 1
fi

cat << EOF > $2
$(sed "/^## 2. Browse Ozone$/,/^Ozone FOSS/!d;//d;/^$/d" $1)
EOF

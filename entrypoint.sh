#!/bin/bash
set -e

cd /home/container || exit 1;

MODIFIED_STARTUP="$STARTUP"

# Lista de variables conocidas a reemplazar
for clean_var in $(echo "$MODIFIED_STARTUP" | grep -oE ':[A-Z0-9_]+'); do
  value=$(echo "\$${clean_var:1}" | envsubst)

  MODIFIED_STARTUP=${MODIFIED_STARTUP//"$clean_var"/$value}
done

eval $MODIFIED_STARTUP
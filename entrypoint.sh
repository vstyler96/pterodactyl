#!/bin/bash
set -e

cd /home/container || exit 1

MODIFIED_STARTUP="$STARTUP"

# Lista de variables conocidas a reemplazar
for clean_var in $(echo "$STARTUP" | grep -oE ':[A-Z0-9_]+'); do
  value="${!clean_var}"
  MODIFIED_STARTUP="${MODIFIED_STARTUP//:$clean_var/$value}"
done

exec $MODIFIED_STARTUP
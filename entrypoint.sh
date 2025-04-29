#!/bin/bash
cd /home/container || exit 1

# Si necesitas reemplazar variables como {{PORT}}, aquí puedes hacerlo
# Por ahora solo ejecuta lo que venga en el startup command
exec "$@"
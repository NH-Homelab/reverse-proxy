#!/bin/sh

# Source environment variables from mounted secret file
if [ -f /etc/nginx/env/.env ]; then
    echo "Loading environment variables from /etc/nginx/env/.env"
    set -a  # automatically export all variables
    . /etc/nginx/env/.env
    set +a  # stop automatically exporting
else
    echo "Warning: /etc/nginx/env/.env not found, using existing environment variables"
fi

# Validate critical environment variables
if [ -z "$AUTH_SERVICE_HOST" ]; then
    echo "ERROR: AUTH_SERVICE_HOST environment variable is not set or empty"
    exit 1
fi

if [ -z "$AUTH_SERVICE_PORT" ]; then
    echo "ERROR: AUTH_SERVICE_PORT environment variable is not set or empty"
    exit 1
fi

echo "AUTH_SERVICE_HOST: $AUTH_SERVICE_HOST"
echo "AUTH_SERVICE_PORT: $AUTH_SERVICE_PORT"

# Process each service template with envsubst
envsubst "\$MINIO_HOST \$MINIO_PORT" < /etc/nginx/templates/minio.conf.template > /etc/nginx/conf.d/minio.conf
envsubst "\$PGADMIN_HOST \$PGADMIN_PORT" < /etc/nginx/templates/pgadmin.conf.template > /etc/nginx/conf.d/pgadmin.conf
envsubst "\$PLEX_HOST \$PLEX_PORT" < /etc/nginx/templates/plex.conf.template > /etc/nginx/conf.d/plex.conf
envsubst "\$PIHOLE_HOST \$PIHOLE_PORT" < /etc/nginx/templates/pihole.conf.template > /etc/nginx/conf.d/pihole.conf
envsubst "\$PROXMOX_HOST \$PROXMOX_PORT" < /etc/nginx/templates/proxmox.conf.template > /etc/nginx/conf.d/proxmox.conf
envsubst "\$AUTH_SERVICE_HOST \$AUTH_SERVICE_PORT" < /etc/nginx/templates/auth-request.conf.template > /etc/nginx/conf.d/auth-request.conf

echo "Generated auth-request.conf:"
cat /etc/nginx/conf.d/auth-request.conf
echo "\$AUTH_SERVICE_HOST and \$AUTH_SERVICE_PORT have been substituted in auth-request.conf."

echo "Processed service templates with envsubst."

# Start nginx
exec nginx -g "daemon off;"

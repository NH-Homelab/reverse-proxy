#!/bin/sh

# Source environment variables from mounted secret file
if [ -f deploy/overlays/prod/.env ]; then
    echo "Loading environment variables from deploy/overlays/prod/.env"
    set -a  # automatically export all variables
    . deploy/overlays/prod/.env
    set +a  # stop automatically exporting
else
    echo "Warning: deploy/overlays/prod/.env not found, using existing environment variables"
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

echo "Substituting environment variables in service templates for nginx configuration."

# Process each service template with envsubst
envsubst "\$MINIO_HOST \$MINIO_PORT" < /etc/nginx/templates/minio.conf.template > /etc/nginx/conf.d/minio.conf
envsubst "\$PGADMIN_HOST \$PGADMIN_PORT" < /etc/nginx/templates/pgadmin.conf.template > /etc/nginx/conf.d/pgadmin.conf
envsubst "\$PLEX_HOST \$PLEX_PORT" < /etc/nginx/templates/plex.conf.template > /etc/nginx/conf.d/plex.conf
envsubst "\$PIHOLE_HOST \$PIHOLE_PORT" < /etc/nginx/templates/pihole.conf.template > /etc/nginx/conf.d/pihole.conf
envsubst "\$PROXMOX_HOST \$PROXMOX_PORT" < /etc/nginx/templates/proxmox.conf.template > /etc/nginx/conf.d/proxmox.conf
envsubst "\$AUTH_SERVICE_HOST \$AUTH_SERVICE_PORT" < /etc/nginx/templates/auth-request.conf.template > /etc/nginx/conf.d/auth-request.conf

echo "Starting nginx"

# Start nginx with debug mode if NGINX_DEBUG is set to true
if [ "$NGINX_DEBUG" = "true" ]; then
    echo "Debug mode enabled - starting nginx-debug"
    exec nginx-debug -g "daemon off;"
else
    echo "Starting nginx in normal mode"
    exec nginx -g "daemon off;"
fi

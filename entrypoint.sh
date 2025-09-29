#!/bin/sh

# Debug: Show environment variables for troubleshooting
echo "=== Environment Variables Debug ==="
echo "AUTH_SERVICE_HOST: '${AUTH_SERVICE_HOST}'"
echo "AUTH_SERVICE_PORT: '${AUTH_SERVICE_PORT}'"
echo "DOMAIN: '${DOMAIN}'"
echo "All SERVICE/HOST/PORT variables:"
env | grep -E "(SERVICE|HOST|PORT|DOMAIN)" | sort || echo "No matching variables found"

# Validate critical environment variables
if [ -z "$AUTH_SERVICE_HOST" ]; then
    echo "ERROR: AUTH_SERVICE_HOST environment variable is not set or empty"
    echo "All available environment variables:"
    env | sort
    exit 1
fi

if [ -z "$AUTH_SERVICE_PORT" ]; then
    echo "ERROR: AUTH_SERVICE_PORT environment variable is not set or empty"
    exit 1
fi

echo "Substituting environment variables in service templates for nginx configuration."

# Process main template with envsubst
envsubst "\$DOMAIN" < /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf

# Process each service template with envsubst
envsubst "\$MINIO_HOST \$MINIO_PORT \$MINIO_S3_PORT \$DOMAIN" < /etc/nginx/templates/minio.conf.template > /etc/nginx/conf.d/minio.conf
envsubst "\$PGADMIN_HOST \$PGADMIN_PORT \$DOMAIN" < /etc/nginx/templates/pgadmin.conf.template > /etc/nginx/conf.d/pgadmin.conf
envsubst "\$PLEX_HOST \$PLEX_PORT \$DOMAIN" < /etc/nginx/templates/plex.conf.template > /etc/nginx/conf.d/plex.conf
envsubst "\$PIHOLE_HOST \$PIHOLE_PORT \$DOMAIN" < /etc/nginx/templates/pihole.conf.template > /etc/nginx/conf.d/pihole.conf
envsubst "\$PROXMOX_HOST \$PROXMOX_PORT \$DOMAIN" < /etc/nginx/templates/proxmox.conf.template > /etc/nginx/conf.d/proxmox.conf
envsubst "\$AUTH_SERVICE_HOST \$AUTH_SERVICE_PORT \$DOMAIN" < /etc/nginx/templates/auth-request.conf.template > /etc/nginx/conf.d/auth-request.conf

echo "Starting nginx"

# Start nginx with debug mode if NGINX_DEBUG is set to true
if [ "$NGINX_DEBUG" = "true" ]; then
    echo "Debug mode enabled - starting nginx-debug"
    exec nginx-debug -g "daemon off;"
else
    echo "Starting nginx in normal mode"
    exec nginx -g "daemon off;"
fi

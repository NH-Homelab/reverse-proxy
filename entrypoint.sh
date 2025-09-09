#!/bin/sh

# Process each service template with envsubst
envsubst "\$MINIO_HOST \$MINIO_PORT" < /etc/nginx/templates/minio.conf.template > /etc/nginx/conf.d/minio.conf
envsubst "\$PGADMIN_HOST \$PGADMIN_PORT" < /etc/nginx/templates/pgadmin.conf.template > /etc/nginx/conf.d/pgadmin.conf
envsubst "\$PLEX_HOST \$PLEX_PORT" < /etc/nginx/templates/plex.conf.template > /etc/nginx/conf.d/plex.conf
envsubst "\$PIHOLE_HOST \$PIHOLE_PORT" < /etc/nginx/templates/pihole.conf.template > /etc/nginx/conf.d/pihole.conf
envsubst "\$PROXMOX_HOST \$PROXMOX_PORT" < /etc/nginx/templates/proxmox.conf.template > /etc/nginx/conf.d/proxmox.conf
envsubst "\$AUTH_SERVICE_HOST \$AUTH_SERVICE_PORT" < /etc/nginx/templates/auth-request.conf.template > /etc/nginx/conf.d/auth-request.conf


echo "Processed service templates with envsubst."

# Start nginx
exec nginx -g "daemon off;"

FROM nginx:alpine

# Copy main nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy service template configs
COPY services/minio.conf.template /etc/nginx/templates/minio.conf.template
COPY services/pgadmin.conf.template /etc/nginx/templates/pgadmin.conf.template
COPY services/pihole.conf.template /etc/nginx/templates/pihole.conf.template
COPY services/plex.conf.template /etc/nginx/templates/plex.conf.template
COPY services/proxmox.conf.template /etc/nginx/templates/proxmox.conf.template
COPY services/auth-request.conf.template /etc/nginx/templates/auth-request.conf.template

# Copy snippets
COPY snippets/ssl-common.conf /etc/nginx/snippets/ssl-common.conf
COPY snippets/auth-request.conf /etc/nginx/snippets/auth-request.conf
COPY snippets/auth-common.conf /etc/nginx/snippets/auth-common.conf

# Copy HTML file
COPY test.html /usr/share/nginx/html/index.html

# Copy and make entrypoint script executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
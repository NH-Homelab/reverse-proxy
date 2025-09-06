FROM nginx:alpine

# Copy main nginx config
COPY ../../nginx.conf /etc/nginx/nginx.conf

# Copy service configs
COPY ../../services/minio.conf /etc/nginx/conf.d/minio.conf
COPY ../../services/pgadmin.conf /etc/nginx/conf.d/pgadmin.conf
COPY ../../services/pihole.conf /etc/nginx/conf.d/pihole.conf
COPY ../../services/plex.conf /etc/nginx/conf.d/plex.conf
COPY ../../services/proxmox.conf /etc/nginx/conf.d/proxmox.conf

# Copy HTML file
COPY ../../test.html /usr/share/nginx/html/index.html

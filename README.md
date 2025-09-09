# Auth Service
The auth service is a backend for the nginx reverse proxy that authenticates users, issues cookies, and verifies the user's permissions to access a resource.

## Environment Variables
The following environment variables must be set when deploying the proxy. Create a .env file in either the dev or prod overlay with the following values, adjusted as needed.

```
# Minio
MINIO_HOST=host.minikube.internal
MINIO_PORT=9000
# PGAdmin
PGADMIN_HOST=host.minikube.internal
PGADMIN_PORT=15433
# Plex
PLEX_HOST=plex.local
PLEX_PORT=32400
# Pihole
PIHOLE_HOST=pihole.local
PIHOLE_PORT=8080
# Proxmox
PROXMOX_HOST=proxmox.local
PROXMOX_PORT=8006
# Auth Service
AUTH_SERVICE_HOST=auth-service.default.svc.cluster.local
AUTH_SERVICE_PORT=8080
```
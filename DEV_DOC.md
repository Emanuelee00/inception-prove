*This activity has been created as part of the 42 curriculum by eielmini*

# Developer Documentation

## Prerequisites
- Linux environment with Docker installed
- Docker Compose support
- Access to the repository root (`/home/eielmini/inception`)
- A valid `srcs/.env` file containing environment variables
- Secrets files present in the `secrets/` directory

## Required files
- `srcs/docker-compose.yml`
- `srcs/.env`
- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/db_user.txt`
- Dockerfiles under `srcs/requirements/`

## Build and launch
From the repository root:
```sh
make up
```
This target creates the host volume directories and starts the stack.

If you want to explicitly build before starting:
```sh
make build
make up
```

## Manage containers
- Start: `make up`
- Stop: `make down`
- Restart: `make restart`
- View logs: `make logs`
- Clean containers only: `make clean`
- Full cleanup: `make fclean`

## Stack architecture
- `nginx`: reverse proxy on port `443`, only TLSv1.2 / TLSv1.3
- `wordpress`: PHP-FPM site container, no built-in web server
- `mariadb`: database container, initialized by a startup script
- `inception` network: service-to-service communication only

## Persistent storage
The stack uses two named volumes backed by host directories:
- `db_data` -> `/home/eielmini/data/mariadb`
- `wp_data` -> `/home/eielmini/data/wordpress`

The host directories are created by the `init` Makefile target.

## Notes about the current implementation
- MariaDB is initialized in `srcs/requirements/mariadb/tools/init.sh`
- WordPress setup is handled in `srcs/requirements/wordpress/tools/setup.sh`
- NGINX configuration is in `srcs/requirements/nginx/conf/default.conf`

## Common troubleshooting
- If MariaDB starts slowly, check `docker compose -f srcs/docker-compose.yml logs mariadb`
- If WordPress cannot connect, verify that the `mariadb` container is healthy and reachable on the `inception` network
- Ensure the secrets files are readable by Docker and contain the expected values

## Service verification
Use:
```sh
docker compose -f srcs/docker-compose.yml ps
```
and
```sh
docker compose -f srcs/docker-compose.yml logs
```

For container-specific logs:
```sh
docker compose -f srcs/docker-compose.yml logs mariadb
```

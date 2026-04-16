*This activity has been created as part of the 42 curriculum by eielmini*

# User Documentation

## Overview
This project provides a secure local WordPress stack with:
- `nginx` as reverse proxy and TLS entrypoint
- `wordpress` running PHP-FPM
- `mariadb` as database server
- persistent volumes for WordPress files and MariaDB data
- a dedicated Docker network named `inception`

## Services provided
- **NGINX**: listens on port `443` only and forwards PHP requests to the WordPress container
- **WordPress**: handles the website and serves the administration panel via PHP-FPM
- **MariaDB**: stores WordPress database content in a persistent database volume

## Start the stack
From the repository root, run:
```sh
make up
```
This command creates the persistent host directories and starts the containers in detached mode.

## Stop the stack
```sh
make down
```
This stops the containers while preserving volumes and local data.

## Full cleanup
```sh
make fclean
```
This removes containers, anonymous volumes, images, and the host data directories used for WordPress and MariaDB.

## Access the website
Open your browser at:

```text
https://eielmini.42.fr
```

If the DNS entry is configured correctly, NGINX is the only public entry point on port `443`.

## Access administration panel
Visit:

```text
https://eielmini.42.fr/wp-admin
```

WordPress administrator credentials are created during the first installation. If not already set, follow the on-screen setup wizard.

## Credentials and secrets
Credentials are stored locally in the `secrets/` folder and are not part of the Git repository history:
- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/db_user.txt`

The database credentials are injected into the containers using Docker secrets.

## Verify service health
Use Docker Compose or container status commands:
```sh
docker compose -f srcs/docker-compose.yml ps
```
or
```sh
docker ps
```

You can also follow real-time logs:
```sh
make logs
```

## Data persistence
Persistent data is stored on the host under:
- `/home/eielmini/data/wordpress`
- `/home/eielmini/data/mariadb`

These directories are mounted into the containers using Docker volumes, so the website files and database survive container restarts.

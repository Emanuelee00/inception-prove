# Developer Documentation

## Prerequisites

- A Debian/Alpine VM with `sudo` access.
- Docker Engine + the Compose plugin (`docker compose`, not the old
  standalone `docker-compose`). `./setup.sh` installs Docker, `make` and
  `curl` if they're missing, and creates the data directories under
  `$HOME/data`.
- Your domain added to `/etc/hosts`, pointing to the VM's IP (or
  `127.0.0.1` for local testing):

  ```
  127.0.0.1 eielmini.42.fr
  ```

## Setting up the environment from scratch

1. `./setup.sh` — installs Docker/Compose/make if needed, creates
   `$HOME/data/wordpress` and `$HOME/data/mariadb`.
2. Create `srcs/.env` (git-ignored, never commit it) with:

   ```env
   DOMAIN_NAME=eielmini.42.fr

   WP_DATABASE=wordpress
   WP_DB_HOST=mariadb
   WP_USER=<db user for wordpress, not "root">
   WP_PASSWORD=<db user password>

   WP_ADMIN=<wp admin login, must NOT contain admin/administrator>
   WP_ADMIN_EMAIL=<admin email>
   WP_ADMIN_PASSWORD=<wp admin password>

   WP_USER_PASSWORD=<password of the second wp user, "toto">
   ```

   All credentials are only ever read from this file via `env_file:` in
   `docker-compose.yml` — nothing is hardcoded in any Dockerfile.

3. `make` — builds the images and starts the stack.

## Building and launching

The Makefile is the single entrypoint:

```bash
make          # == make up
make init     # create $HOME/data/{wordpress,mariadb} (also run by `up`)
make up       # docker compose up --build -d
make down     # docker compose down
make logs     # docker compose logs -f
make clean    # down + docker system prune -af
make fclean   # down -v (drops volumes!) + wipe $HOME/data/* + prune
make re       # fclean + all
```

Use `make re` whenever a change requires a clean slate (e.g. after changing
`WP_ADMIN`, since WordPress only creates the admin user on first install —
changing the `.env` value alone does nothing to an already-provisioned
database).

## Managing containers and volumes

```bash
docker compose -f srcs/docker-compose.yml ps            # container status
docker compose -f srcs/docker-compose.yml logs -f <svc>  # logs for one service
docker compose -f srcs/docker-compose.yml exec wordpress bash
docker volume ls                                          # list volumes
```

Service names: `nginx`, `wordpress`, `mariadb` (and `react` for the bonus).

## Scaffolding the React app (bonus, one-time, already done)

The React source under `srcs/requirements/react/` was bootstrapped with
`create-vite`, a *scaffolder* — a tool that generates the initial file
structure of a project (`package.json`, `index.html`, `src/main.tsx`,
`src/App.tsx`, ESLint/TypeScript config) so you don't start from an empty
folder. It was run once, from the host, using a throwaway `node:20`
container (not part of the project's own images — just a local dev tool):

```bash
docker run --rm -it \
  -v "$(pwd)/srcs/requirements/react":/app \
  -w /app \
  node:20 \
  npm create vite@latest .
```

Choices made: framework **React**, variant **TypeScript**, linter
**ESLint**. The generated files were committed to the repository, so anyone
cloning it does **not** need to re-run this — `make` alone builds them via
the service's own Dockerfile (`npm install && npm run build`, from
`debian:bookworm`), the same way WordPress's Dockerfile installs `wp-cli`
without anyone re-running that step by hand.

## Where data is stored / how it persists

Two named volumes, both bind-mounted to the host (required by the subject):

| Volume    | Container path      | Host path                  |
|-----------|----------------------|-----------------------------|
| `db_data` | `/var/lib/mysql`     | `$HOME/data/mariadb`        |
| `wp_data` | `/var/www/html`      | `$HOME/data/wordpress`      |

Because they're bind mounts, data survives `docker compose down` and even
`make clean` (image/container removal) — only `make fclean`/`make re` wipe
them on purpose, by removing the volumes and the underlying host
directories.

The React/Pacman bonus container has no persistent state: it's built as
static assets (Vite build output) served by nginx and rebuilt from source on
every `--build`.

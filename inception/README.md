*This activity has been created as part of the 42 curriculum by eielmini.*

# Inception

## Description

Inception is a system administration project. The goal is to set up a small
web infrastructure entirely with Docker: each service (reverse proxy,
WordPress, database) runs in its own container, built from a Dockerfile
written from scratch, orchestrated with Docker Compose.

The mandatory stack serves a WordPress site over HTTPS:

- **nginx** — TLSv1.2/1.3 reverse proxy, the only entrypoint (port 443)
- **WordPress + php-fpm** — no nginx inside, talks to nginx over FastCGI
- **MariaDB** — no nginx inside, stores the WordPress database

A bonus **React** frontend is served at the domain root, alongside a small
Pacman game (Python/pygame, compiled to WebAssembly) embedded in it.

## Instructions

1. Clone the repository and `cd` into it.
2. Run `./setup.sh` once to install Docker, Docker Compose and `make` if
   missing, and to create the data directories.
3. Create `srcs/.env` with the required variables (see [DEV_DOC.md](DEV_DOC.md)).
4. Add your domain to `/etc/hosts`, e.g. `127.0.0.1 eielmini.42.fr`.
5. Run `make` at the root of the repository.
6. Visit `https://eielmini.42.fr` in your browser (accept the self-signed
   certificate warning).

See [USER_DOC.md](USER_DOC.md) for day-to-day usage and [DEV_DOC.md](DEV_DOC.md)
for environment setup and development commands.

## Project description

### Design choices

Every image is built `FROM debian:bookworm` and installs only the packages
it needs via `apt-get` — no pre-built application images (e.g. official
`nginx`/`wordpress`/`mysql` images) are used, per the subject's rules.
Each service is a single process per container (nginx, php-fpm, mysqld),
started directly as PID 1 (no `tail -f`/`sleep infinity` hacks), so Docker's
restart policy (`restart: always`) can actually detect and recover crashes.

Configuration and secrets are injected exclusively through environment
variables read from `srcs/.env` (git-ignored), never hardcoded in a
Dockerfile or committed to the repository.

### Virtual Machines vs Docker

A VM virtualizes an entire machine, including its own kernel, which makes it
heavier to boot and to run many isolated instances of. A Docker container
shares the host kernel and only isolates the process/filesystem/network
namespace, so it starts in a fraction of a second and uses far less memory —
which is exactly why this project can run three to four independent
"machines" (nginx, WordPress, MariaDB, React) on a single small VM.

### Secrets vs Environment Variables

Environment variables (`.env` file) are simple and are what this project
uses, but they end up in `docker inspect`, in the process environment of
every container, and potentially in logs. Docker secrets are mounted as
files under `/run/secrets/` inside the container, only for the services that
declare them, and never appear in `docker inspect` — better isolation for
genuinely sensitive values (passwords, keys) at the cost of a bit more
plumbing (reading a file instead of a variable in every script).

### Docker Network vs Host Network

`network: host` makes a container share the host's network stack directly
— no isolation, and every exposed port collides with the host's own
services. A dedicated Docker network (`inception`, used here) gives each
container its own network namespace and lets them reach each other by
service name (e.g. `wordpress:9000`) through Docker's internal DNS, without
exposing anything beyond what's explicitly published (only nginx's 443).

### Docker Volumes vs Bind Mounts

A bind mount maps a host path directly into the container (what this
project uses, `$HOME/data/...`, as required by the subject); a named volume
is managed entirely by Docker under `/var/lib/docker/volumes/`. Bind mounts
make it trivial to inspect/back up data from the host at a known path;
named volumes are more portable (no hardcoded host path) and are the
recommended default when you don't need direct host access to the files.

## Resources

- [Docker Compose file reference](https://docs.docker.com/compose/compose-file/)
- [Docker documentation — Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
- [WP-CLI documentation](https://wp-cli.org/)
- [nginx documentation](https://nginx.org/en/docs/)
- [Vite documentation](https://vite.dev/)
- [pygbag — run pygame in the browser](https://pygame-web.github.io/)

### AI usage

Claude Code was used throughout this project as a troubleshooting and
learning assistant, not as a code generator for the graded mandatory part:

- Diagnosing and fixing environment issues on the VM: a hardcoded
  `/home/<other-login>` path in the Makefile/`docker-compose.yml`, a full
  `/var` partition blocking image builds (relocating Docker's and
  containerd's storage to `/home`), and missing `docker-compose`
  (Compose v2 syntax).
- Reviewing the subject against the actual configuration and catching a
  real compliance issue: the WordPress admin username was `admin`, which
  the subject explicitly forbids.
- Guiding, step by step, the creation of the bonus React frontend and the
  Pacman/pygbag integration — the author wrote the React/game code
  himself; AI was used to explain concepts (Vite, scaffolding, TypeScript
  vs JavaScript, linters) and review the result, not to author it.

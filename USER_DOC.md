# User Documentation

## What services does the stack provide?

- **Website** — a WordPress site, reachable at `https://eielmini.42.fr`
  (kept at the domain root, as required by the subject).
- **Admin panel** — WordPress dashboard, to manage posts/pages/users.
- **React bonus page** — served at `https://eielmini.42.fr/app/`, not the
  domain root, so it doesn't shadow the mandatory WordPress site.
- **Pacman game** — a Python/pygame game running in its own container and
  streamed into the React page via VNC (bonus, embedded in `/app/`).

Everything is served over HTTPS (TLSv1.2/1.3) through a single nginx
container; there is no other entrypoint.

## Starting and stopping

From the root of the repository:

```bash
make up      # build (if needed) and start all containers, in the background
make down    # stop all containers
make logs    # follow the logs of all containers
```

`make` (with no target) is equivalent to `make up`.

## Accessing the website and the admin panel

- Website: `https://eielmini.42.fr/`
- WordPress admin panel: `https://eielmini.42.fr/wp-admin/`
- Bonus page (React + Pacman): `https://eielmini.42.fr/app/`

The browser will warn about the certificate because it is self-signed
(generated locally by the nginx container) — this is expected, accept it to
continue.

Make sure `eielmini.42.fr` resolves to the VM's IP (or `127.0.0.1` if you're
browsing from the VM itself). This is a line in `/etc/hosts`:

```
127.0.0.1 eielmini.42.fr
```

## Credentials

All credentials live in `srcs/.env` (not committed to git). Relevant
variables:

| Variable             | Purpose                                   |
|----------------------|--------------------------------------------|
| `WP_ADMIN` / `WP_ADMIN_PASSWORD` | WordPress administrator login |
| `WP_ADMIN_EMAIL`     | Administrator's email                      |
| `WP_USER_PASSWORD`   | Password of the second WordPress user (`toto`, editor role) |
| `WP_USER` / `WP_PASSWORD` | Database user used internally by WordPress |

There is no default/example password — if `srcs/.env` is missing, see
[DEV_DOC.md](DEV_DOC.md) to recreate it.

## Checking that everything is running correctly

```bash
docker compose -f srcs/docker-compose.yml ps
```

All five services (`mariadb`, `wordpress`, `nginx`, `react`, `pacman`) should
show as `Up`. You can
also check:

```bash
make logs
```

and look for errors, or simply confirm the site loads at
`https://eielmini.42.fr/` and that `https://eielmini.42.fr/wp-admin/`
prompts a WordPress login screen.

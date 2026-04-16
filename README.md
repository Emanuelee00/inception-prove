*This activity has been created as part of the 42 curriculum by eielmini*

# Inception

## Description
This project builds a local Docker-based WordPress stack with a secure NGINX reverse proxy, PHP-FPM, and MariaDB.
The goal is to implement a self-contained infrastructure on a virtual machine using Docker Compose and custom Dockerfiles.

## Instructions
1. Place required files inside the `srcs` folder.
2. Create the `.env` file and the `secrets/` files as required.
3. Run the stack from the repository root:
   ```sh
   make up
   ```
4. Stop the stack with:
   ```sh
   make down
   ```
5. For full cleanup:
   ```sh
   make fclean
   ```

## Resources
- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- WordPress installation guide: https://wordpress.org/support/article/how-to-install-wordpress/
- MariaDB documentation: https://mariadb.com/kb/en/
- AI use: used to review project structure, fix Docker startup issues, create missing documentation files, and improve Makefile reliability.

## Project Description
This activity uses Docker to simulate a production-like web infrastructure with isolated services.
The stack includes:
- `mariadb`: database service
- `wordpress`: PHP-FPM application service
- `nginx`: TLS reverse proxy service

### Main design choices
- Custom Dockerfiles are used for each service.
- Persistent storage is configured via Docker volumes backed by host directories.
- Docker secrets are used for sensitive credentials.
- NGINX is the only public entrypoint, serving HTTPS on port `443`.

### Virtual Machines vs Docker
- Virtual Machines provide full OS isolation and are heavier in resources.
- Docker containers are lighter, share the host kernel, and start faster.
- This project uses Docker for efficient service isolation without full VM overhead.

### Secrets vs Environment Variables
- Environment variables are used for configuration values such as database name and user.
- Secrets are used for sensitive values like database passwords.
- This improves security by preventing secrets from being stored directly in version-controlled files.

### Docker Network vs Host Network
- A custom bridge network (`inception`) is used for container-to-container communication.
- This avoids using host networking and keeps services isolated.
- Only NGINX is exposed externally on port `443`.

### Docker Volumes vs Bind Mounts
- Volumes are used for persistent data storage and can be managed by Docker.
- Bind mounts are used here to map host directories for WordPress files and MariaDB data.
- This preserves data across container restarts and allows host-side inspection when needed.

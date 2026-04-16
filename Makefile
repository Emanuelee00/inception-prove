# Paths for persistent volumes

WP_DIR      = /home/eielmini/data/wordpress
DB_DIR      = /home/eielmini/data/mariadb

# Docker Compose command

COMPOSE     = docker-compose -f srcs/docker-compose.yml

# Default target

all: up

# Create volume directories if they don't exist

init:
	mkdir -p $(WP_DIR) $(DB_DIR)

# Build images (only when needed)

build:
	$(COMPOSE) build

# Start containers (no rebuild for speed)

up: init
	$(COMPOSE) up -d

# Stop containers

down:
	$(COMPOSE) down

# Show logs in real time

logs:
	$(COMPOSE) logs -f

# Restart containers

restart: down up

# Stop containers (keep images and volumes)

clean:
	$(COMPOSE) down

# Full cleanup (removes everything: volumes, images, cache)

fclean:
	$(COMPOSE) down -v
	sudo rm -rf $(WP_DIR)/* $(DB_DIR)/*
	docker system prune -af

# Full rebuild from scratch

re: fclean build up

# Declare phony targets

.PHONY: all init build up down logs restart clean fclean re

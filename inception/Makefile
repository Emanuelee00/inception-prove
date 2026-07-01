WP_DIR		= $(HOME)/data/wordpress
DB_DIR		= $(HOME)/data/mariadb
COMPOSE		= docker compose -f srcs/docker-compose.yml

all: up

init:
	mkdir -p $(WP_DIR) $(DB_DIR)

up: init
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

clean:
	$(COMPOSE) down
	docker system prune -af

fclean:
	$(COMPOSE) down -v
	sudo rm -rf $(WP_DIR)/* $(DB_DIR)/*
	docker system prune -af

re: fclean all

.PHONY: all init up down logs clean fclean re

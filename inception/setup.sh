#!/bin/bash

echo "=== Inception Setup ==="

# Install curl if missing
if ! command -v curl &> /dev/null; then
	echo "Installing curl..."
	sudo apt install curl -y
fi

# Install Docker if missing
if ! command -v docker &> /dev/null; then
	echo "Installing Docker..."
	curl -fsSL https://get.docker.com | sh
	sudo usermod -aG docker $USER
	echo "Docker installed — run 'newgrp docker' or restart your session"
fi

# Install make if missing
if ! command -v make &> /dev/null; then
	echo "Installing make..."
	sudo apt install make -y
fi

# Create data directories
echo "Creating data directories..."
mkdir -p /home/$USER/data/wordpress
mkdir -p /home/$USER/data/mariadb

echo "=== Setup complete — run: make ==="

#!/bin/bash
set -e

export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export MYSQL_USER=${MYSQL_USER}
export MYSQL_DATABASE=${MYSQL_DATABASE}
# export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

echo "=== Starting WordPress setup ==="
echo "Waiting for MariaDB..."

mkdir -p /var/www/html
chmod -R 755 /var/www/html
chown -R www-data:www-data /var/www/html

while ! mysqladmin ping -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} --silent 2>/dev/null; do
    echo "Still waiting for MariaDB..."
    sleep 3
done

echo "MariaDB is ready!"


cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Installing WordPress..."
    
    find /var/www/html -mindepth 1 -delete
    
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    mv wordpress/* .
    rm -rf wordpress latest.tar.gz
    
    cp wp-config-sample.php wp-config.php
    
    sed -i "s/database_name_here/${MYSQL_DATABASE}/g" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/g" wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/g" wp-config.php
    sed -i "s/localhost/mariadb/g" wp-config.php
    echo "WordPress installation complete!"
else
    echo "WordPress already installed"


fi

mkdir -p /run/php

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F

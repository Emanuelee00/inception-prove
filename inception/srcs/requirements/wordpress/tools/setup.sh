#!/bin/bash
set -e

# Wait for MariaDB to accept connections
while ! (echo > /dev/tcp/mariadb/3306) 2>/dev/null; do
    echo "Still waiting for MariaDB..."
    sleep 3
done
echo "MariaDB is ready!"

mkdir -p /var/www/html
cd /var/www/html

if [ ! -f wp-load.php ]; then
    wp --allow-root core download
fi

if [ ! -f wp-config.php ]; then
    wp --allow-root config create --dbname=$WP_DATABASE \
        --dbuser=$WP_USER \
        --dbpass=$WP_PASSWORD \
        --dbhost=$WP_DB_HOST
fi

if ! wp --allow-root core is-installed 2>/dev/null; then
    wp --allow-root core install --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL

    wp --allow-root user create toto toto@code.42.tech.fr --role=editor --user_pass=$WP_USER_PASSWORD
fi

cp /cosmos-landing.html /var/www/html/cosmos-landing.html
chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F

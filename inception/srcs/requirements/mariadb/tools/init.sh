#!/bin/bash
set -e

# # Read passwords from Docker secrets
# DB_ROOT_PWD=$(cat /run/secrets/db_root_password)
# DB_PWD=$(cat /run/secrets/db_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

echo "=== Starting MariaDB ==="

# Ensure correct ownership for MySQL data directory
chown -R mysql:mysql /var/lib/mysql

# Initialize system tables if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database system tables..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Create app database and user if not already done
if [ ! -d "/var/lib/mysql/$WP_DATABASE" ]; then
    echo "Creating application database and user..."
    # Start temporary MariaDB instance in background
    mysqld --user=mysql --skip-networking &
    TEMP_PID=$!

    # Wait for MariaDB to be ready (local socket)
    until mysqladmin ping --silent; do
        sleep 1
    done

    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $WP_DATABASE;
CREATE USER IF NOT EXISTS '$WP_USER'@'%' IDENTIFIED BY '$WP_PASSWORD';
GRANT ALL PRIVILEGES ON $WP_DATABASE.* TO '$WP_USER'@'%';
FLUSH PRIVILEGES;
EOF

    kill $TEMP_PID
    wait $TEMP_PID 2>/dev/null
fi

# Start MariaDB in foreground as PID 1
echo "Starting MariaDB in foreground..."
exec mysqld --user=mysql --console

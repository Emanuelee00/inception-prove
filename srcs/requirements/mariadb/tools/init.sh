#!/bin/bash
set -e

# Read passwords from Docker secrets
DB_ROOT_PWD=$(cat /run/secrets/db_root_password)
DB_PWD=$(cat /run/secrets/db_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

echo "=== Starting MariaDB ==="

# Ensure correct ownership for MySQL data directory
chown -R mysql:mysql /var/lib/mysql

# Check if database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    # Create the system database files
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start temporary MariaDB instance to create users
    mysqld --user=mysql --skip-networking --daemonize --socket = /run/mysqld/mysqld.sock
    
    # Wait for MariaDB to be ready
    sleep 5
    while ! mysqladmin ping --silent 2>/dev/null; do
        sleep 1
    done
    
    # Create database and users
    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PWD}';
ALTER USER '$MYSQL_USER'@'%' IDENTIFIED BY '$DB_PWD';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    
    # Stop temporary MariaDB
    mysqladmin -u root -p${DB_ROOT_PWD} shutdown
    sleep 3
fi

# Start MariaDB in foreground as PID 1
echo "Starting MariaDB in foreground..."
exec mysqld --user=mysql --console

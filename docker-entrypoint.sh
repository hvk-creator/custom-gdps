#!/bin/bash
set -e

# Fix MPM conflicts by keeping only mpm_prefork
rm -f /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf
ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

# Fallback to 8080 if PORT is somehow empty
TARGET_PORT=${PORT:-8080}

# Update ports.conf to listen on 0.0.0.0:TARGET_PORT
echo "Listen 0.0.0.0:${TARGET_PORT}" > /etc/apache2/ports.conf

# Update VirtualHost in 000-default.conf to match TARGET_PORT
sed -i "s/<VirtualHost \*:.*>/<VirtualHost \*:${TARGET_PORT}>/g" /etc/apache2/sites-available/000-default.conf

# Suppress ServerName warnings in logs
if ! grep -q "ServerName localhost" /etc/apache2/apache2.conf; then
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
fi

exec "$@"

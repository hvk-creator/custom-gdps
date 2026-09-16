#!/bin/bash
set -e

# Purge conflicting MPM modules
rm -f /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf
ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

TARGET_PORT=${PORT:-8080}

# Bind Apache to dynamic PORT
echo "Listen 0.0.0.0:${TARGET_PORT}" > /etc/apache2/ports.conf

# Configure VirtualHost for DocumentRoot /var/www/html
cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:${TARGET_PORT}>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

if ! grep -q "ServerName localhost" /etc/apache2/apache2.conf; then
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
fi

exec "$@"

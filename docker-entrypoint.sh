#!/bin/bash
set -e

# Fix MPM module conflicts
rm -f /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf
ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

TARGET_PORT=${PORT:-8080}

# Update Listen port
echo "Listen 0.0.0.0:${TARGET_PORT}" > /etc/apache2/ports.conf

# Recreate health check file
mkdir -p /var/www/html
echo "OK" > /var/www/html/test.html
chmod 644 /var/www/html/test.html
chown www-data:www-data /var/www/html/test.html

# Configure VirtualHost with direct error output to stdout/stderr
cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:${TARGET_PORT}>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /dev/stderr
    CustomLog /dev/stdout combined
</VirtualHost>
EOF

if ! grep -q "ServerName localhost" /etc/apache2/apache2.conf; then
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
fi

exec "$@"

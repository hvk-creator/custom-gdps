#!/bin/bash
set -e

# Fix MPM module symlinks
rm -f /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf
ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

# Bind explicitly to 0.0.0.0 on port 80
echo "Listen 0.0.0.0:80" > /etc/apache2/ports.conf
echo "ServerName localhost" >> /etc/apache2/apache2.conf

exec "$@"

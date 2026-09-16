FROM php:8.1.31-apache

LABEL name="GMDprivateServer" \
      description="A Geometry Dash Server Emulator"

# Install system dependencies & PHP database drivers
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates && \
    docker-php-ext-install pdo pdo_mysql mysqli && \
    a2enmod rewrite && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Clean directory and clone core directly into DocumentRoot
ARG BRANCH=master
RUN rm -rf /var/www/html/* && \
    git clone --branch ${BRANCH} https://github.com/MegaSa1nt/GMDprivateServer.git /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

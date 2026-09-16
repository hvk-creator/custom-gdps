FROM php:8.1.31-apache

# Dockerfile's Metadata
LABEL name="GMDprivateServer" \
      description="A Geometry Dash Server Emulator"

# Install necessary dependencies & PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates && \
    docker-php-ext-install pdo pdo_mysql mysqli && \
    a2enmod rewrite && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure Apache to listen on Railway's dynamic $PORT variable
RUN sed -i 's/80/${PORT}/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Set working directory
WORKDIR /var/www/html

# Clone the repository
ARG BRANCH=master
RUN git clone --branch ${BRANCH} https://github.com/MegaSa1nt/GMDprivateServer.git . && \
    chown -R www-data:www-data /var/www/html

# Add entrypoint script to resolve runtime MPM conflicts
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

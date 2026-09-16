FROM php:8.1.31-apache

# Dockerfile's Metadata
LABEL name="GMDprivateServer" \
      description="A Geometry Dash Server Emulator"

# Install necessary dependencies & PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates && \
    docker-php-ext-install pdo pdo_mysql mysqli && \
    a2enmod rewrite && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Fix Apache MPM conflict: Force disable event/worker and enable mpm_prefork
RUN a2dismod mpm_event mpm_worker 2>/dev/null || true && \
    a2enmod mpm_prefork

# Configure Apache to listen on Railway's dynamic $PORT variable instead of hardcoded 80
RUN sed -i 's/80/${PORT}/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Set the working directory
WORKDIR /var/www/html

# Clone the repository
ARG BRANCH=master
RUN git clone --branch ${BRANCH} https://github.com/MegaSa1nt/GMDprivateServer.git . && \
    chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]

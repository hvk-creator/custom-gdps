FROM php:8.1.31-apache

LABEL name="GMDprivateServer" \
      description="A Geometry Dash Server Emulator"

# Install system dependencies, C libraries, and required PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql mysqli gd zip mbstring \
    && a2enmod rewrite expires \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Clone GDPS core
ARG BRANCH=master
RUN rm -rf /var/www/html/* && \
    git clone --branch ${BRANCH} https://github.com/MegaSa1nt/GMDprivateServer.git /var/www/html && \
    chown -R www-data:www-data /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

# vim: et
FROM php:fpm-alpine

# Set working directory
WORKDIR /app

# Copy all files to container
COPY ./src /app

# Copy custom.ini
COPY ./docker/custom.ini /usr/local/etc/php/conf.d/custom.ini

RUN set -ex && \
    apk update && \
    composer install && \
    chown -R www-data:www-data /app/storage /app/bootstrap/cache

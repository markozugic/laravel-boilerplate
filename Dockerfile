FROM php:7.4-fpm-alpine3.13

RUN apk update

RUN apk add --no-cache \
    shadow \
    zip \
    libzip-dev \
    freetype \
    libjpeg-turbo \
    libpng \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && docker-php-ext-install exif \
    && apk del --no-cache \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    && rm -rf /tmp/*

# Add `www-data` to group `appuser`
RUN addgroup --gid 1000 appuser; \
  adduser --uid 1000 --gid 1000 --disabled-password appuser; \
  adduser www-data appuser;

# Set www-data to have UID 1000
RUN usermod -u 1000 www-data;

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

COPY ./src .

RUN chown -R www-data:www-data /var/www/html

RUN chown -R www-data:www-data storage bootstrap/cache

USER www-data


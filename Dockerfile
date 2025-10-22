FROM php:8.4-fpm-alpine

RUN apk add --no-cache git curl libpng-dev libjpeg-turbo-dev libwebp-dev freetype-dev oniguruma-dev autoconf g++ make bash

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install pdo pdo_mysql gd

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock* ./
RUN composer install --no-interaction --prefer-dist || true

COPY . .

CMD ["php-fpm"]
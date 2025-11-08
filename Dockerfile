FROM php:8.4-fpm

RUN apt-get update && apt-get install -y \
    git curl bash libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql sockets \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock* ./
RUN composer install --no-interaction --prefer-dist || true

COPY . .

CMD ["php-fpm"]
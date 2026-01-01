FROM php:8.3-fpm-alpine

WORKDIR /var/www/html

# System deps
RUN apk add --no-cache \
    bash \
    curl \
    git \
    icu-dev \
    libzip-dev \
    oniguruma-dev \
    openssh-client \
    mysql-client \
    unzip \
    zip \
  && docker-php-ext-install \
    intl \
    mbstring \
    pdo_mysql \
    zip \
  && rm -rf /tmp/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# PHP config
COPY docker/php/local.ini /usr/local/etc/php/conf.d/local.ini

# App deps (install after copy to enable caching)
COPY composer.json composer.lock ./
RUN composer install --no-interaction --prefer-dist

# App sources
COPY . .

RUN php artisan key:generate --force || true

EXPOSE 9000

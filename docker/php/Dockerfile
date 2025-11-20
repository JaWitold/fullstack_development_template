ARG PHP_VERSION=8.4-fpm-alpine
FROM php:${PHP_VERSION} AS build

RUN apk add --no-cache bash curl zip unzip
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS build-base linux-headers

# Install Redis
RUN pecl install redis && docker-php-ext-enable redis

# Install PDO/PostgreSQL
RUN apk add --no-cache postgresql-libs postgresql-dev && docker-php-ext-install pdo_pgsql

# Install & Configure OPcache
RUN docker-php-ext-install opcache
COPY docker/php/config/opcache.ini "${PHP_INI_DIR}/conf.d"

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install & Configure Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY docker/php/config/xdebug.ini "${PHP_INI_DIR}/conf.d"

RUN apk del .build-deps

WORKDIR /var/www/symfony

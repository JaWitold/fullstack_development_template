FROM php:8.3.6-fpm AS build

RUN apt-get update && apt-get install -y git curl zip unzip libpq-dev

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install pdo
RUN docker-php-ext-install pdo pdo_pgsql && docker-php-ext-enable pdo pdo_pgsql

# enable OPcache
RUN docker-php-ext-install opcache && docker-php-ext-enable opcache
COPY docker/php/config/opcache.ini "${PHP_INI_DIR}/conf.d"

# install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY docker/php/config/xdebug.ini "${PHP_INI_DIR}/conf.d"

#FROM composer:latest AS composer

WORKDIR /var/www/symfony
#
#COPY ./symfony/ ./
#RUN composer install --no-interaction --prefer-dist

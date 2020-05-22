FROM php:7.2-fpm
MAINTAINER bonza "bonzaphp@gmail.com"

ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
        && docker-php-ext-install zip \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache 

RUN pecl install redis && docker-php-ext-enable redis \
	&& echo "extension=redis.so" >> /usr/local/etc/php/php.ini \
    && usermod -u 1000 www-data

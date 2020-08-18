FROM php:7.2-fpm
MAINTAINER bonza "bonzaphp@gmail.com"

ENV TZ=Asia/Shanghai

USER root

RUN  mv /etc/apt/sources.list /etc/apt/sources.list.bak

COPY $PWD/php.ini /usr/local/etc/php/
COPY $PWD/sources.list /etc/apt/

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install opcache \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get clean

RUN pecl channel-update pecl.php.net \
    && php -i |grep php.ini \
    && pecl install -o -f redis && rm -rf /tmp/pear && docker-php-ext-enable redis \
	&& echo "extension=redis.so" >> /usr/local/etc/php/php.ini \
    && pecl install -o -f swoole && rm -rf /tmp/pear && docker-php-ext-enable swoole \
	&& echo "extension=swoole.so" >> /usr/local/etc/php/php.ini \
    && usermod -u 1000 www-data

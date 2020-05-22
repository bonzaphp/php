# docker版php

- - -

1. 使用方式，通过docker安装
```
docker pull bonzaphp/php:fpm-7.2
```
2. 通过docker-compose使用，一般可以结合Redis，MySQL，NGINX使用

```yaml
version: '3'
services:
  php:
    container_name: php_server
    restart: always
    #privileged: true
    image: bonzaphp/php:fpm-7.2
    ports:
      - "${CRM_PHP_PORT}:9000"
    links:
      - "redis:redis_server"
      - "mysql:mysql_server"
    depends_on:
      - "redis" #服务名称
      - "mysql" #mysql服务
    environment:
      TZ: '${TZ}'
    volumes:
      - backed-www:/var/www/html
      - php-conf:/usr/local/etc/php
    networks:
      - docker-php-net
networks:
docker-php-net:
  driver: bridge
volumes:
    php-conf:
      driver: local
      driver_opts:
        type: bind
        o: bind
        device: ${PWD}/../docker-data/conf/php
#其中的变量，可以通过env文件定义
```

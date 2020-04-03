FROM php:7.3.16-fpm-alpine3.11

RUN apk add bash mysql-client
RUN docker-php-ext-install pdo pdo_mysql
RUN apk add --upgrade coreutils

WORKDIR /var/www
COPY . /var/www
RUN rm -rf /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

COPY composer.json composer.json

# RUN composer install --no-scripts --no-autoloader
# COPY .env.example .env
    # php artisan key:generate && \
    # php artisan config:cache
RUN composer install && \
    cp .env.example .env && \
    php artisan key:generate && \
    php artisan config:cache

RUN ln -s public html

EXPOSE 9000
ENTRYPOINT ["php-fpm"]

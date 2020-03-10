#!/usr/bin/env sh
source /etc/profile
if [ ! -d "/www/blog" ] 
then
    if [ ! -d "/www" ]
        then
        mkdir /www
    fi
composer create-project --prefer-dist laravel/laravel /www/blog 
laravel new /www/blog
fi
php-fpm7 -F
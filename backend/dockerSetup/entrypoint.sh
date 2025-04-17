#!/bin/bash

cd /var/www/lms

mkdir -p storage/logs bootstrap/cache database
chmod -R 775 storage bootstrap/cache database
chown -R www-data:www-data storage bootstrap/cache database

touch storage/logs/laravel.log
chown www-data:www-data storage/logs/laravel.log
chmod 664 storage/logs/laravel.log

if [ ! -f database/database.sqlite ]; then
touch database/database.sqlite
chown www-data:www-data database/database.sqlite
chmod 664 database/database.sqlite
fi

if [ ! -d "vendor" ]; then
composer install --no-interaction --prefer-dist
fi

if [ ! -f .env ]; then
cp .env.example .env
php artisan key:generate
fi

php artisan key:generate
php artisan migrate --force
php artisan config:clear
php artisan cache:clear
php artisan route:clear

exec php-fpm

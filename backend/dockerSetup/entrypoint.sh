#!/bin/bash

cd /var/www/lms

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

if [ -f database/database.sqlite ]; then
    chown www-data:www-data database/database.sqlite
    chmod 664 database/database.sqlite

fi
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

mkdir -p database
touch database/database.sqlite
chown -R www-data:www-data database
chmod -R 775 database
chmod 664 database/database.sqlite

composer install --no-interaction --prefer-dist
cp .env.example .env
php artisan key:generate
php artisan migrate --force
php artisan config:clear
php artisan cache:clear
php artisan route:clear

exec php-fpm

#!/bin/bash

# Set correct permissions for Laravel directories
cd /var/www/lms

# Ensure storage, bootstrap/cache, and database are writable
chmod -R 775 storage bootstrap/cache
chmod -R 775 database

chown -R www-data:www-data storage bootstrap/cache database

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

php artisan migrate --force
php artisan config:clear
php artisan cache:clear
php artisan route:clear

exec php-fpm

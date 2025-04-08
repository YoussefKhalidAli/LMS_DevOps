FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
git \
curl \
zip \
unzip \
npm \
sqlite3 \
libsqlite3-dev \
libzip-dev \
libpng-dev \
libonig-dev \
libxml2-dev \
&& docker-php-ext-install pdo pdo_sqlite xml mbstring zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

RUN git clone https://github.com/abdelrahim3AA/Learning-Management-Systems-LMS_GP.git lms

WORKDIR /var/www/lms

RUN npm install && npm run build
RUN composer install
RUN cp .env.example .env
RUN php artisan key:generate
RUN php artisan migrate || true

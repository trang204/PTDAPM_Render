FROM php:8.3-apache

# Cài extension cần cho Laravel
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Cài Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy mã Laravel vào container
COPY . /var/www/html

# Bật mod_rewrite cho Apache (quan trọng với Laravel routing)
RUN a2enmod rewrite

# Quyền cho storage và cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

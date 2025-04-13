FROM php:8.2-apache

# Cài các extension Laravel cần
RUN apt-get update && apt-get install -y \
    libpng-dev libonig-dev libxml2-dev zip unzip git curl \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Cài Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# Set thư mục làm việc
WORKDIR /var/www/html

# Copy source code
COPY . .

# Cài thư viện Laravel
RUN composer install --no-dev --optimize-autoloader

# Set quyền thư mục storage, bootstrap
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port nếu cần
EXPOSE 8000

# CMD chạy web server (có thể là nginx + php-fpm hoặc chỉ php artisan serve nếu đơn giản)
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]

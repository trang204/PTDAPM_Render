# Sử dụng PHP 8.2 (hoặc PHP 8.4 nếu bạn tự build)
FROM php:8.2-apache

# Cài đặt các extension Laravel cần
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git curl \
    && docker-php-ext-install pdo pdo_mysql zip

# Enable mod_rewrite (bắt buộc cho Laravel routes)
RUN a2enmod rewrite

# Đặt DocumentRoot thành thư mục /var/www/html/public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Copy toàn bộ Laravel app vào container
COPY . /var/www/html

# Set quyền nếu cần (đảm bảo storage & bootstrap/cache ghi được)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Làm Laravel hoạt động tốt trong container
WORKDIR /var/www/html

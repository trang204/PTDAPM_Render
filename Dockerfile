FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev unzip zip curl git \
    && docker-php-ext-install pdo pdo_mysql zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy entire Laravel project into /var/www/html
COPY . /var/www/html

# Change Apache DocumentRoot to Laravel's public folder
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/TluNews/public|g' /etc/apache2/sites-available/000-default.conf

# Set permissions (optional but recommended)
RUN chown -R www-data:www-data /var/www/html

# Expose port (usually 80 for Apache)
EXPOSE 80

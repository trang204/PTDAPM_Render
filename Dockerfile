FROM php:8.2-apache

# Cài các extension Laravel cần
RUN apt-get update && apt-get install -y \
    libpng-dev libonig-dev libxml2-dev zip unzip git curl \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Cài Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# Set thư mục làm việc
WORKDIR /var/www/html

# Copy source code vào container
COPY . .

# Tạo file .env trong Docker container với nội dung phù hợp
RUN echo "APP_NAME=Laravel" >> .env && \
    echo "APP_ENV=local" >> .env && \
    echo "APP_KEY=base64:i3GvqPgwvCnwjU0/C+YwhYcqI5+TyemjekYWQyFQ1mE=" >> .env && \
    echo "APP_DEBUG=true" >> .env && \
    echo "APP_TIMEZONE=UTC" >> .env && \
    echo "APP_URL=http://localhost" >> .env && \
    echo "APP_LOCALE=vi" >> .env && \
    echo "APP_FALLBACK_LOCALE=en" >> .env && \
    echo "APP_FAKER_LOCALE=en_US" >> .env && \
    echo "APP_MAINTENANCE_DRIVER=file" >> .env && \
    echo "PHP_CLI_SERVER_WORKERS=4" >> .env && \
    echo "BCRYPT_ROUNDS=12" >> .env && \
    echo "LOG_CHANNEL=stack" >> .env && \
    echo "LOG_STACK=single" >> .env && \
    echo "LOG_DEPRECATIONS_CHANNEL=null" >> .env && \
    echo "LOG_LEVEL=debug" >> .env && \
    echo "DB_CONNECTION=mysql" >> .env && \
    echo "DB_HOST=127.0.0.1" >> .env && \
    echo "DB_PORT=3306" >> .env && \
    echo "DB_DATABASE=ptdapm" >> .env && \
    echo "DB_USERNAME=root" >> .env && \
    echo "DB_PASSWORD=" >> .env && \
    echo "SESSION_DRIVER=database" >> .env && \
    echo "SESSION_LIFETIME=120" >> .env && \
    echo "SESSION_ENCRYPT=false" >> .env && \
    echo "SESSION_PATH=/" >> .env && \
    echo "SESSION_DOMAIN=null" >> .env && \
    echo "BROADCAST_CONNECTION=log" >> .env && \
    echo "FILESYSTEM_DISK=local" >> .env && \
    echo "QUEUE_CONNECTION=database" >> .env && \
    echo "CACHE_STORE=database" >> .env && \
    echo "CACHE_PREFIX=" >> .env && \
    echo "MEMCACHED_HOST=127.0.0.1" >> .env && \
    echo "REDIS_CLIENT=phpredis" >> .env && \
    echo "REDIS_HOST=127.0.0.1" >> .env && \
    echo "REDIS_PASSWORD=null" >> .env && \
    echo "REDIS_PORT=6379" >> .env && \
    echo "MAIL_MAILER=smtp" >> .env && \
    echo "MAIL_HOST=smtp.gmail.com" >> .env && \
    echo "MAIL_PORT=587" >> .env && \
    echo "MAIL_USERNAME=thanghavan2004@gmail.com" >> .env && \
    echo "MAIL_PASSWORD=poggfjeajujvzqwr" >> .env && \
    echo "MAIL_ENCRYPTION=tls" >> .env && \
    echo "MAIL_FROM_ADDRESS=thanghavan2004@gmail.com" >> .env && \
    echo "MAIL_FROM_NAME=\"${APP_NAME}\"" >> .env && \
    echo "AWS_ACCESS_KEY_ID=" >> .env && \
    echo "AWS_SECRET_ACCESS_KEY=" >> .env && \
    echo "AWS_DEFAULT_REGION=us-east-1" >> .env && \
    echo "AWS_BUCKET=" >> .env && \
    echo "AWS_USE_PATH_STYLE_ENDPOINT=false" >> .env && \
    echo "VITE_APP_NAME=\"${APP_NAME}\"" >> .env

# Cài thư viện Laravel
RUN composer install --no-dev --optimize-autoloader

# Tạo khóa ứng dụng Laravel
RUN php artisan key:generate

# Set quyền thư mục storage, bootstrap
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port nếu cần
EXPOSE 8000

# CMD chạy web server (có thể là nginx + php-fpm hoặc chỉ php artisan serve nếu đơn giản)
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]

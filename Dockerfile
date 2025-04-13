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
RUN echo "APP_NAME=Laravel" >> .env
RUN echo "APP_ENV=local" >> .env
RUN echo "APP_KEY=" >> .env
RUN echo "APP_DEBUG=true" >> .env
RUN echo "APP_TIMEZONE=UTC" >> .env
RUN echo "APP_URL=http://localhost" >> .env
RUN echo "APP_LOCALE=vi" >> .env
RUN echo "APP_FALLBACK_LOCALE=en" >> .env
RUN echo "APP_FAKER_LOCALE=en_US" >> .env
RUN echo "APP_MAINTENANCE_DRIVER=file" >> .env
RUN echo "PHP_CLI_SERVER_WORKERS=4" >> .env
RUN echo "BCRYPT_ROUNDS=12" >> .env
RUN echo "LOG_CHANNEL=stack" >> .env
RUN echo "LOG_STACK=single" >> .env
RUN echo "LOG_DEPRECATIONS_CHANNEL=null" >> .env
RUN echo "LOG_LEVEL=debug" >> .env
RUN echo "DB_CONNECTION=mysql" >> .env
RUN echo "DB_HOST=host.docker.internal" >> .env
RUN echo "DB_PORT=3306" >> .env
RUN echo "DB_DATABASE=ptdapm" >> .env
RUN echo "DB_USERNAME=root" >> .env
RUN echo "DB_PASSWORD=" >> .env
RUN echo "SESSION_DRIVER=database" >> .env
RUN echo "SESSION_LIFETIME=120" >> .env
RUN echo "SESSION_ENCRYPT=false" >> .env
RUN echo "SESSION_PATH=/" >> .env
RUN echo "SESSION_DOMAIN=null" >> .env
RUN echo "BROADCAST_CONNECTION=log" >> .env
RUN echo "FILESYSTEM_DISK=local" >> .env
RUN echo "QUEUE_CONNECTION=database" >> .env
RUN echo "CACHE_STORE=database" >> .env
RUN echo "CACHE_PREFIX=" >> .env
RUN echo "MEMCACHED_HOST=127.0.0.1" >> .env
RUN echo "REDIS_CLIENT=phpredis" >> .env
RUN echo "REDIS_HOST=127.0.0.1" >> .env
RUN echo "REDIS_PASSWORD=null" >> .env
RUN echo "REDIS_PORT=6379" >> .env
RUN echo "MAIL_MAILER=smtp" >> .env
RUN echo "MAIL_HOST=smtp.gmail.com" >> .env
RUN echo "MAIL_PORT=587" >> .env
RUN echo "MAIL_USERNAME=thanghavan2004@gmail.com" >> .env
RUN echo "MAIL_PASSWORD=poggfjeajujvzqwr" >> .env
RUN echo "MAIL_ENCRYPTION=tls" >> .env
RUN echo "MAIL_FROM_ADDRESS=thanghavan2004@gmail.com" >> .env
RUN echo "MAIL_FROM_NAME=\"Laravel\"" >> .env
RUN echo "AWS_ACCESS_KEY_ID=" >> .env
RUN echo "AWS_SECRET_ACCESS_KEY=" >> .env
RUN echo "AWS_DEFAULT_REGION=us-east-1" >> .env
RUN echo "AWS_BUCKET=" >> .env
RUN echo "AWS_USE_PATH_STYLE_ENDPOINT=false" >> .env
RUN echo "VITE_APP_NAME=\"Laravel\"" >> .env

# Cài thư viện Laravel
RUN composer install --no-dev --optimize-autoloader

# Tạo khóa ứng dụng Laravel (nếu chưa có sẵn APP_KEY)
RUN php artisan key:generate

# Set quyền thư mục storage, bootstrap
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Mở cổng 8000
EXPOSE 8000

# CMD để khởi chạy Laravel server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]

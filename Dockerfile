# ---------- Build frontend ----------
    FROM node:20 AS frontend

    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY resources ./resources
    COPY vite.config.* ./
    RUN npm run build
    
    
    # ---------- PHP + Nginx ----------
    FROM php:8.3-fpm
    
    # System deps
    RUN apt-get update && apt-get install -y \
        nginx \
        git \
        unzip \
        libpng-dev \
        libonig-dev \
        libxml2-dev \
        libsqlite3-dev \
        libpq-dev \
        && docker-php-ext-install pdo pdo_mysql pdo_pgsql pdo_sqlite
    
    # Install Composer
    COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
    
    WORKDIR /var/www/html
    
    # Copy Laravel app
    COPY . .
    
    # Copy built assets
    COPY --from=frontend /app/public/build ./public/build
    
    # Install PHP deps
    RUN composer install --no-dev --optimize-autoloader
    
    # Permissions
    RUN chown -R www-data:www-data storage bootstrap/cache
    
    # Nginx config
    COPY ./docker/nginx.conf /etc/nginx/sites-available/default
    
    EXPOSE 80
    
    CMD service nginx start && php-fpm
    
FROM php:8.1-fpm
# Install required extensions for PostgreSQL
RUN docker-php-ext-install pdo 

# Set working directory
WORKDIR /var/www/html
 # Copy content
COPY . .
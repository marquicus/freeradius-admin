FROM php:7.2-apache

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# Install requirements
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get \
        install -y --no-install-recommends \
            cron \
            curl \
            busybox

# Busybox installation
RUN busybox --install

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN docker-php-ext-install -j$(nproc) pdo_mysql

COPY ./web/src /var/www/html
RUN chown -R www-data /var/www/html
RUN a2enmod rewrite

VOLUME [ "/var/www/html/conf.d" ]

EXPOSE 80

# End of file
# vim: set ts=2 sw=2 noet:

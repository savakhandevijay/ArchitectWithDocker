FROM php:8.1-fpm-alpine

# Set ARG's for build time configuration
ARG SMTP_HOST="mailhog" SMTP_PORT="1025"
ENV SMTP_HOST=${SMTP_HOST} SMTP_PORT=${SMTP_PORT}

# basic alpine packages and its dependencies install
RUN apk update && apk add -U --no-cache build-base \
    libxml2-dev libsodium-dev libmcrypt-dev pkgconf \
    libgd libpng-dev libjpeg-turbo-dev freetype-dev  \
    make autoconf g++ gcc curl musl-dev bzip2-dev php-pear supervisor postfix

# php related packages and configuration
RUN docker-php-ext-configure calendar \
    && docker-php-ext-install -j$(nproc) gd mysqli soap bcmath opcache calendar bz2 sodium \
    && pecl install xdebug memcache mcrypt apcu \
    && docker-php-ext-enable xdebug memcache mcrypt apcu

# package constance set for socket
RUN CFLAGS="$CFLAGS -D_GNU_SOURCE" docker-php-ext-install sockets && \
    echo "sendmail_path='/usr/sbin/sendmail -t -i -fno_reply@webuy.com -Fno_reply'" >> /usr/local/etc/php/conf.d/sendmail.ini

# Postfix custom settings 
RUN postconf -e mynetworks_style='host' && postconf -e mydestination='$myhostname, localhost.$mydomain, localhost' && \
    postconf -e inet_interfaces='127.0.0.1' && postconf -e maillog_file='/var/log/php/mail.log' && \
    postconf -e relayhost="${SMTP_HOST}:${SMTP_PORT}"

#copy files to respective dir's
COPY ./php/configs/*.ini /usr/local/etc/php/conf.d/
COPY ./php/configs/supervisord.conf /etc/supervisord.conf

# remove unwanted files and directories
RUN rm -rf /tmp/* /var/cache/apk/* /var/log/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /etc/fstab

EXPOSE 9003

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
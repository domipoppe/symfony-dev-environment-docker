FROM php:8.1-fpm

ARG TIMEZONE
ENV APP_HOME /var/www/html
ENV USERNAME=www-data

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
      procps \
      nano \
      git \
      unzip \
      libicu-dev \
      zlib1g-dev \
      libxml2 \
      libxml2-dev \
      libreadline-dev \
      supervisor \
      cron \
      sudo \
      libzip-dev \
      wget \
      librabbitmq-dev \
    && pecl install amqp \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
      pdo_mysql \
      sockets \
      intl \
      opcache \
      zip \
    && docker-php-ext-enable amqp \
    && rm -rf /tmp/* \
    && rm -rf /var/list/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN mkdir -p $APP_HOME/public && \
    mkdir -p /home/$USERNAME && chown $USERNAME:$USERNAME /home/$USERNAME \
    && usermod -u 1000 $USERNAME -d /home/$USERNAME \
    && groupmod -g 1000 $USERNAME \
    && chown -R ${USERNAME}:${USERNAME} $APP_HOME

# PHP CONFIG
COPY ./.docker/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./.docker/php-fpm/php.ini /usr/local/etc/php/php.ini

# XDEBUG
COPY ./.docker/php-fpm/xdebug.ini /usr/local/etc/php/conf.d/
RUN pecl install xdebug

# COMPOSER
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN chmod +x /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR $APP_HOME
USER ${USERNAME}
COPY --chown=${USERNAME}:${USERNAME} . $APP_HOME/
USER root
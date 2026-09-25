FROM php:7.4-apache

RUN rm -f /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources \
    && printf '%s\n' \
      'deb [check-valid-until=no] https://snapshot.debian.org/archive/debian/20250101T000000Z/ bullseye main' \
      'deb [check-valid-until=no] https://snapshot.debian.org/archive/debian-security/20250101T000000Z/ bullseye-security main' \
      > /etc/apt/sources.list \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -o Acquire::Retries=3 update \
    && apt-get -o Acquire::Retries=3 install -y --no-install-recommends \
      libpng-dev libjpeg62-turbo-dev libfreetype6-dev libzip-dev libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j2 mysqli gd mbstring zip \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

RUN printf '%s\n' \
    'short_open_tag=On' \
    'upload_max_filesize=10M' \
    'post_max_size=12M' \
    'memory_limit=256M' \
    'display_errors=Off' \
    'log_errors=On' \
    'sendmail_path=/bin/true' \
    > /usr/local/etc/php/conf.d/haramain.ini

COPY site.conf /etc/apache2/sites-available/000-default.conf

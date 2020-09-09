FROM php:7.4.7-fpm

ARG TZ=Asia/Shanghai
ARG COMPOSER_REPO_PACKAGIST=https://mirrors.aliyun.com/composer/
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./sources.list /etc/apt/sources.list

RUN groupadd -g 1000 dnmp \
	&& useradd -u 1000 -g dnmp -m dnmp \
	&& usermod -p "*" dnmp

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y --no-install-recommends  \
	libssl-dev libicu-dev libmemcached-dev libz-dev libpq-dev libjpeg-dev libpng-dev libfreetype6-dev \
	libmcrypt-dev libzip-dev zip unzip libxml2-dev libxslt-dev librabbitmq-dev \
	&& pecl channel-update pecl.php.net \
	&& apt-get install -yqq \
	# PHP Redis Extension
	&& pecl install redis \
	&& docker-php-ext-enable redis \
	# PHP Memcache Extension
	&& pecl install memcached \
	&& docker-php-ext-enable memcached \
	# PHP mongo Extension
	&& pecl install mongodb \
	&& docker-php-ext-enable mongodb \
	&& pecl install msgpack \
	&& docker-php-ext-enable msgpack \
	# Opcache
	&& docker-php-ext-install opcache \
	# xdebug
	&& pecl install xdebug \
	&& docker-php-ext-enable xdebug \
	# amqp
	&& pecl install amqp \
	&& docker-php-ext-enable amqp

COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Composer
RUN curl -sfL https://getcomposer.org/installer | php -- --install-dir="/usr/bin" --filename=composer \
	&& chmod +x "/usr/bin/composer" \
	&& composer self-update --clean-backups

USER dnmp
RUN composer config -g repo.packagist composer ${COMPOSER_REPO_PACKAGIST}

USER root
# mb_string,pdo,zip....
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install pcntl \
	&& docker-php-ext-install intl \
	&& docker-php-ext-install soap \
	&& docker-php-ext-install xsl \
	&& docker-php-ext-install zip \
	&& docker-php-ext-install pdo_mysql \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-install exif \
	&& docker-php-ext-install bcmath \
	&& docker-php-ext-install calendar \
	&& docker-php-ext-install sockets \
	&& docker-php-ext-install gettext \
	&& docker-php-ext-install shmop \
	&& docker-php-ext-install sysvmsg \
	&& docker-php-ext-install sysvsem \
	&& docker-php-ext-install sysvshm

COPY ./www.conf /usr/local/etc/php-fpm.d/

RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000

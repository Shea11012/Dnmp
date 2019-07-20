FROM php:7.3

# Version
ARG PHPREDIS_VERSION=4.0.0
ARG	HIREDIS_VERSION=0.14.0
ARG	SWOOLE_VERSION=4.4.1
ARG	TIMEZONE=Asia/Shanghai

ARG COMPOSER_REPO_PACKAGIST=https://mirrors.aliyun.com/composer/

# Timezone
RUN /bin/cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
	&& echo ${TIMEZONE} > /etc/timezone

# Libs
RUN apt-get update \
	&& apt-get install -y \
	curl wget git zip unzip less vim openssl \
	libz-dev \
	libzip-dev \
	libssl-dev \
	libnghttp2-dev \
	libpcre3-dev \
	libjpeg-dev \
	libpng-dev \
	libfreetype6-dev \
	&& groupadd -g 1000 dnmp \
	&& useradd -u 1000 -g dnmp -m dnmp \
	&& usermod -p "*" dnmp

# Composer
RUN curl -sS https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/composer \
	&& composer self-update --clean-backups

USER dnmp

RUN composer config -g repo.packagist composer ${COMPOSER_REPO_PACKAGIST}

USER root
# PHP extension
RUN docker-php-ext-install \
	bcmath gd pdo_mysql mbstring sockets zip sysvmsg sysvsem sysvshm

# Redis extension
RUN wget http://pecl.php.net/get/redis-${PHPREDIS_VERSION}.tgz -O /tmp/redis.tar.tgz \
	&& pecl install /tmp/redis.tar.tgz \
	&& rm -rf /tmp/redis.tar.tgz \
	&& docker-php-ext-enable redis

# Hiredis
RUN wget https://github.com/redis/hiredis/archive/v${HIREDIS_VERSION}.tar.gz -O hiredis.tar.gz \
	&& mkdir -p hiredis \
	&& tar -xf hiredis.tar.gz -C hiredis --strip-components=1 \
	&& rm hiredis.tar.gz \
	&& ( \
	cd hiredis \
	&& make -j$(nproc) \
	&& make install \
	&& ldconfig \
	) \
	&& rm -r hiredis

# Swoole extension
RUN wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz -O swoole.tar.gz \
	&& mkdir -p swoole \
	&& tar -xf swoole.tar.gz -C swoole --strip-components=1 \
	&& rm swoole.tar.gz \
	&& ( \
	cd swoole \
	&& phpize \
	&& ./configure --enable-async-redis --enable-mysqlnd --enable-openssl --enable-http2 \
	&& make -j$(nproc) \
	&& make install \
	) \
	&& rm -r swoole \
	&& docker-php-ext-enable swoole

RUN apt-get clean \
	&& apt-get purge -y --auto-remove -o APT::AutoRemvoe::RecommendsImportant=false

WORKDIR /var/www

EXPOSE 9501

FROM php:7.4.9-cli-buster

# Version
#ARG PHPREDIS_VERSION=5.0.2
#ARG	HIREDIS_VERSION=0.14.0
ARG	SWOOLE_VERSION=4.5.2
ARG	TIMEZONE=Asia/Shanghai

ARG COMPOSER_REPO_PACKAGIST=https://mirrors.aliyun.com/composer/

COPY ./sources.list /etc/apt/sources.list

# Timezone
RUN /bin/cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
	&& echo ${TIMEZONE} > /etc/timezone

# Libs
RUN apt-get update \
	&& apt-get install -y \
	curl wget git zip unzip less vim openssl net-tools\
	libz-dev \
	libzip-dev \
	libssl-dev \
	libnghttp2-dev \
	libpcre3-dev \
	libjpeg-dev \
	libpng-dev \
	libfreetype6-dev \
	librabbitmq-dev \
	&& groupadd -g 1000 dnmp \
	&& useradd -u 1000 -g dnmp -m dnmp \
	&& usermod -p "*" dnmp

# Composer
RUN curl -sfL https://getcomposer.org/installer | php -- --install-dir="/usr/bin" --filename=composer \
	&& chmod +x "/usr/bin/composer" \
	&& composer self-update --clean-backups

RUN composer config -g repo.packagist composer ${COMPOSER_REPO_PACKAGIST}

# PHP extension
RUN docker-php-ext-install \
	bcmath gd pdo_mysql sockets zip sysvmsg sysvsem sysvshm \
	# amqp
	&& pecl install amqp \
	&& docker-php-ext-enable amqp

# Redis extension
# RUN wget http://pecl.php.net/get/redis-${PHPREDIS_VERSION}.tgz -O /tmp/redis.tar.tgz \
#	&& pecl install /tmp/redis.tar.tgz \
#	&& rm -rf /tmp/redis.tar.tgz \
#	&& docker-php-ext-enable redis

# Hiredis
# RUN wget https://github.com/redis/hiredis/archive/v${HIREDIS_VERSION}.tar.gz -O hiredis.tar.gz \
#	&& mkdir -p hiredis \
#	&& tar -xf hiredis.tar.gz -C hiredis --strip-components=1 \
#	&& rm hiredis.tar.gz \
#	&& ( \
#	cd hiredis \
#	&& make -j$(nproc) \
#	&& make install \
#	&& ldconfig \
#	) \
#	&& rm -r hiredis

# Swoole extension
RUN wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz -O swoole.tar.gz \
	&& mkdir -p swoole \
	&& tar -xf swoole.tar.gz -C swoole --strip-components=1 \
	&& rm swoole.tar.gz \
	&& ( \
	cd swoole \
	&& phpize \
	&& ./configure --enable-async-redis --enable-openssl --enable-http2 \
	&& make -j$(nproc) \
	&& make install \
	) \
	&& rm -r swoole \
	&& docker-php-ext-enable swoole

RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& rm /var/log/lastlog /var/log/faillog \
	&& apt-get purge -y --auto-remove -o APT::AutoRemvoe::RecommendsImportant=false

WORKDIR /var/www

EXPOSE 9501

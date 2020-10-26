FROM php:7.4.11-fpm-alpine

ARG TZ=Asia/Shanghai
ARG COMPOSER_REPO_PACKAGIST=https://mirrors.aliyun.com/composer/
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories


RUN addgroup -g 1000 dnmp \
	&& adduser -G dnmp -u 1000 -D dnmp

RUN apk update --no-cache && apk upgrade --no-cache && apk add --no-cache bash ${PHPIZE_DEPS} \
	libressl-dev icu-dev libmemcached-dev zlib-dev postgresql-dev libpng-dev libjpeg-turbo-dev \
	freetype-dev \
	libzip-dev zip unzip libxml2-dev rabbitmq-c-dev \
	&& pecl channel-update pecl.php.net \
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
COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf

# Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

USER dnmp
RUN composer config -g repo.packagist composer ${COMPOSER_REPO_PACKAGIST}

USER root
RUN apk add --no-cache libxslt-dev gettext-dev
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

RUN rm -rf /tmp/*

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000

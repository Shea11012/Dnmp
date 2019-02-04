FROM php:7.3.1-fpm

ARG TZ=Asia/Shanghai
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./sources.list.stretch /etc/apt/sources.list

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	curl \
	libmemcached-dev \
	libz-dev \
	libpq-dev \
	libjpeg-dev \
	libpng-dev \
	libfreetype6-dev \
	libssl-dev \
	libmcrypt-dev \
	libzip-dev

# PHP Redis Extension
RUN pecl install redis \
	&& docker-php-ext-enable redis

# PHP Memcache Extension
RUN pecl install memcached \
	&& docker-php-ext-enable memcached

# PHP swoole Extension
RUN pecl install swoole \
	&& docker-php-ext-enable swoole

# PHP mongo Extension
RUN pecl install mongodb && \
	docker-php-ext-enable mongodb


# Opcache
RUN docker-php-ext-install opcache

COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# mb_string,pdo,zip....
RUN apt-get update \
	&& apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install gd \
	&& apt-get install -y libicu-dev \
	&& docker-php-ext-install intl \
	&& apt-get install -y libxml2-dev \
	&& apt-get install -y libxslt-dev \
	&& docker-php-ext-install soap \
	&& docker-php-ext-install xsl \
	&& docker-php-ext-install wddx \
	&& apt-get install -y libbz2-dev \
	&& docker-php-ext-install bz2 \
	&& docker-php-ext-install zip \
	&& docker-php-ext-install pcntl \
	&& docker-php-ext-install pdo_mysql \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-install mbstring \
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

RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	rm /var/log/lastlog /var/log/faillog

RUN usermod -u 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000 9501

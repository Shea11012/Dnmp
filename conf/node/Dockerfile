FROM node:10

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

WORKDIR /var/www/html

RUN npm config set registry https://registry.npm.taobao.org

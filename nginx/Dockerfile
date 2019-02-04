FROM nginx:alpine

ARG TZ=Asia/Shanghai
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

COPY ./nginx.conf /etc/nginx/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache bash \
	&& adduser -D -H -u 1000 -s /bin/bash www-data

CMD ["nginx"]

EXPOSE 80 443
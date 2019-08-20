FROM nginx:alpine

ARG TZ=Asia/Shanghai
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

COPY ./nginx.conf /etc/nginx/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
	&& apk update \
	&& apk upgrade \
	&& apk add --no-cache bash \
	&& set -x ;\
	addgroup -g 82 -S www-data ;\
	adduser -D -S -u 82 -G www-data www-data && exit 0;exit 1

CMD ["nginx"]

EXPOSE 80 443
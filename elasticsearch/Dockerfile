# FROM docker.elastic.co/elasticsearch/elasticsearch:6.6.0
FROM elasticsearch:7.6.2

ARG TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone
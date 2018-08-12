#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
case $i in
    "generate")
        docker run --rm -v $HOME/Dnmp/www/letsencrypt:/etc/letsencrypt -v $HOME/Dnmp/www:/var/www --name cert mycertbot:1.0 \
        certbot certonly --webroot -w /var/www -d zhu-zi.top -d www.zhu-zi.top -m 1872314654@qq.com --agree-tos --non-interactive
        ;;
    "renew")
        docker run --rm -v $HOME/Dnmp/www/letsencrypt:/etc/letsencrypt -v $HOME/Dnmp/www:/var/www --name cert mycertbot:1.0 \
        certbot renew
        docker exec dnmp_nginx_1 bash -c 'nginx -s reload'
        ;;
esac

exit 0
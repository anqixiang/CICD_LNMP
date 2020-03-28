FROM richarvey/nginx-php-fpm
MAINTAINER nsd_anqixiang@163.com

#用于版本控制
ENV WORDPRESS_VERSION 4.9
COPY index.html /var/www/html
ADD wordpress-${WORDPRESS_VERSION}-zh_CN.tar.gz /var/www/html

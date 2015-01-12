FROM debian:wheezy

MAINTAINER Christian Luginbühl <dinkel@pimprecords.com>

ENV NGINX_VERSION 1.6.2-1~wheezy
ENV PHP_VERSION 5.4.36-0+deb7u1

RUN apt-key adv --keyserver pgp.mit.edu --recv-key 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/debian/ wheezy nginx" >> /etc/apt/sources.list

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        nginx=${NGINX_VERSION} \
        php5-fpm=${PHP_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stderr /var/log/php-fpm.log

RUN rm /etc/nginx/conf.d/*

COPY nginx.conf /etc/nginx/

COPY default.conf /etc/nginx/conf.d/

COPY www.conf /etc/php5/fpm/pool.d/

EXPOSE 80

COPY run.sh /

CMD ["/run.sh"]

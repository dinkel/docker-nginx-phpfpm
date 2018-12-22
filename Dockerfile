FROM debian:stretch

MAINTAINER Christian Luginbühl <dinkel@pimprecords.com>

ENV NGINX_VERSION 1.10.3
ENV PHP_VERSION 1:7.0

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ca-certificates \
        nginx=${NGINX_VERSION}* \
        php-fpm=${PHP_VERSION}* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stderr /var/log/php-fpm.log

RUN mkdir /run/php

RUN rm -rf /var/www/ && \
    mkdir -p /var/www/ && \
    echo "<?php echo \"OK\";" > /var/www/index.php

COPY default /etc/nginx/sites-available/
COPY fastcgi-php.conf /etc/nginx/snippets/

EXPOSE 80

COPY run.sh /

CMD ["/run.sh"]


#!/bin/sh

php-fpm7.0
nginx

pidfile_phpfpm="/run/php/php7.0-fpm.pid"
pidfile_nginx="/run/nginx.pid"

while : ; do
    if ! pgrep -F $pidfile_phpfpm > /dev/null 2>&1; then
        echo "Daemon process php-fpm7.0 died!"
        exit 1
    fi

    if ! pgrep -F $pidfile_nginx > /dev/null 2>&1; then
        echo "Daemon process nginx died!"
        exit 1
    fi

    sleep 5
done

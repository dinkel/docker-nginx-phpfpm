docker-nginx-phpfpm
===================

Yet another Docker image with Nginx and phpfpm. The reasons for this are:

* I'm not very happy with images using `supervisord` (see section "Explaining 
  run.sh").
* I want the logs be written to `stdout` and `stderr`.
* I run this container behind a load balancer, that takes care of HTTPS. 
  Therefore I only need to expose port 80.

I wanted to create a very barebones image, that can act as a starting point for 
actual web applications (ownCloud, WordPress, you name it).

Usage
-----

As described before, this image should be understood as a starting point for 
images that provide web applications and is (mainly because of the limited PHP
modules) not very useful to be run on its own.

You can however run it like so

    docker run -d -p 80:80 -v /path/to/php-files:/var/www dinkel/ngnix-phpfpm

Usage as starting point
-----------------------

The intended way to use this image is as the first line in a `Dockerfile`:

    FROM dinkel/nginx-phpfpm

Then rewrite one or more of the files

    default.conf (`server` section(s) for Nginx configuration)
    www.conf (configuration for phpfpm)
    nginx.conf (base configuration for Nginx)

and add your web application.
    
Configuration (environment variables)
-------------------------------------

None at the moment.

Data persistence
----------------

I have long thought about having a `VOLUME ["/var/www/"]` directive inside the
Dockerfile, but decided against, because the image should not be used standalone
but as an intermediary image. Therefore I did not want to dictate a web root
(although I still think that one shouldn't move away from `/var/www`).

Explaining run.sh
-----------------

This is a poor man's `supervisord`. It is my strong (but not so much challenged)
belief, that there shouldn't be yet another process manager (Docker has one, 
CoreOS has one (with `fleet` and `systemd`).

The only thing this script does is watching its forked (background) processes
and as soon as one dies, it terminates all the others and exits with the code 
of the first dying process.

Todo
----

* Make sure my little script above works in all circumstances. I know that when
  omitting the `-d` one cannot stop the process using `<Ctrl><c>`.

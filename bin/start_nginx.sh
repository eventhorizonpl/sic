#!/bin/sh
sudo systemctl stop httpd.service
sudo systemctl restart php-fpm.service
sudo systemctl restart nginx.service
sudo systemctl restart postgresql.service
sudo systemctl restart memcached.service
sudo systemctl restart varnish.service

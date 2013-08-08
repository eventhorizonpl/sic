#!/bin/sh
sudo systemctl restart httpd.service
sudo systemctl restart postgresql.service
sudo systemctl restart memcached.service
sudo systemctl restart varnish.service

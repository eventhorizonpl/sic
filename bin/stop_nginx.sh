#!/bin/sh
sudo systemctl stop nginx.service
sudo systemctl restart postgresql.service
sudo systemctl restart memcached.service
sudo systemctl restart varnish.service

#!/bin/sh

sudo setfacl -R -m u:apache:rwx -m u:`whoami`:rwx app/cache app/logs
sudo setfacl -dR -m u:apache:rwx -m u:`whoami`:rwx app/cache app/logs

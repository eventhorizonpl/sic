#!/bin/sh

source ./lib

function install_package()
{
    show_message "Installing php..."
    yum install --assumeyes php php-bcmath php-cli php-common php-fpm php-gd php-gmp php-imap php-intl php-mbstring php-mcrypt php-mysqlnd php-opcache php-pdo php-pgsql php-process php-snmp php-xml php-pecl-imagick php-pecl-xdebug php-pecl-mongo php-pecl-memcache php-pecl-memcached php-phpunit-* > /dev/null 2>&1
    show_result $?
}

while [ $# -ne 0 ]
do
    if [ $1 == "install" ]
    then
	install_package
    fi
    shift
done

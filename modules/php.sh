#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring php..."

    show_message "\tTimezone..."
    sed -i "s/;date.timezone =/date.timezone = \"Europe\/Warsaw\"/g" /etc/php.ini >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tMemory limit..."
    sed -i "s/memory_limit = 128M/memory_limit = 1024M/g" /etc/php.ini >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tMax execution time..."
    sed -i "s/max_execution_time = 30/max_execution_time = 120/g" /etc/php.ini >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tUpload max filesize..."
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 8M/g" /etc/php.ini >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    if [ $OS == "fedora" ]
    then
        show_message "Installing php..."
        yum install --assumeyes php php-bcmath php-cli php-common php-fpm php-gd php-gmp php-imap php-intl php-mbstring php-mcrypt php-mysqlnd php-opcache php-pdo php-pgsql php-process php-snmp php-xml php-pecl-imagick php-pecl-apcu php-pecl-xdebug php-pecl-mongo php-pecl-memcache php-pecl-memcached php-phpunit-* phpPgAdmin phpMyAdmin --skip-broken >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        show_message "Installing php..."
        yum install --assumeyes --enablerepo=remi-php55 php php-bcmath php-cli php-common php-fpm php-gd php-gmp php-imap php-intl php-mbstring php-mcrypt php-mysqlnd php-opcache php-pdo php-pgsql php-process php-snmp php-xml php-pecl-imagick php-pecl-apcu php-pecl-xdebug php-pecl-mongo php-pecl-memcache php-pecl-memcached php-phpunit-* phpPgAdmin phpMyAdmin --skip-broken >> /tmp/install.log 2>&1
        show_result $?
    fi
}

while [ $# -ne 0 ]
do
    if [ $1 == "install" ]
    then
        install_package
    elif [ $1 == "configure" ]
    then
        configure_package
    fi
    shift
done

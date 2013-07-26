#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Restarting services..."

    show_message "\thttpd.service ..."
    systemctl restart httpd.service  > /dev/null 2>&1
    show_result $?

    show_message "\tmemcached.service..."
    systemctl restart memcached.service > /dev/null 2>&1
    show_result $?

    show_message "\tmongod.service..."
    systemctl restart mongod.service > /dev/null 2>&1
    show_result $?

    show_message "\tmysqld.service..."
    systemctl restart > /dev/null 2>&1
    show_result $?

    show_message "\tnginx.service..."
    systemctl restart nginx.service > /dev/null 2>&1
    show_result $?

    show_message "\tpostgresql.service..."
    systemctl restart postgresql.service > /dev/null 2>&1
    show_result $?

    show_message "\tsmb.service..."
    systemctl restart smb.service > /dev/null 2>&1
    show_result $?

    show_message "\tvarnish.service..."
    systemctl restart varnish.service > /dev/null 2>&1
    show_result $?
}

while [ $# -ne 0 ]
do
    if [ $1 == "configure" ]
    then
	configure_package
    fi
    shift
done

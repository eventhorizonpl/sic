#!/bin/sh

source ./lib

function configure_package()
{
    show_message "\tRestarting memcached..."
    systemctl restart memcached.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling memcached..."
    systemctl enable memcached.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing memcached..."
    yum install --assumeyes memcached >> /tmp/install.log 2>&1
    show_result $?
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

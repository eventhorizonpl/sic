#!/bin/sh

source ./lib

function configure_package()
{
    show_message "\tRestarting redis..."
    systemctl restart redis.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling redis..."
    systemctl enable redis.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing redis..."
    yum install --assumeyes redis >> /tmp/install.log 2>&1
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

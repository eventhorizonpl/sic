#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring varnish..."

    show_message "\tRestarting varnish..."
    systemctl restart varnish.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling varnish..."
    systemctl enable varnish.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing varnish..."
    yum install --assumeyes varnish varnish-libs >> /tmp/install.log 2>&1
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

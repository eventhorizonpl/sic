#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring nginx..."

    show_message "\tPathes in config file..."
    sed -i "s/listen       80/listen       81/g" /etc/nginx/nginx.conf > /dev/null 2>&1
    show_result $?

    show_message "\tRestarting nginx..."
    systemctl restart nginx.service > /dev/null 2>&1
    show_result $?

    show_message "\tEnabling nginx..."
    systemctl enable nginx.service > /dev/null 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing nginx..."
    yum install --assumeyes nginx > /dev/null 2>&1
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

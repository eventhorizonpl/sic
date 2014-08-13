#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring nginx..."

    show_message "\tPathes in config file..."
    sed -i "s/listen       80/listen       81/g" /etc/nginx/nginx.conf >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling nginx in firewall..."
    firewall-cmd --permanent --zone=public --add-port=81/tcp >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting nginx..."
    systemctl restart nginx.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling nginx..."
    systemctl enable nginx.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    if [ $OS == "fedora" ]
    then
        show_message "Installing nginx..."
        yum install --assumeyes nginx >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        show_message "Installing nginx..."
        yum install --assumeyes --enablerepo=epel nginx >> /tmp/install.log 2>&1
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

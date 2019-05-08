#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring golang..."

    show_message "\tEnabling meteor in firewall..."
    firewall-cmd --permanent --zone=public --add-port=9000/tcp >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing golang..."
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes golang >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        if [ $VERSION == "8" ]
        then
            dnf install --assumeyes golang >> /tmp/install.log 2>&1
            show_result $?
        fi
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

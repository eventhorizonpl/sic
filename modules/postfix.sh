#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring postfix..."

    show_message "\tRestarting postfix..."
    systemctl restart postfix.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling postfix..."
    systemctl enable postfix.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing postfix..."
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes postfix >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        if [ $VERSION == "7" ]
        then
            yum install --assumeyes postfix >> /tmp/install.log 2>&1
            show_result $?
        elif [ $VERSION == "8" ]
        then
            dnf install --assumeyes postfix >> /tmp/install.log 2>&1
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

#!/bin/sh

source ./lib

function install_package()
{
    show_message "Installing kernel tools..."
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes gcc make >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        if [ $VERSION == "7" ]
        then
            yum install --assumeyes gcc make >> /tmp/install.log 2>&1
            show_result $?
        elif [ $VERSION == "8" ]
        then
            dnf install --assumeyes gcc make >> /tmp/install.log 2>&1
            show_result $?
        fi
    fi
}

while [ $# -ne 0 ]
do
    if [ $1 == "install" ]
    then
        install_package
    fi
    shift
done

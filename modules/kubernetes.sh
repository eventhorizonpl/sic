#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring kubernetes..."
}

function install_package()
{
    show_message "Installing kubernetes..."
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes kubernetes >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        if [ $VERSION == "7" ]
        then
            show_message "\tInstalling yum utils..."
            yum install --assumeyes yum-utils device-mapper-persistent-data lvm2 >> /tmp/install.log 2>&1
            show_result $?

            show_message "\tAdding docker repo..."
            yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo >> /tmp/install.log 2>&1
            show_result $?

            show_message "\tInstalling docker package..."
            yum install docker-ce docker-ce-cli containerd.io >> /tmp/install.log 2>&1
            show_result $?
#        elif [ $VERSION == "8" ]
#        then
#            show_result $?
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

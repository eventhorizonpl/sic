#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring kubernetes..."

    show_message "\tRestarting kubernetes..."
    systemctl restart kubelet.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling kubernetes..."
    systemctl enable kubelet.service >> /tmp/install.log 2>&1
    show_result $?
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
            show_message "\tCopying repo file..."
            cp etc/repo/kubernetes.repo /etc/yum.repos.d/ >> /tmp/install.log 2>&1
            show_result $?

            show_message "\tInstalling kubernetes package..."
            yum install --assumeyes kubelet kubeadm kubectl >> /tmp/install.log 2>&1
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

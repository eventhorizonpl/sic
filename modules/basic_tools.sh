#!/bin/sh

source ./lib

function install_package()
{
    if [ $OS == "rhel" ]
    then
        show_message "Installing EPEL release package..."
        rpm -ihv http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm >> /tmp/install.log 2>&1
        show_result $?

        show_message "Installing REMI release package..."
        rpm -ihv http://rpms.famillecollet.com/enterprise/remi-release-7.rpm >> /tmp/install.log 2>&1
        show_result $?
    fi

    show_message "Installing basic tools..."
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes acl bzip2 git mc net-tools ntpdate patch \
        screen tar unzip vim wget >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        yum install --assumeyes acl bzip2 git mc net-tools ntpdate patch \
        screen tar unzip vim wget >> /tmp/install.log 2>&1
        show_result $?
    fi

    show_message "\tRestarting ntpdate..."
    systemctl restart ntpdate.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling ntpdate..."
    systemctl enable ntpdate.service >> /tmp/install.log 2>&1
    show_result $?

#    show_message "Installing npm tools..."
#    npm install -g less >> /tmp/install.log 2>&1
#    show_result $?
}

while [ $# -ne 0 ]
do
    if [ $1 == "install" ]
    then
        install_package
    fi
    shift
done

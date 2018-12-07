#!/bin/sh

source ./lib

function install_package()
{
    if [ $OS == "rhel" ]
    then
        if [ $VERSION == "7" ]
        then
            show_message "Installing EPEL release package..."
            rpm -ihv https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm >> /tmp/install.log 2>&1
            show_result $?

            show_message "Installing REMI release package..."
            rpm -ihv http://rpms.remirepo.net/enterprise/remi-release-7.rpm >> /tmp/install.log 2>&1
            show_result $?
        fi
    fi

    show_message "Installing basic tools..."
    if [ $OS == "fedora" ]
    then
        if [ $ONLY_ESSENTIAL == "yes" ]
        then
            dnf install --assumeyes bzip2 git-core mc ntpdate policycoreutils-python-utils vim >> /tmp/install.log 2>&1
        else
            dnf install --assumeyes acl bzip2 git mc net-tools ntpdate patch \
            policycoreutils-python-utils screen tar unzip vim wget >> /tmp/install.log 2>&1
        fi
        show_result $?
    elif [ $OS == "rhel" ]
    then
        if [ $VERSION == "7" ]
        then
            yum install --assumeyes acl bzip2 git mc net-tools ntpdate patch \
            policycoreutils-python screen tar unzip vim wget >> /tmp/install.log 2>&1
            show_result $?
        fi
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
    elif [ -f $1 ]
    then
        source $1
    fi
    shift
done

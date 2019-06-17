#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring nodejs..."

    show_message "\tEnabling angular in firewall..."
    firewall-cmd --permanent --zone=public --add-port=8000/tcp >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling meteor in firewall..."
    firewall-cmd --permanent --zone=public --add-port=3000/tcp >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing nodejs..."

    curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo

    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes nodejs yarn >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        if [ $VERSION == "7" ]
        then
            wget -qO- https://rpm.nodesource.com/setup_10.x | bash >> /tmp/install.log 2>&1
            yum install --assumeyes nodejs yarn >> /tmp/install.log 2>&1
            show_result $?
        elif [ $VERSION == "8" ]
        then
            dnf install --assumeyes nodejs yarn >> /tmp/install.log 2>&1
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

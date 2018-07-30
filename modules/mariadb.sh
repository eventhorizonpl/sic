#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring mariadb..."

    show_message "\tEnabling mysql in firewall..."
    firewall-cmd --permanent --zone=public --add-service=mysql >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting mariadb..."
    systemctl restart mariadb.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling mariadb..."
    systemctl enable mariadb.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating user..."
    mysql < etc/mariadb.sql >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing mariadb..."
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes mariadb mariadb-server mariadb-devel >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        yum install --assumeyes mariadb mariadb-libs mariadb-server mariadb-devel >> /tmp/install.log 2>&1
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

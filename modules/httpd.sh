#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring httpd..."

    show_message "\tCopying config file..."
    cp etc/httpd/conf.d/virtual.conf /etc/httpd/conf.d/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling httpd in firewall..."
    firewall-cmd --permanent --zone=public --add-service=http >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting httpd..."
    systemctl restart httpd.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling httpd..."
    systemctl enable httpd.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing httpd..."
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes httpd mod_ssl >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        if [ $VERSION == "7" ]
        then
            yum install --assumeyes httpd mod_ssl >> /tmp/install.log 2>&1
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

#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring samba..."

    show_message "\tCopying config file..."
    cp etc/samba/smb.conf /etc/samba/smb.conf >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tAdding new user..."
    smbpasswd -a michal

    show_message "\tEnabling samba in firewall..."
    firewall-cmd --permanent --zone=public --add-service=samba >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting smb..."
    systemctl restart smb.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling smb..."
    systemctl enable smb.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling selinux for samba..."
    semanage fcontext -a -t samba_share_t "/home/michal/projects(/.*)?" >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling selinux for samba..."
    restorecon -R -v /home/michal/projects/ >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing samba..."
    if [ $OS == "fedora" ]
    then
        if [ $ONLY_ESSENTIAL == "yes" ]
        then
            dnf install --assumeyes samba samba-common-tools >> /tmp/install.log 2>&1
        else
            dnf install --assumeyes samba samba-client samba-common samba-common-tools samba-libs samba-winbind >> /tmp/install.log 2>&1
        fi
        show_result $?
    elif [ $OS == "rhel" ]
    then
        if [ $VERSION == "7" ]
        then
            yum install --assumeyes samba samba-client samba-common samba-libs samba-winbind >> /tmp/install.log 2>&1
            show_result $?
        elif [ $VERSION == "8" ]
        then
            dnf install --assumeyes samba samba-common-tools >> /tmp/install.log 2>&1
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
    elif [ -f $1 ]
    then
        source $1
    fi
    shift
done

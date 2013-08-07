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

    show_message "\tRestarting smb..."
    systemctl restart smb.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling smb..."
    systemctl enable smb.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing samba..."
    yum install --assumeyes samba samba-client samba-common samba-libs samba-winbind >> /tmp/install.log 2>&1
    show_result $?
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

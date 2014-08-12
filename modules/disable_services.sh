#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Disabling services..."

    show_message "\tNetworkManager-dispatcher.service..."
    systemctl disable NetworkManager-dispatcher.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tauditd.service..."
    systemctl disable auditd.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tavahi-daemon.service..."
    systemctl disable avahi-daemon.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tremote-fs.target..."
    systemctl disable remote-fs.target >> /tmp/install.log 2>&1
    show_result $?
}

while [ $# -ne 0 ]
do
    if [ $1 == "configure" ]
    then
        configure_package
    fi
    shift
done

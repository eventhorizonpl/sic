#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Disabling SELinux..."

    show_message "\tsetenforce..."
    setenforce 0 > /dev/null 2>&1
    show_result $?

    show_message "\tsysconfig..."
    sed -i "s@^\(SELINUX=\).*@\1disabled@" /etc/sysconfig/selinux > /dev/null 2>&1
    show_result $?
}

function remove_package()
{
    show_message "Removing SELinux..."
#    yum remove --assumeyes policycoreutils selinux-policy-targeted > /dev/null 2>&1
    show_result $?
}

while [ $# -ne 0 ]
do
    if [ $1 == "configure" ]
    then
	configure_package
    elif [ $1 == "remove" ]
    then
	remove_package
    fi
    shift
done

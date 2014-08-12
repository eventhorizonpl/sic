#!/bin/sh

source ./lib

function install_package()
{
    if [ $OS == "rhel" ]
    then
        show_message "Installing EPEL release package..."
        rpm -ihv http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm >> /tmp/install.log 2>&1
        show_result $?
    fi

    show_message "Installing basic tools..."
    yum install --assumeyes acl bootchart bzip2 cmake cryptsetup deltarpm fedup \
    gcc gcc-c++ git java libsqlite3x libsqlite3x-devel lm_sensors lsof lucene make mc \
    net-tools nodejs npm patch pcre-devel policycoreutils-python redhat-rpm-config \
    screen subversion tar tigervnc-server unixODBC-devel unzip vim wget >> /tmp/install.log 2>&1
    show_result $?

    if [ $OS == "fedora" ]
    then
        show_message "Installing npm tools..."
        npm install -g less >> /tmp/install.log 2>&1
        show_result $?
    fi
}

while [ $# -ne 0 ]
do
    if [ $1 == "install" ]
    then
        install_package
    fi
    shift
done

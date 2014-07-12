#!/bin/sh

source ./lib

function install_package()
{
    if [ $OS == "rhel" ]
    then
        show_message "\tInstalling EPEL release package..."
        rpm -ihv http://ftp.pbone.net/pub/fedora/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm
        show_result $?
    fi

    show_message "Installing basic tools..."
    yum install --assumeyes acl bootchart bzip2 cmake cryptsetup deltarpm ecryptfs-utils fedup \
	gcc gcc-c++ git java libsqlite3x libsqlite3x-devel lm_sensors lucene make mc \
	net-tools nodejs npm patch pcre-devel policycoreutils-python redhat-rpm-config \
	screen subversion tar tigervnc-server unixODBC-devel unzip vim wget >> /tmp/install.log 2>&1
    show_result $?

    show_message "Installing npm tools..."
    npm install -g less >> /tmp/install.log 2>&1
    show_result $?
}

while [ $# -ne 0 ]
do
    if [ $1 == "install" ]
    then
	install_package
    fi
    shift
done

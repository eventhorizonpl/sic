#!/bin/sh

source ./lib

function install_package()
{
    show_message "Installing basic tools..."
    yum install --assumeyes acl bootchart bzip2 cmake deltarpm ecryptfs-utils fedup \
	gcc gcc-c++ git java libsqlite3x libsqlite3x-devel lm_sensors make mc \
	net-tools nodejs npm pcre-devel policycoreutils-python redhat-rpm-config \
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

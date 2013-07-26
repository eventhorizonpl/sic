#!/bin/sh

source ./lib

function install_package()
{
    show_message "Installing basic tools..."
    yum install --assumeyes acl bzip2 cmake ecryptfs-utils \
	gcc gcc-c++ git libsqlite3x libsqlite3x-devel make mc \
	nodejs npm pcre-devel policycoreutils-python redhat-rpm-config \
	screen subversion tar unixODBC-devel unzip vim wget > /dev/null 2>&1
    show_result $?

    show_message "Installing npm tools..."
    npm install -g less > /dev/null 2>&1
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

#!/bin/sh

source ./lib

function install_package()
{
    show_message "Installing basic tools..."
    yum install --assumeyes acl bzip2 cmake ecryptfs-utils gcc gcc-c++ git make mc policycoreutils-python redhat-rpm-config subversion tar unzip vim wget > /dev/null 2>&1
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

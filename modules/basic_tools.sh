#!/bin/sh

source ./lib

function install_package()
{
    show_message "Installing basic tools..."
    yum install --assumeyes bzip2 cmake gcc gcc-c++ git make mc redhat-rpm-config tar unzip vim wget > /dev/null 2>&1
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

#!/bin/sh

source ./lib

function install_package()
{
    show_message "Installing hhvm..."
    if [ $OS == "fedora" ]
    then
        show_message "\tPreparing repository"
        cp etc/yum.repos.d/hhvm-fedora.repo /etc/yum.repos.d/hhvm.repo >> /tmp/install.log 2>&1
        show_result $?

        show_message "\tDownloading key"
        wget http://dl.hhvm.com/conf/hhvm.gpg.key >> /tmp/install.log 2>&1
        show_result $?

        show_message "\tImporting key"
        rpm --import hhvm.gpg.key >> /tmp/install.log 2>&1
        show_result $?

        show_message "\tInstalling package..."
        yum install --assumeyes hhvm
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

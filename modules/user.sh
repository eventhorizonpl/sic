#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Adding michal to wheel..."
    usermod -a -G wheel michal > /dev/null 2>&1
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

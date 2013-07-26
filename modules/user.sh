#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring user..."

    show_message "\tAdding michal to wheel..."
    usermod -a -G wheel michal > /dev/null 2>&1
    show_result $?

    show_message "\tCreating bin..."
    mkdir -p /home/michal/bin > /dev/null 2>&1
    show_result $?

    show_message "\tCopying utilities to bin..."
    cp bin/* /home/michal/bin > /dev/null 2>&1
    show_result $?

    show_message "\tChanging mode..."
    chmod 755 /home/michal/bin/* > /dev/null 2>&1
    show_result $?

    show_message "\tCreating projekty..."
    mkdir -p /home/michal/projekty > /dev/null 2>&1
    show_result $?

    show_message "\tChanging ownership..."
    chown -R michal:michal /home/michal/ > /dev/null 2>&1
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

#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring user..."

    show_message "\tCreating staff group..."
    groupadd staff >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tAdding michal to staff..."
    usermod -a -G staff michal >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tAdding michal to wheel..."
    usermod -a -G wheel michal >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating bin..."
    mkdir -p /home/michal/bin >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying utilities to bin..."
    cp bin/* /home/michal/bin >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying .gitconfig..."
    cp etc/.gitconfig /home/michal/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying .my.cnf..."
    cp etc/.my.cnf /home/michal/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying .pgpass..."
    cp etc/.pgpass /home/michal/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging mode..."
    chmod 755 /home/michal/bin/* >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating backup..."
    mkdir -p /home/michal/backup >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating projekty..."
    mkdir -p /home/michal/projekty >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging ownership..."
    chown -R michal:michal /home/michal/ >> /tmp/install.log 2>&1
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

#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring redis..."

    show_message "\tStopping redis..."
    systemctl stop redis.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating /home/data..."
    mkdir -p /home/data >> /tmp/install.log 2>&1
    show_result $?

    if [ -e /home/data/redis/ ]
    then
        show_message "\tRemoving /home/data/redis..."
        rm -rf /home/data/redis/ >> /tmp/install.log 2>&1
        show_result $?
    fi

    show_message "\tCreating /home/data/redis..."
    cp -R /var/lib/redis/ /home/data/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging ownership /home/data/redis..."
    chown -R redis:redis /home/data/redis/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tData dir path in config file..."
    sed -i "s/dir\ \/var\/lib\/redis/dir\ \/home\/data\/redis/g" /etc/redis.conf >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting redis..."
    systemctl restart redis.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling redis..."
    systemctl enable redis.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing redis..."
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes redis >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        yum install --assumeyes redis >> /tmp/install.log 2>&1
        show_result $?
    fi
}

while [ $# -ne 0 ]
do
    if [ $1 == "install" ]
    then
        install_package
    elif [ $1 == "configure" ]
    then
        configure_package
    fi
    shift
done

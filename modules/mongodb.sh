#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring mongodb..."

    show_message "\tStopping mongod..."
    systemctl stop mongod.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tDownloading phpMoAdmin..."
    wget -O /tmp/master.zip https://github.com/MongoDB-Rox/phpMoAdmin-MongoDB-Admin-Tool-for-PHP/archive/master.zip >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tUnpacking phpMoAdmin..."
    unzip -o /tmp/master.zip -d /usr/share/phpMoAdmin/ && mv /usr/share/phpMoAdmin/phpMoAdmin-MongoDB-Admin-Tool-for-PHP-master/* /usr/share/phpMoAdmin/ && rmdir /usr/share/phpMoAdmin/phpMoAdmin-MongoDB-Admin-Tool-for-PHP-master/ && mv /usr/share/phpMoAdmin/moadmin.php /usr/share/phpMoAdmin/index.php >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying config file..."
    cp etc/httpd/conf.d/phpMoAdmin.conf /etc/httpd/conf.d/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting mongod..."
    systemctl restart mongod.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling mongod..."
    systemctl enable mongod.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing mongodb..."
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes mongodb mongodb-server >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        yum install --assumeyes mongodb mongodb-server >> /tmp/install.log 2>&1
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

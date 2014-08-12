#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring mariadb..."

    show_message "\tStopping mariadb..."
    systemctl stop mariadb.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating /home/data..."
    mkdir -p /home/data >> /tmp/install.log 2>&1
    show_result $?

    if [ -e /home/data/mysql/ ]
    then
        show_message "\tRemoving /home/data/mysql..."
        rm -rf /home/data/mysql/ >> /tmp/install.log 2>&1
        show_result $?
    fi

    show_message "\tCreating /home/data/mysql..."
    cp -R /var/lib/mysql/ /home/data/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging ownership /home/data/mysql..."
    chown -R mysql:mysql /home/data/mysql/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging context /home/data/mysql..."
    semanage fcontext -a -t "mysqld_db_t" "/home/data/mysql(/.*)?" >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestoring context /home/data/mysql..."
    restorecon -R -v /home/data/mysql >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tData dir path in config file..."
    sed -i "s/datadir=\/var\/lib\/mysql/datadir=\/home\/data\/mysql/g" /etc/my.cnf >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tSocket dir path in config file..."
    sed -i "s/socket=\/var\/lib\/mysql\/mysql.sock/datadir=\/home\/data\/mysql\/mysql.sock/g" /etc/my.cnf >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying config file..."
    cp etc/httpd/conf.d/phpMyAdmin.conf /etc/httpd/conf.d/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling mysql in firewall..."
    firewall-cmd --permanent --zone=public --add-service=mysql >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting mariadb..."
    systemctl restart mariadb.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling mariadb..."
    systemctl enable mariadb.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating user..."
    mysql < etc/mariadb.sql >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    if [ $OS == "fedora" ]
    then
        show_message "Installing mariadb..."
        yum install --assumeyes mariadb mariadb-libs mariadb-server mariadb-devel phpMyAdmin >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        show_message "Installing REMI release package..."
        rpm -ihv http://rpms.famillecollet.com/enterprise/remi-release-7.rpm >> /tmp/install.log 2>&1
        show_result $?

        show_message "Installing mariadb..."
        yum install --assumeyes --enablerepo=remi mariadb mariadb-libs mariadb-server mariadb-devel phpMyAdmin >> /tmp/install.log 2>&1
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

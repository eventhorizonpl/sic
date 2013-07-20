#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring httpd..."

    show_message "\tCreating /home/data..."
    mkdir -p /home/data > /dev/null 2>&1
    show_result $?

    show_message "\tCreating /home/data/www..."
    cp -R /var/www/ /home/data/ > /dev/null 2>&1
    show_result $?

    show_message "\tPathes in config file..."
    sed -i "s/\/var\/www/\/home\/data\/www/g" /etc/httpd/conf/httpd.conf > /dev/null 2>&1
    show_result $?

    show_message "\tRestarting httpd..."
    systemctl restart httpd.service > /dev/null 2>&1
    show_result $?

    show_message "\tEnabling httpd..."
    systemctl enable httpd.service > /dev/null 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing httpd..."
    yum install --assumeyes httpd mod_ssl > /dev/null 2>&1
    show_result $?
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

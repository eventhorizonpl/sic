#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring httpd..."

    show_message "\tCreating /home/data..."
    mkdir -p /home/data >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging context /home/data/..."
    semanage fcontext -a -t var_t '/home/data(/.*)?' >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestoring context /home/data/..."
    restorecon -R -v /home/data >> /tmp/install.log 2>&1
    show_result $?

    if [ -e /home/data/www ]
    then
	show_message "\tRemoving /home/data/www..."
	rm -rf /home/data/www/ >> /tmp/install.log 2>&1
	show_result $?
    fi

    show_message "\tCreating /home/data/www..."
    cp -R /var/www/ /home/data/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging context /home/data/www..."
    semanage fcontext -a -t httpd_sys_content_t '/home/data/www(/.*)?' >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging context /home/data/www/cgi-bin..."
    semanage fcontext -a -t httpd_sys_script_exec_t '/home/data/www/cgi-bin(/.*)?' >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging context /home/data/www/html..."
    semanage fcontext -a -t httpd_sys_content_t '/home/data/www/html(/.*)?' >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestoring context /home/data/www..."
    restorecon -R -v /home/data/www >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tPathes in config file..."
    sed -i "s/\/var\/www/\/home\/data\/www/g" /etc/httpd/conf/httpd.conf >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying config file..."
    cp etc/httpd/conf.d/virtual.conf /etc/httpd/conf.d/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting httpd..."
    systemctl restart httpd.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling httpd..."
    systemctl enable httpd.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing httpd..."
    yum install --assumeyes httpd mod_ssl >> /tmp/install.log 2>&1
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

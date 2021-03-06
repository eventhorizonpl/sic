#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring elasticsearch..."

    show_message "\tInstalling mobz/elasticsearch-head..."
    /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tInstalling elasticsearch/marvel..."
    /usr/share/elasticsearch/bin/plugin -install elasticsearch/marvel/latest >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling elasticsearch in firewall..."
    firewall-cmd --permanent --zone=public --add-port=9200/tcp >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting elasticsearch..."
    systemctl restart elasticsearch.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling elasticsearch..."
    systemctl enable elasticsearch.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing elasticsearch..."
    rpm -ihv https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.0.1-x86_64.rpm >> /tmp/install.log 2>&1
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

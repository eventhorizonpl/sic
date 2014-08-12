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
    rpm -ihv https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.1.noarch.rpm >> /tmp/install.log 2>&1
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

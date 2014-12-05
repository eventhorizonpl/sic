#!/bin/sh

source ./lib

function configure_package()
{
    show_message "\tEnabling neo4j in firewall..."
    firewall-cmd --permanent --zone=public --add-port=7474/tcp >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting neo4j-service..."
    systemctl restart neo4j-service.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling neo4j-service..."
    systemctl enable neo4j-service.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Extracting neo4j..."
    tar zxvf /tmp/neo4j.tar.gz -C /tmp/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "Moving neo4j..."
    mv /tmp/neo4j-community-2.1.6/ /opt/neo4j >> /tmp/install.log 2>&1
    show_result $?

    show_message "Installing neo4j..."
    /opt/neo4j/bin/neo4j-installer install
    show_result $?
}

function download_package()
{
    show_message "Downloading neo4j..."
    wget -O /tmp/neo4j.tar.gz http://dist.neo4j.org/neo4j-community-2.1.6-unix.tar.gz?_ga=1.176809132.866451536.1407967915 >> /tmp/install.log 2>&1
    show_result $?
}

while [ $# -ne 0 ]
do
    if [ $1 == "download" ]
    then
        download_package
    elif [ $1 == "install" ]
    then
        install_package
    elif [ $1 == "configure" ]
    then
        configure_package
    fi
    shift
done

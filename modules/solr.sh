#!/bin/sh

source ./lib

function configure_package()
{
    if [ $OS == "rhel" ]
    then
        show_message "\tCopying service config file..."
        cp etc/systemd/system/solr.service /etc/systemd/system/ >> /tmp/install.log 2>&1
        show_result $?

        show_message "\tCopying start file..."
        cp etc/solr-service.sh /opt/solr/example/ >> /tmp/install.log 2>&1
        show_result $?

        show_message "\tChanging start file permissions..."
        chmod 755 /opt/solr/example/solr-service.sh >> /tmp/install.log 2>&1
        show_result $?
    fi

    show_message "\tEnabling solr in firewall..."
    firewall-cmd --permanent --zone=public --add-port=8983/tcp >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?

    if [ $OS == "rhel" ]
    then
        show_message "\tRestarting solr..."
        systemctl restart solr.service >> /tmp/install.log 2>&1
        show_result $?

        show_message "\tEnabling solr..."
        systemctl enable solr.service >> /tmp/install.log 2>&1
        show_result $?
    fi
}

function install_package()
{
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes solr >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        show_message "Extracting solr..."
        tar zxvf /tmp/solr.tgz -C /tmp/ >> /tmp/install.log 2>&1
        show_result $?

        if [ -e /opt/solr/ ]
        then
            show_message "\tRemoving /opt/solr..."
            rm -rf /opt/solr/ >> /tmp/install.log 2>&1
            show_result $?
        fi

        show_message "Moving solr..."
        mv /tmp/solr-4.10.2/ /opt/solr >> /tmp/install.log 2>&1
        show_result $?
    fi
}

function download_package()
{
    show_message "Downloading solr..."
    wget -O /tmp/solr.tgz http://ftp.ps.pl/pub/apache/lucene/solr/4.10.2/solr-4.10.2.tgz >> /tmp/install.log 2>&1
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

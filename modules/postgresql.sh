#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring postgresql..."

    show_message "\tCreating database..."
    postgresql-setup initdb >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling postgresql in firewall..."
    firewall-cmd --permanent --zone=public --add-service=postgresql >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting postgresql..."
    systemctl restart postgresql.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling postgresql..."
    systemctl enable postgresql.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating user..."
    su postgres -c "createuser -d -r -s admin" >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tAltering user..."
    cp etc/postgresql.sql /tmp
    su postgres -c "psql < /tmp/postgresql.sql" >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying pg_hba config file..."
    cp etc/pg_hba.conf /home/data/pgsql/data >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting postgresql..."
    systemctl restart postgresql.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing postgresql..."
    if [ $OS == "fedora" ]
    then
        dnf install --assumeyes postgresql postgresql-devel postgresql-libs postgresql-server postgresql-upgrade >> /tmp/install.log 2>&1
        show_result $?
    elif [ $OS == "rhel" ]
    then
        yum install --assumeyes postgresql postgresql-devel postgresql-libs postgresql-server postgresql-upgrade >> /tmp/install.log 2>&1
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

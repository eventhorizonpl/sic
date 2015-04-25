#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring postgresql..."

    show_message "\tStopping postgresql..."
    systemctl stop postgresql.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating /home/data..."
    mkdir -p /home/data >> /tmp/install.log 2>&1
    show_result $?

    if [ -e /home/data/pgsql/ ]
    then
        show_message "\tRemoving /home/data/pgsql..."
        rm -rf /home/data/pgsql/ >> /tmp/install.log 2>&1
        show_result $?
    fi

    show_message "\tCreating /home/data/pgsql..."
    cp -R /var/lib/pgsql/ /home/data/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging ownership /home/data/pgsql..."
    chown -R postgres:postgres /home/data/pgsql/ >> /tmp/install.log 2>&1
    show_result $?

#semanage port -a -t postgresql_port_t -p tcp 5433

    show_message "\tChanging context /home/data/pgsql/data/..."
    semanage fcontext -a -t postgresql_db_t "/home/data/pgsql/data(/.*)?" >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestoring context /home/data/pgsql/data/..."
    restorecon -R /home/data/pgsql/data >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying service config file..."
    cp etc/systemd/system/postgresql.service /etc/systemd/system/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tReloading systemd..."
    systemctl --system daemon-reload >> /tmp/install.log 2>&1
    show_result $?

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

#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring postgresql94..."

    show_message "\tStopping postgresql94..."
    systemctl stop postgresql-9.4.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating /home/data..."
    mkdir -p /home/data >> /tmp/install.log 2>&1
    show_result $?

#    show_message "\tChanging context /home/data/..."
#    semanage fcontext -a -t var_t '/home/data' >> /tmp/install.log 2>&1
#    show_result $?

#    show_message "\tRestoring context /home/data/..."
#    restorecon -R -v /home/data >> /tmp/install.log 2>&1
#    show_result $?

    if [ -e /home/data/pgsql94/ ]
    then
        show_message "\tRemoving /home/data/pgsql94..."
        rm -rf /home/data/pgsql94/ >> /tmp/install.log 2>&1
        show_result $?
    fi

    show_message "\tCreating /home/data/pgsql94..."
#    cp -R /var/lib/pgsql/9.4/ /home/data/pgsql94 >> /tmp/install.log 2>&1
    mkdir -p /home/data/pgsql94 >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging ownership /home/data/pgsql94..."
    chown -R postgres:postgres /home/data/pgsql94/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying service config file..."
    cp etc/systemd/system/postgresql-9.4.service /etc/systemd/system/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tReloading systemd..."
    systemctl --system daemon-reload >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating database..."
    /usr/pgsql-9.4/bin/postgresql94-setup initdb >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling postgresql in firewall..."
    firewall-cmd --permanent --zone=public --add-service=postgresql >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting firewalld..."
    systemctl restart firewalld.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting postgresql..."
    systemctl restart postgresql-9.4.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling postgresql..."
    systemctl enable postgresql-9.4.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating user..."
    su postgres -c "/usr/pgsql-9.4/bin/createuser --port=5432 -d -r -s admin" >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tAltering user..."
    cp etc/postgresql.sql /tmp
    su postgres -c "/usr/pgsql-9.4/bin/psql --port=5432 < /tmp/postgresql.sql" >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying pg_hba config file..."
    cp etc/pg_hba.conf /home/data/pgsql94/data >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting postgresql..."
    systemctl restart postgresql-9.4.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing PGDG94 release package..."
    rpm -ihv http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm >> /tmp/install.log 2>&1
    show_result $?

    show_message "Installing postgresql94..."
    yum install --assumeyes postgresql94 postgresql94-devel postgresql94-libs postgresql94-server >> /tmp/install.log 2>&1
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

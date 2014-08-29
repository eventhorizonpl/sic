#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring postgresql93..."

    show_message "\tStopping postgresql93..."
    systemctl stop postgresql-9.3.service >> /tmp/install.log 2>&1
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

    if [ -e /home/data/pgsql93/ ]
    then
        show_message "\tRemoving /home/data/pgsql93..."
        rm -rf /home/data/pgsql93/ >> /tmp/install.log 2>&1
        show_result $?
    fi

    show_message "\tCreating /home/data/pgsql93..."
    cp -R /var/lib/pgsql/9.3/ /home/data/pgsql93 >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tChanging ownership /home/data/pgsql93..."
    chown -R postgres:postgres /home/data/pgsql93/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying service config file..."
    cp etc/systemd/system/postgresql-9.3.service /etc/systemd/system/ >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tReloading systemd..."
    systemctl --system daemon-reload >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating database..."
    /usr/pgsql-9.3/bin/postgresql93-setup initdb >> /tmp/install.log 2>&1
    show_result $?

#    show_message "\tEnabling postgresql in firewall..."
#    firewall-cmd --permanent --zone=public --add-port=5433 >> /tmp/install.log 2>&1
#    show_result $?

#    show_message "\tRestarting firewalld..."
#    systemctl restart firewalld.service >> /tmp/install.log 2>&1
#    show_result $?

    show_message "\tChanging port..."
    sed -i "s/#port = 5432/port = 5433/g" /home/data/pgsql93/data/postgresql.conf >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting postgresql..."
    systemctl restart postgresql-9.3.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tEnabling postgresql..."
    systemctl enable postgresql-9.3.service >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCreating user..."
    su postgres -c "/usr/pgsql-9.3/bin/createuser --port=5433 -d -r -s admin" >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tAltering user..."
    cp etc/postgresql.sql /tmp
    su postgres -c "/usr/pgsql-9.3/bin/psql --port=5433 < /tmp/postgresql.sql" >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tCopying pg_hba config file..."
    cp etc/pg_hba.conf /home/data/pgsql93/data >> /tmp/install.log 2>&1
    show_result $?

    show_message "\tRestarting postgresql..."
    systemctl restart postgresql-9.3.service >> /tmp/install.log 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing PGDG93 release package..."
    rpm -ihv  http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-1.noarch.rpm >> /tmp/install.log 2>&1
    show_result $?

    show_message "Installing postgresql93..."
    yum install --assumeyes postgresql93 postgresql93-devel postgresql93-libs postgresql93-server >> /tmp/install.log 2>&1
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

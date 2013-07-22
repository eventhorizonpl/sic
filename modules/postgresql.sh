#!/bin/sh

source ./lib

function configure_package()
{
    show_message "Configuring postgresql..."

    show_message "\tStopping postgresql..."
    systemctl stop postgresql.service > /dev/null 2>&1
    show_result $?

    show_message "\tCreating /home/data..."
    mkdir -p /home/data > /dev/null 2>&1
    show_result $?

    show_message "\tChanging context /home/data/..."
    semanage fcontext -a -t var_t '/home/data' > /dev/null 2>&1
    show_result $?

    show_message "\tRestoring context /home/data/..."
    restorecon -R -v /home/data > /dev/null 2>&1
    show_result $?

    if [ -e /home/data/pgsql/ ]
    then
	show_message "\tRemoving /home/data/pgsql..."
	rm -rf /home/data/pgsql/ > /dev/null 2>&1
	show_result $?
    fi

    show_message "\tCreating /home/data/pgsql..."
    cp -R /var/lib/pgsql/ /home/data/ > /dev/null 2>&1
    show_result $?

    show_message "\tChanging ownership /home/data/pgsql..."
    chown -R postgres:postgres /home/data/pgsql/ > /dev/null 2>&1
    show_result $?

    show_message "\tCopying service config file..."
    cp etc/systemd/system/postgresql.service /etc/systemd/system/ > /dev/null 2>&1
    show_result $?

    show_message "\tCopying phpPgAdmin config file..."
    cp etc/httpd/conf.d/phpPgAdmin.conf /etc/httpd/conf.d/ > /dev/null 2>&1
    show_result $?

    show_message "\tReloading systemd..."
    systemctl --system daemon-reload > /dev/null 2>&1
    show_result $?

    show_message "\tCreating database..."
    postgresql-setup initdb > /dev/null 2>&1
    show_result $?

    show_message "\tRestarting postgresql..."
    systemctl restart postgresql.service > /dev/null 2>&1
    show_result $?

    show_message "\tEnabling postgresql..."
    systemctl enable postgresql.service > /dev/null 2>&1
    show_result $?

    show_message "\tCreating user..."
    su postgres -c "createuser -d -r -s admin" > /dev/null 2>&1
    show_result $?

    show_message "\tAltering user..."
    cp etc/postgresql.sql /tmp
    su postgres -c "psql < /tmp/postgresql.sql" > /dev/null 2>&1
    show_result $?

    show_message "\tCopying pg_hba config file..."
    cp etc/pg_hba.conf /home/data/pgsql/data > /dev/null 2>&1
    show_result $?

    show_message "\tRestarting postgresql..."
    systemctl restart postgresql.service > /dev/null 2>&1
    show_result $?
}

function install_package()
{
    show_message "Installing postgresql..."
    yum install --assumeyes postgresql postgresql-devel postgresql-libs postgresql-server postgresql-upgrade phpPgAdmin > /dev/null 2>&1
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

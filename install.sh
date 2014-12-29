#!/bin/sh

source ./lib

server_menu CONFIG

if [ $CONFIG == "CONFIG" ]
then
    exit 1
fi

source ./$CONFIG

echo > /tmp/install.log

show_message "Setting hostname..."
hostnamectl set-hostname $HOSTNAME
show_result $?

show_message "Setting hosts..."
yes | cp etc/hosts /etc/
echo "127.0.0.1 $HOSTNAME" >> /etc/hosts
show_result $?

mount -t tmpfs -o size=1024m tmpfs /var/cache/yum
mount -t tmpfs -o size=1024m tmpfs /tmp

sh modules/user.sh "configure"

show_message "\tEnabling angular in firewall..."
firewall-cmd --permanent --zone=public --add-port=8000/tcp >> /tmp/install.log 2>&1
show_result $?

show_message "\tRestarting firewalld..."
systemctl restart firewalld.service >> /tmp/install.log 2>&1
show_result $?

if [ $MODULE_DISABLE_SELINUX == "yes" ]
then
    sh modules/disable_selinux.sh "configure" "remove"
fi

if [ $MODULE_BASIC_TOOLS == "yes" ]
then
    sh modules/basic_tools.sh "install"
fi

if [ $MODULE_HTTPD == "yes" ]
then
    sh modules/httpd.sh "install" "configure"
fi

if [ $MODULE_NGINX == "yes" ]
then
    sh modules/nginx.sh "install" "configure"
fi

if [ $MODULE_MARIADB == "yes" ]
then
    sh modules/mariadb.sh "install" "configure"
fi

if [ $MODULE_MEMCACHED == "yes" ]
then
    sh modules/memcached.sh "install" "configure"
fi

if [ $MODULE_MONGODB == "yes" ]
then
    sh modules/mongodb.sh "install" "configure"
fi

if [ $MODULE_POSTFIX == "yes" ]
then
    sh modules/postfix.sh "install" "configure"
fi

if [ $MODULE_POSTGRESQL == "yes" ]
then
    sh modules/postgresql.sh "install" "configure"
fi

if [ $MODULE_POSTGRESQL94 == "yes" ]
then
    sh modules/postgresql94.sh "install" "configure"
fi

if [ $MODULE_PHP == "yes" ]
then
    sh modules/php.sh "install" "configure"
fi

if [ $MODULE_REDIS == "yes" ]
then
    sh modules/redis.sh "install" "configure"
fi

if [ $MODULE_SAMBA == "yes" ]
then
    sh modules/samba.sh "install" "configure"
fi

if [ $MODULE_VARNISH == "yes" ]
then
    sh modules/varnish.sh "install" "configure"
fi

if [ $MODULE_HHVM == "yes" ]
then
    sh modules/hhvm.sh "install"
fi

if [ $MODULE_ELASTICSEARCH == "yes" ]
then
    sh modules/elasticsearch.sh "install" "configure"
fi

if [ $MODULE_NEO4J == "yes" ]
then
    sh modules/neo4j.sh "download" "install" "configure"
fi

if [ $MODULE_SOLR == "yes" ]
then
    sh modules/solr.sh "download" "install" "configure"
fi

if [ $MODULE_DISABLE_SERVICES == "yes" ]
then
    sh modules/disable_services.sh "configure"
fi

if [ $MODULE_RESTART_SERVICES == "yes" ]
then
    sh modules/restart_services.sh "configure"
fi

echo -e "\nAll done"

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

if [ $OS == "fedora" ]
then
    mount -t tmpfs -o size=1024m tmpfs /var/cache/dnf
elif [ $OS == "rhel" ]
then
    if [ $VERSION == "7" ]
    then
        mount -t tmpfs -o size=1024m tmpfs /var/cache/yum
        mount -t tmpfs -o size=1024m tmpfs /tmp
    elif [ $VERSION == "8" ]
    then
        mount -t tmpfs -o size=1024m tmpfs /var/cache/dnf
    fi
fi

if [ $OS == "fedora" ]
then
    dnf upgrade --assumeyes >> /tmp/install.log 2>&1
elif [ $OS == "rhel" ]
then
    if [ $VERSION == "7" ]
    then
        yum upgrade --assumeyes >> /tmp/install.log 2>&1
    elif [ $VERSION == "8" ]
    then
        dnf upgrade --assumeyes >> /tmp/install.log 2>&1
    fi
fi

sh modules/user.sh ./$CONFIG "configure"

if [ $MODULE_BASIC_TOOLS == "yes" ]
then
    sh modules/basic_tools.sh ./$CONFIG "install"
fi

if [ $MODULE_GOLANG == "yes" ]
then
    sh modules/golang.sh "install" "configure"
fi

if [ $MODULE_HTTPD == "yes" ]
then
    sh modules/httpd.sh "install" "configure"
fi

if [ $MODULE_NGINX == "yes" ]
then
    sh modules/nginx.sh "install" "configure"
fi

if [ $MODULE_NODEJS == "yes" ]
then
    sh modules/nodejs.sh "install" "configure"
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
    sh modules/samba.sh ./$CONFIG "install" "configure"
fi

if [ $MODULE_VARNISH == "yes" ]
then
    sh modules/varnish.sh "install" "configure"
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
    if [ $OS == "fedora" ]
    then
        sh modules/solr.sh "install" "configure"
    elif [ $OS == "rhel" ]
    then
        if [ $VERSION == "7" ]
        then
            sh modules/solr.sh "download" "install" "configure"
        fi
    fi
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

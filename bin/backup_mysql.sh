#!/bin/sh

sudo mkdir -p /home/data/backup/mysql
sudo chown -R michal:michal /home/data/backup/mysql
cd /home/data/backup/mysql

DBS="$(mysql --user=admin --password=admin -Bse 'show databases')"

for db in ${DBS[@]}
do
    echo ${db}-$(date +%m-%d-%y).sql.bz2 is being saved in /backup/mysql
    mysqldump --user=admin --password=admin $db --single-transaction -R | bzip2 -c > ${db}-$(date +%m-%d-%y).sql.bz2
done

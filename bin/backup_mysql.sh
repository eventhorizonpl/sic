#!/bin/sh

BACKUP_DIR=/home/data/backup/mysql

sudo mkdir -p $BACKUP_DIR
sudo chown -R michal:michal $BACKUP_DIR
cd $BACKUP_DIR

DBS="$(mysql --user=admin --password=admin -Bse 'show databases')"

for db in ${DBS[@]}
do
    echo ${db}-$(date +%m-%d-%y).sql.bz2 is being saved in $BACKUP_DIR
    mysqldump --user=admin --password=admin $db --single-transaction -R | bzip2 -c > ${db}-$(date +%m-%d-%y).sql.bz2
done

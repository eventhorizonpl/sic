#!/bin/sh

BACKUP_DIR=/home/data/backup/pgsql

sudo mkdir -p $BACKUP_DIR
sudo chown -R michal:michal $BACKUP_DIR
cd $BACKUP_DIR

DBS="$(psql -U admin -l | awk '{ print $1}' | grep -vE '^-|^List|^Name|^Nazwa|template[0|1]|^\||^\(')"

for db in ${DBS[@]}
do
    echo ${db}-$(date +%m-%d-%y).sql.bz2 is being saved in $BACKUP_DIR
    pg_dump -U admin $db | bzip2 -c > ${db}-$(date +%m-%d-%y).sql.bz2
done

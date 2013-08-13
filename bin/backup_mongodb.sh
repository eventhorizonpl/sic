#!/bin/sh

BACKUP_DIR=/home/data/backup/mongodb

sudo mkdir -p $BACKUP_DIR
sudo chown -R michal:michal $BACKUP_DIR
cd $BACKUP_DIR

#DBS="$(mongo --eval 'db.getCollectionNames()' | awk '{ print $1}' | grep -vE '^-|^Mongo|^connecting' | tr ',' '\n')"

mongodump

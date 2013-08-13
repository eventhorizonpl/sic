#!/bin/sh

BACKUP_DIR=/home/data/backup/

sudo mkdir -p $BACKUP_DIR
sudo chown -R michal:michal $BACKUP_DIR
cd $BACKUP_DIR

sudo tar cvf etc.tar /etc/
bzip2 etc.tar

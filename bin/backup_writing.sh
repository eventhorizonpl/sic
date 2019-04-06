#!/bin/sh

PROJECT=writing
PROJECT_DIR=/home/michal/projects/$PROJECT

if [ ! -d $PROJECT_DIR ] || [ "$PROJECT" == "project" ]
then
    echo Zły projekt
    exit 1
fi

DATE=`date +%y-%m-%d-%H-%M`
BACKUP_TAR=/home/michal/backup/backup_$PROJECT\_$DATE.tar

cd $PROJECT_DIR

tar -cvf $BACKUP_TAR $PROJECT_DIR
bzip2 -9 $BACKUP_TAR
sha512sum $BACKUP_TAR.bz2 > $BACKUP_TAR.bz2.sha512sum
#pxz -vf -9 -T8 $BACKUP_TAR

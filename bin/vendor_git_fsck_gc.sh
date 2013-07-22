#!/bin/sh

ROOT_DIR=`pwd`

for DIR in `find vendor/ -type d -name '.git' -print`
do
    DIR=`echo $DIR | cut -d "." -f 1`
    echo -e "\ndir $DIR"
    cd $DIR
    git fsck --full
    git gc
    cd $ROOT_DIR
done

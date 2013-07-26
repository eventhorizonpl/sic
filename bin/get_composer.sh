#!/bin/sh

BIN_DIR="$HOME/bin"
PROJECT_DIR=`pwd`

if [ ! -d $BIN_DIR ]
then
  mkdir $BIN_DIR
fi

cd $BIN_DIR
curl -s http://getcomposer.org/installer | php
cd $PROJECT_DIR

#!/bin/sh

BIN_DIR="$HOME/bin"

if [ ! -d $BIN_DIR ]
then
  mkdir $BIN_DIR
fi

curl http://cs.sensiolabs.org/get/php-cs-fixer.phar -o $BIN_DIR/php-cs-fixer.phar
chmod 755 $BIN_DIR/php-cs-fixer.phar

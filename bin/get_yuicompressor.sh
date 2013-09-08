#!/bin/sh

BIN_DIR="$HOME/bin"

if [ ! -d $BIN_DIR ]
then
  mkdir $BIN_DIR
fi

wget https://github.com/downloads/yui/yuicompressor/yuicompressor-2.4.7.zip
unzip -o yuicompressor-2.4.7.zip -d $HOME/bin
cp $HOME/bin/yuicompressor-2.4.7/build/yuicompressor-2.4.7.jar $HOME/bin/yuicompressor.jar

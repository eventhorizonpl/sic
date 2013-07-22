#!/bin/sh

ROOT=~/projekty/cppcms/cppcms

#cd $ROOT/framework/trunk
cd $ROOT/framework/tags/v1.0.4
pwd
tar -xjf cppcms_boost.tar.bz2
if [ ! -e build ]
then
    mkdir build
fi
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
make test
echo "Deleting old files"
sudo rm -rf /usr/bin/cppcms* /usr/include/booster/ /usr/include/cppcms/ /usr/lib/libcppcms* /usr/lib/libbooster*
sudo make install

cd $ROOT/cppdb/trunk
if [ ! -e build ]
then
    mkdir build
fi
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
echo "Deleting old files"
sudo rm -rf /usr/include/cppdb/ /usr/lib/libcppdb*
sudo make install

sudo ldconfig

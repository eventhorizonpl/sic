#!/bin/sh

ROOT=~/projects/cppcms/cppcms-skeleton

cd $ROOT
pwd
if [ ! -e build ]
then
    mkdir build
#else
#    rm -rf build
#    mkdir build
fi
cd build
#cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ..
cmake ..
make
echo "Deleting old files"
#sudo rm -fr /usr/bin/create_new_cppcmsskel /usr/include/cppcms_skel /usr/lib/libcppcmsskel* /usr/share/cppcmsskel
sudo rm -fr /usr/local/bin/create_new_cppcmsskel /usr/local/include/cppcms_skel /usr/local/lib/libcppcmsskel* /usr/local/share/cppcmsskel
sudo make install

sudo ldconfig

#!/bin/sh
# script that downloads and builds open-vm-tools and libdnet 
# supposed to be run in a tinycorelinux container

LIBDNET=libdnet-1.11
LIBDNET_URL=http://sourceforge.net/projects/libdnet/files/libdnet/${LIBDNET}/${LIBDNET}.tar.gz


mkdir /tmp/stage
cd /tmp/stage
wget ${LIBDNET_URL}
tar zxf ${LIBDNET}.tar.gz 
cd ${LIBDNET}
./configure --host=i486-pc-linux-gnu  && make -j $(getconf _NPROCESSORS_ONLN) && make install && make DESTDIR=/ install

rm -rf /tmp/stage
rm /tmp/build-libdnet.sh


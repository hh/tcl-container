#!/bin/sh
# script that downloads and builds open-vm-tools and libdnet 
# supposed to be run in a tinycorelinux container

LIBDNET=libdnet-1.11
LIBDNET_URL=http://sourceforge.net/projects/libdnet/files/libdnet/${LIBDNET}/${LIBDNET}.tar.gz

cd /root
wget ${LIBDNET_URL}

mkdir /tmp/stage

cd /root
tar zxf ${LIBDNET}.tar.gz 
cd ${LIBDNET}
./configure --host=i486-pc-linux-gnu && make -j $(getconf _NPROCESSORS_ONLN) && make install && make DESTDIR=/tmp/stage/libdnet install

(cd /tmp/stage/libdnet && tar zcf /build/libdnet.tgz .)

if [ -d /tarballs ]; then
		cp /build/libdnet.tgz /tarballs
fi

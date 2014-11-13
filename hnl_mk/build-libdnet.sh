#!/bin/sh

# Our defaults
[ -z "$LIBDNET" ] && LIBDNET=libdnet-1.11
[ -z "$LIBDNET_URL" ] && LIBDNET_URL=http://sourceforge.net/projects/libdnet/files/libdnet/${LIBDNET}/${LIBDNET}.tar.gz
[ -z "$MAKE_JOBS" ] && MAKE_JOBS=$(getconf _NPROCESSORS_ONLN)
mkdir /tmp/stage
cd /tmp/stage
wget ${LIBDNET_URL}
tar zxfz ${LIBDNET}.tar.gz
cd ${LIBDNET}/

#for f in /build/patches/libdnet/*.patch ; do
#patch -p0 < $f
#done

./configure --host=i486-pc-linux-gnu --prefix=/usr/local
make -j $MAKE_JOBS DESTDIR=/tmp/stage/libdnet
make DESTDIR=/tmp/stage/libdnet install
make DESTDIR=/ install

# Generating two files, the 2.0.0 release name and the new tcz
find /tmp/stage/libdnet  -type f | \
		xargs -n1 file | grep 32-bit | awk -F: '{print $1}' | xargs strip

mkdir -p /tmp/stage/libdnet-dev/usr/local/lib
mv /tmp/stage/libdnet/usr/local/include /tmp/stage/libdnet-dev/usr/local
mv /tmp/stage/libdnet/usr/local/lib/*a /tmp/stage/libdnet-dev/usr/local/lib
mv /tmp/stage/libdnet/usr/local/lib/*la /tmp/stage/libdnet-dev/usr/local/lib

mkdir -p /tmp/stage/libdnet-doc/usr/local
mv /tmp/stage/libdnet/usr/local/man /tmp/stage/libdnet-doc/usr/local

(cd /tmp/stage && mksquashfs libdnet /build/$LIBDNET.tcz)
(cd /tmp/stage && mksquashfs libdnet-dev /build/$LIBDNET-dev.tcz)
(cd /tmp/stage && mksquashfs libdnet-doc /build/$LIBDNET-doc.tcz)

if [ -d /output ]; then
		cp /build/$LIBDNET.tcz /output
		cp /build/$LIBDNET-dev.tcz /output
		cp /build/$LIBDNET-doc.tcz /output
fi


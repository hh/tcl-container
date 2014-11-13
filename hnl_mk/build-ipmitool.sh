#!/bin/sh
# script that downloads and builds open-vm-tools
# supposed to be run in a tinycorelinux container

# Our defaults
[ -z "$IPMITOOL_VER" ] && IPMITOOL_VER=1.8.14
[ -z "$IPMITOOL" ] && IPMITOOL=ipmitool-$IPMITOOL_VER
[ -z "$IPMITOOL_URL" ] && IPMITOOL_URL=http://iweb.dl.sourceforge.net/project/ipmitool/ipmitool/$IPMITOOL_VER/$IPMITOOL.tar.gz
[ -z "$MAKE_JOBS" ] && MAKE_JOBS:=$(getconf _NPROCESSORS_ONLN)

mkdir /tmp/stage
cd /tmp/stage
echo wget ${IPMITOOL_URL}
wget ${IPMITOOL_URL}
tar zxfz ${IPMITOOL}.tar.gz
cd ${IPMITOOL}/

#for f in /build/patches/openipmi/*.patch ; do
#patch -p0 < $f
#done

./configure --prefix=/usr/local
make -j $MAKE_JOBS DESTDIR=/tmp/stage/ipmitool
make DESTDIR=/tmp/stage/ipmitool install

# Generating two files, the 2.0.0 release name and the new tcz
find /tmp/stage/ipmitool  -type f | \
		xargs -n1 file | grep 32-bit | awk -F: '{print $1}' | xargs strip

mkdir -p /tmp/stage/ipmitool-doc/usr/local/share
mv /tmp/stage/ipmitool/usr/local/share/man /tmp/stage/ipmitool-doc/usr/local/share
mv /tmp/stage/ipmitool/usr/local/share/doc /tmp/stage/ipmitool-doc/usr/local/share

(cd /tmp/stage && mksquashfs ipmitool /build/$IPMITOOL.tcz)
(cd /tmp/stage && mksquashfs ipmitool-doc /build/$IPMITOOL-doc.tcz)

if [ -d /output ]; then
		cp /build/$IPMITOOL.tcz /output
		cp /build/$IPMITOOL-doc.tcz /output
fi

#!/bin/sh
# script that downloads and builds open-vm-tools
# supposed to be run in a tinycorelinux container

# Our defaults
[ -z "$OPEN_IPMI" ] && OPEN_IPMI=OpenIPMI-2.0.21
[ -z "$OPEN_IPMI_URL" ] && OPEN_IPMI_URL=http://iweb.dl.sourceforge.net/project/openipmi/OpenIPMI%202.0%20Library/$OPEN_IPMI.tar.gz
[ -z "$MAKE_JOBS" ] && MAKE_JOBS:=$(getconf _NPROCESSORS_ONLN)
set
mkdir /tmp/stage
cd /tmp/stage
wget ${OPEN_IPMI_URL}
tar zxfz ${OPEN_IPMI}.tar.gz
cd ${OPEN_IPMI}/

#for f in /build/patches/openipmi/*.patch ; do
#patch -p0 < $f
#done


LDFLAGS=-ltinfo ./configure --prefix=/usr/local
make -j $MAKE_JOBS DESTDIR=/tmp/stage/openipmi
make DESTDIR=/tmp/stage/openipmi install

# Generating two files, the 2.0.0 release name and the new tcz
find /tmp/stage/openipmi  -type f | \
		xargs -n1 file | grep 32-bit | awk -F: '{print $1}' | xargs strip

mkdir -p /tmp/stage/openipmi-dev/usr/local/lib
mv /tmp/stage/openipmi/usr/local/include /tmp/stage/openipmi-dev/usr/local
mv /tmp/stage/openipmi/usr/local/lib/*a /tmp/stage/openipmi-dev/usr/local/lib
mv /tmp/stage/openipmi/usr/local/lib/pkgconfig /tmp/stage/openipmi-dev/usr/local/lib

mkdir -p /tmp/stage/openipmi-doc/usr/local/share
mv /tmp/stage/openipmi/usr/local/share/man /tmp/stage/openipmi-doc/usr/local/share

(cd /tmp/stage && mksquashfs openipmi /build/$OPEN_IPMI.tcz)
(cd /tmp/stage && mksquashfs openipmi-dev /build/$OPEN_IPMI-dev.tcz)
(cd /tmp/stage && mksquashfs openipmi-doc /build/$OPEN_IPMI-doc.tcz)

if [ -d /output ]; then
		cp /build/$OPEN_IPMI.tcz /output
		cp /build/$OPEN_IPMI-dev.tcz /output
		cp /build/$OPEN_IPMI-doc.tcz /output
fi

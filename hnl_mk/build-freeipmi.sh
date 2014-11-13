#!/bin/sh
# script that downloads and builds open-vm-tools
# supposed to be run in a tinycorelinux container
# Our defaults
[ -z "$FREE_IPMI" ] && FREE_IPMI=freeipmi-1.4.6
[ -z "$FREE_IPMI_URL" ] && FREE_IPMI_URL=http://ftp.gnu.org/gnu/freeipmi/$FREE_IPMI.tar.gz
[ -z "$MAKE_JOBS" ] && MAKE_JOBS=$(getconf _NPROCESSORS_ONLN)
mkdir /tmp/stage
cd /tmp/stage
wget ${FREE_IPMI_URL}
tar zxfz ${FREE_IPMI}.tar.gz
cd ${FREE_IPMI}/

#for f in /build/patches/freeipmi/*.patch ; do
#patch -p0 < $f
#done

./configure --prefix=/usr/local
make -j $MAKE_JOBS DESTDIR=/tmp/stage/freeipmi
make DESTDIR=/tmp/stage/freeipmi install

# Generating two files, the 2.0.0 release name and the new tcz
find /tmp/stage/freeipmi  -type f | \
		xargs -n1 file | grep 32-bit | awk -F: '{print $1}' | xargs strip

mkdir -p /tmp/stage/freeipmi-dev/usr/local/lib
mv /tmp/stage/freeipmi/usr/local/include /tmp/stage/freeipmi-dev/usr/local
mv /tmp/stage/freeipmi/usr/local/lib/*a /tmp/stage/freeipmi-dev/usr/local/lib
mv /tmp/stage/freeipmi/usr/local/lib/pkgconfig /tmp/stage/freeipmi-dev/usr/local/lib

mkdir -p /tmp/stage/freeipmi-doc/usr/local
mv /tmp/stage/freeipmi/usr/local/share /tmp/stage/freeipmi-doc/usr/local

(cd /tmp/stage && mksquashfs freeipmi /build/$FREE_IPMI.tcz)
(cd /tmp/stage && mksquashfs freeipmi-dev /build/$FREE_IPMI-dev.tcz)
(cd /tmp/stage && mksquashfs freeipmi-doc /build/$FREE_IPMI-doc.tcz)

if [ -d /output ]; then
		cp /build/$FREE_IPMI.tcz /output
		cp /build/$FREE_IPMI-dev.tcz /output
		cp /build/$FREE_IPMI-doc.tcz /output
fi

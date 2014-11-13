#!/bin/sh
# script that downloads and builds open-vm-tools
# supposed to be run in a tinycorelinux container

[ -z "$BUSYBOX" ] && BUSYBOX=busybox-1.22.1
[ -z "$BUSYBOX_URL" ] && BUSYBOX_URL=http://www.busybox.net/downloads/$BUSYBOX.tar.bz2
[ -z "$MAKE_JOBS" ] && MAKE_JOBS=$(getconf _NPROCESSORS_ONLN)

mkdir /tmp/stage
cd /tmp/stage
wget ${BUSYBOX_URL}
tar zxfj ${BUSYBOX}.tar.bz2
cd ${BUSYBOX}/

for f in /build/patches/busybox/*.patch ; do
   patch -p0 < $f
done


make -j $MAKE_JOBS defconfig

# due to https://bugs.busybox.net/show_bug.cgi?id=4562#c4
# this makes nfs mounts less featurefull and of course inetd is no longer
# but it get's us to the point where we can use the current glibc
sed -i s/CONFIG_INETD=y/CONFIG_INETD=n/ .config

make -j $MAKE_JOBS CONFIG_PREFIX=/tmp/stage/busybox
make CONFIG_PREFIX=/tmp/stage/busybox install

find /tmp/stage/busybox  -type f | \
		xargs -n1 file | grep 32-bit | awk -F: '{print $1}' | xargs strip

# Generating two files, the 2.0.0 release name and the new tcz
(cd /tmp/stage/busybox && tar zcf /build/mk-custom-busybox.tar.gz .)
(cd /tmp/stage && mksquashfs busybox /build/$BUSYBOX.tcz)

if [ -d /output ]; then
		cp /build/mk-custom-busybox.tar.gz /output
		cp /build/$BUSYBOX.tcz /output
fi

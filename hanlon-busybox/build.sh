#!/bin/sh
# script that downloads and builds open-vm-tools
# supposed to be run in a tinycorelinux container

BB=busybox-1.22.1
BB_URL=http://www.busybox.net/downloads/$BB.tar.bz2

mkdir /tmp/stage
cd /tmp/stage
wget ${BB_URL}
tar zxfj ${BB}.tar.bz2
cd ${BB}/

for f in /build/patches/busybox/*.patch ; do
   patch -p0 < $f
done

# we need to set --host because boot2docker is 32 bit, and this will not be
# detected correctly in a container running in a 64bit host
make -j $(getconf _NPROCESSORS_ONLN) defconfig
# due to https://bugs.busybox.net/show_bug.cgi?id=4562#c4
# this makes nfs mounts less featurefull and of course inetd is no longer
# but it get's us to the point where we can use the current glibc
sed -i s/CONFIG_INETD=y/CONFIG_INETD=n/ .config
make -j $(getconf _NPROCESSORS_ONLN) CONFIG_PREFIX=/tmp/stage/busybox install
(cd /tmp/stage/busybox && tar zcf /build/busybox.tgz .)

if [ -d /tarballs ]; then
		cp /build/busybox.tgz /tarballs
fi

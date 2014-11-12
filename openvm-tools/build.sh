#!/bin/sh
# script that downloads and builds open-vm-tools
# supposed to be run in a tinycorelinux container

OVT=open-vm-tools-9.4.0-1280544
OVT_URL=http://sourceforge.net/projects/open-vm-tools/files/open-vm-tools/stable-9.4.x/${OVT}.tar.gz

cd /root
wget ${OVT_URL}

mkdir /tmp/stage

cd /root
tar zxf ${OVT}.tar.gz 
cd ${OVT}/

for f in /build/patches/ovt/*.patch ; do
   patch -p0 < $f
done

# we need to set --host because boot2docker is 32 bit, and this will not be
# detected correctly in a container running in a 64bit host
./configure --without-kernel-modules --without-pam --without-x --without-icu --host=i486-pc-linux-gnu && \
  make -j $(getconf _NPROCESSORS_ONLN) LIBS="-ltirpc" CFLAGS='-Wno-deprecated-declarations' && \
  make DESTDIR=/tmp/stage/open-vm-tools install

(cd /tmp/stage/open-vm-tools && tar zcf /build/open-vm-tools.tgz .)


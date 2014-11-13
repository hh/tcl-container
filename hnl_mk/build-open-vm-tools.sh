#!/bin/sh
# script that downloads and builds open-vm-tools
# supposed to be run in a tinycorelinux container

# Our defaults
[ -z "$OPEN_VM_TOOL_STAMP" ] && OPEN_VM_TOOL_STAMP=1280544
[ -z "$OPEN_VM_TOOL_VER" ] && OPEN_VM_TOOL_VER=9.4.0
[ -z "$OPEN_VM_TOOL" ] && OPEN_VM_TOOL=open-vm-tools-$OPEN_VM_TOOL_VER-$OPEN_VM_TOOL_STAMP
[ -z "$OPEN_VM_TOOL_URL" ] && OPEN_VM_TOOL_URL=http://sourceforge.net/projects/open-vm-tools/files/open-vm-tools/stable-9.4.x/$OPEN_VM_TOOL.tar.gz
[ -z "$MAKE_JOBS" ] && MAKE_JOBS=$(getconf _NPROCESSORS_ONLN)

mkdir /tmp/stage
cd /tmp/stage
echo wget ${OPEN_VM_TOOL_URL}
wget ${OPEN_VM_TOOL_URL}
tar zxfz ${OPEN_VM_TOOL}.tar.gz
cd ${OPEN_VM_TOOL}/

# I'm pretty sure our rpc implentation is lacking
# so the patches look to be to comment it out for now
# if open-vm-tools ever get's ported to libtiprc, we have that:
# libtirpc-dev.tcz / libtirpc.tcz
# http://sourceforge.net/p/open-vm-tools/tracker/128/
# http://sourceforge.net/p/open-vm-tools/tracker/129/
for f in /build/patches/ovt/*.patch ; do
   patch -p0 < $f
done

# we need to set --host because boot2docker is 32 bit, and this will not be
# detected correctly in a container running in a 64bit host
./configure --without-kernel-modules --without-pam --without-x --without-icu --host=i486-pc-linux-gnu  --prefix=/usr/local && \
		make -j $(getconf _NPROCESSORS_ONLN) LIBS="-ltirpc" CFLAGS='-Wno-deprecated-declarations' DESTDIR=/tmp/stage/open_vm_tools && \
		make install
make DESTDIR=/tmp/stage/open_vm_tools install

# Generating two files, the 2.0.0 release name and the new tcz
find /tmp/stage/open_vm_tools  -type f | \
		xargs -n1 file | grep 32-bit | awk -F: '{print $1}' | xargs strip

mkdir -p /tmp/stage/open_vm_tools-dev/usr/local/lib/open-vm-tools/plugins/common/
mv /tmp/stage/open_vm_tools/usr/local/include /tmp/stage/open_vm_tools-dev/usr/local/
mv /tmp/stage/open_vm_tools/usr/local/lib/*a /tmp/stage/open_vm_tools-dev/usr/local/lib
mv /tmp/stage/open_vm_tools/usr/local/lib/open-vm-tools/plugins/common/*a /tmp/stage/open_vm_tools-dev/usr/local/lib/open-vm-tools/plugins/common
mv /tmp/stage/open_vm_tools/usr/local/lib/pkgconfig /tmp/stage/open_vm_tools-dev/usr/local/lib

mkdir -p /tmp/stage/open_vm_tools-locale/usr/local
mv /tmp/stage/open_vm_tools/usr/local/share /tmp/stage/open_vm_tools-locale/usr/local

(cd /tmp/stage && mksquashfs open_vm_tools /build/$OPEN_VM_TOOL.tcz)
(cd /tmp/stage && mksquashfs open_vm_tools-locale /build/$OPEN_VM_TOOL-locale.tcz)
(cd /tmp/stage && mksquashfs open_vm_tools-dev /build/$OPEN_VM_TOOL-dev.tcz)

if [ -d /output ]; then
		cp /build/$OPEN_VM_TOOL.tcz /output
		cp /build/$OPEN_VM_TOOL-dev.tcz /output
		cp /build/$OPEN_VM_TOOL-locale.tcz /output
fi



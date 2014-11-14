#!/bin/sh
# script that downloads and builds open-vm-tools
# supposed to be run in a tinycorelinux container


https://download3.vmware.com/software/player/file/VMware-Player-6.0.4-2249910.i386.bundle
# Our defaults
[ -z "$OPEN_VM_MODULES_STAMP" ] && OPEN_VM_MODULES_STAMP=2249910
[ -z "$OPEN_VM_MODULES_VER" ] && OPEN_VM_MODULES_VER=6.0.4
[ -z "$OPEN_VM_MODULES" ] && OPEN_VM_MODULES=VMware-Player-$OPEN_VM_MODULES_VER-$OPEN_VM_MODULES_STAMP
[ -z "$OPEN_VM_MODULES_URL" ] && OPEN_VM_MODULES_URL=http://download3.vmware.com/software/player/file/$OPEN_VM_MODULES.i386.bundle
# [ -z "$MAKE_JOBS" ] && MAKE_JOBS=$(getconf _NPROCESSORS_ONLN)

mkdir /tmp/stage
cd /tmp/stage
echo wget ${OPEN_VM_MODULES_URL}
wget ${OPEN_VM_MODULES_URL}

bash VMware-Player-6.0.4-2249910.i386.bundle --console --eulas-agreed --ignore-errors --required

# I tried many variations of this to get the right headers and cross-compile under docker
# vmware-modconfig --console --install-all -k 3.8.13-tinycore 

vmware-modconfig --build-mod -k 3.8.13-tinycore vmci /usr/local/bin/gcc /usr/src/linux/include kernel/drivers/misc vmci
# is vmxnet different than vmnet?
vmware-modconfig --build-mod -k 3.8.13-tinycore vmnet /usr/local/bin/gcc /usr/src/linux/include kernel/drivers/net vmnet
vmware-modconfig --build-mod -k 3.8.13-tinycore vmblock /usr/local/bin/gcc /usr/src/linux/include kernel/drivers/fs/vmblock vmblock
# are we missing vmhgfs?
vmware-modconfig --build-mod -k 3.8.13-tinycore vsock /usr/local/bin/gcc /usr/src/linux/include kernel/drivers/net/vsock vsock
vmware-modconfig --build-mod -k 3.8.13-tinycore vmmon /usr/local/bin/gcc /usr/src/linux/include kernel/drivers/misc vmmon


PKG_ROOT=/tmp/stage/open-vm-tools-modules
MOD_ROOT=$PKG_ROOT/usr/local/lib/modules/3.8.13-tinycore/
mkdir -p $MOD_ROOT
cp -a /lib/modules/3.8.13-tinycore/kernel $MOD_ROOT

# Generating two files, the 2.0.0 release name and the new tcz
find $PKG_ROOT  -type f | \
		xargs -n1 file | grep 32-bit | awk -F: '{print $1}' | xargs strip

(cd /tmp/stage && mksquashfs open-vm-tools-modules /build/${OPEN_VM_MODULES}.tcz)

if [ -d /output ]; then
		cp /build/${OPEN_VM_MODULES}.tcz /output
fi



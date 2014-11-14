#!/bin/sh
# script to create a container for tinycorelinux
# run with fakeroot ./import-core.sh

TCL_BASE_URL=http://tinycorelinux.net/5.x/x86/

test -f rootfs.gz || wget $TCL_BASE_URL/release/distribution_files/rootfs.gz

# tcl uses squahfs, but does not have squashfs-tools in root image
# but without squashfs-tools we cannot imstall packages in it
test -f squashfs-tools-4.x.tcz || wget $TCL_BASE_URL/tcz/squashfs-tools-4.x.tcz

mkdir rootfs
cd rootfs
zcat ../rootfs.gz | cpio -f -i -H newc -d --no-absolute-filenames
unsquashfs -n -d . -f ../squashfs-tools-4.x.tcz
mkdir -p home/tc etc/sysconfig/tcedir
chown -R 1001.50 home/tc etc/sysconfig/tcedir
patch usr/bin/tce-load ../tce-load-docker.patch
cp usr/bin/tce-load usr/bin/tce-load-docker
cd ..
tar -C rootfs -c . | docker import - vulk/tcl:core


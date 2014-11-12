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
unsquashfs -d . -f ../squashfs-tools-4.x.tcz
cd ..
tar -C rootfs -c . | docker import - vulk/tcl:core


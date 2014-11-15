tcl-container
=============

Create a tinycorelinux container to build apps for it - this fork is for hanlon

```
$ docker run -ti vulk/tcl:hnl_mk ls /build
Dockerfile             build-busybox.sh       build-ipmi-modules.sh  build-libdnet.sh       build.sh               notes.org
Readme.mkd             build-freeipmi.sh      build-ipmitool.sh      build-openipmi.sh      ipmi-kernel.config     patches

$ docker run -ti vulk/tcl:hnl_mk cat /build/build.sh
#!/bin/sh
for builder in $(ls /build/build-*sh)
do
                $builder
done

$ docker run -v $(pwd):/output vulk/tcl:hnl_mk /build/build.sh

$ ls -ltah *z
-rw-r--r-- 1 root root  48K Nov 13 22:45 ipmitool-1.8.14-doc.tcz
-rw-r--r-- 1 root root 444K Nov 13 22:45 ipmitool-1.8.14.tcz
-rw-r--r-- 1 root root  36K Nov 13 22:39 OpenIPMI-2.0.21-doc.tcz
-rw-r--r-- 1 root root 4.1M Nov 13 22:39 OpenIPMI-2.0.21-dev.tcz
-rw-r--r-- 1 root root 656K Nov 13 22:39 OpenIPMI-2.0.21.tcz
-rw-r--r-- 1 root root  96K Nov 13 22:38 libdnet-1.11-dev.tcz
-rw-r--r-- 1 root root 8.0K Nov 13 22:38 libdnet-1.11-doc.tcz
-rw-r--r-- 1 root root  32K Nov 13 22:38 libdnet-1.11.tcz
-rw-r--r-- 1 root root 2.8M Nov 13 22:37 freeipmi-1.4.6-dev.tcz
-rw-r--r-- 1 root root 476K Nov 13 22:37 freeipmi-1.4.6-doc.tcz
-rw-r--r-- 1 root root 2.1M Nov 13 22:37 freeipmi-1.4.6.tcz
-rw-r--r-- 1 root root 472K Nov 13 22:36 busybox-1.22.1.tcz
-rw-r--r-- 1 root root 467K Nov 13 22:36 mk-custom-busybox.tar.gz
```

To create a tinycorelinux docker image from scratch, call the script import-core:
```cd core ; fakeroot ./import-core.sh```

Then build a development container out of using the Dockerfile:

```
docker build -t vulk/tcl:dev dev/
docker build -t vulk/tcl:hnl_mk hnl_mk/
```

Still a bit of cleaning up, but at least we have a consistent replicable build environment. :)

I have not figured out how build the open-vm-tools-modules, be2net, or ipmi-kernel-mods yet.
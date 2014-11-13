tcl-container
=============

Create a tinycorelinux container to build apps for it - this fork is for hanlon

The intended usage is pulling build layers from docker hub, and building on your local docker host (using a squid proxy somewhere):

```
$ docker run -e MAX_CACHE_OBJECT=2048 -e DISK_CACHE_SIZE=20000 --net host --priviledged jpetazzo/squid-in-a-can
$ time docker run -e http_proxy=http://MYSQUID_IP:3128 -v $(pwd):/output vulk/tcl:hnl_mk
real    3m16.364s
user    0m0.197s
sys     0m0.407s

$ ls -ltah
total 11M
drwxr-xr-x  2 hh   hh    300 Nov 13 00:55 .
-rw-r--r--  1 root root  36K Nov 13 00:55 OpenIPMI-2.0.21-doc.tcz
-rw-r--r--  1 root root 2.2M Nov 13 00:55 OpenIPMI-2.0.21-dev.tcz
-rw-r--r--  1 root root 652K Nov 13 00:55 OpenIPMI-2.0.21.tcz
-rw-r--r--  1 root root 288K Nov 13 00:54 open-vm-tools-9.4.0-1280544-dev.tcz
-rw-r--r--  1 root root  12K Nov 13 00:54 open-vm-tools-9.4.0-1280544-locale.tcz
-rw-r--r--  1 root root 368K Nov 13 00:54 open-vm-tools-9.4.0-1280544.tcz
-rw-r--r--  1 root root  48K Nov 13 00:54 ipmitool-1.8.14-doc.tcz
-rw-r--r--  1 root root 416K Nov 13 00:54 ipmitool-1.8.14.tcz
-rw-r--r--  1 root root 2.8M Nov 13 00:53 freeipmi-1.4.6-dev.tcz
-rw-r--r--  1 root root 476K Nov 13 00:53 freeipmi-1.4.6-doc.tcz
-rw-r--r--  1 root root 2.1M Nov 13 00:53 freeipmi-1.4.6.tcz
-rw-r--r--  1 root root 472K Nov 13 00:52 busybox-1.22.1.tcz
-rw-r--r--  1 root root 467K Nov 13 00:52 mk-custom-busybox.tar.gz
```

To create a tinycorelinux docker image, call the script import-core:
```fakeroot ./core/import-core.sh```

Then build a development container out of using the Dockerfile:

```
docker build -t vulk/tcl:dev dev/
docker build -t vulk/tcl:hnl_mk hnl_mk/
```

Still a bit of cleaning up, but at least we have a consistent replicable build environment. :)

I have not figured out how build the open-vm-tools-modules, be2net, or ipmi-kernel-mods yet.
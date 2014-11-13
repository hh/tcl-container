tcl-container
=============

Create a tinycorelinux container to build apps for it - this fork is for hanlon

The intended usage is pulling build layers from docker hub, and building on your local docker host (using a squid proxy somewhere):

```
$ docker run -e MAX_CACHE_OBJECT=2048 -e DISK_CACHE_SIZE=20000 --net host --priviledged jpetazzo/squid-in-a-can
$ time docker run -ti -e http_proxy=http://MYSQUID_IP:3128 -v $(pwd):/output vulk/tcl:hnl_mk
real    3m16.364s
user    0m0.197s
sys     0m0.407s
$ ls
freeipmi-1.4.6-dev.tcz  ipmitool-1.8.14-doc.tcz   OpenIPMI-2.0.21-dev.tcz  open-vm-tools-9.4.0-1280544-dev.tcz
freeipmi-1.4.6-doc.tcz  ipmitool-1.8.14.tcz       OpenIPMI-2.0.21-doc.tcz  open-vm-tools-9.4.0-1280544-locale.tcz
freeipmi-1.4.6.tcz      mk-custom-busybox.tar.gz  OpenIPMI-2.0.21.tcz      open-vm-tools-9.4.0-1280544.tcz

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
tcl-container
=============

Create a tinycorelinux container to build apps for it - useful for boot2docker and hanlon-microkernel

To create a tinycorelinux docker image, call the script import-core:
fakeroot ./core/import-core.sh

Then build a development container out of using the Dockerfile:

docker build dev
docker tag 53aYORUBILD85d vulk/tcl:dev

This can then be used to build open-vm-tools, libdnet, and busybox:

The build script will put the tarballs into the directory /build, so you
need to create a local dir and map it to the container with the -v option:

$ docker build -t vulk/tcl:build-hanlon-busybox hanlon-busybox
Sending build context to Docker daemon 1.267 MB
Sending build context to Docker daemon 
Step 0 : FROM vulk/tcl:dev
 ---> c54c81e1b8a4
Step 1 : COPY . /build
 ---> 92b7afe654f1
Removing intermediate container 5e7ea433c77f
Step 2 : CMD /bin/sh /build/build.sh
 ---> Running in bdb9c8504c66
 ---> ea3fb9219396
Removing intermediate container bdb9c8504c66
Successfully built ea3fb9219396
$ docker run -v $(pwd):/build vulk/tcl:build-hanlon-busybox

Still a bit of cleaning up, but at least we have a consistent replicable build environment. :)
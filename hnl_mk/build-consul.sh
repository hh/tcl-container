#!/bin/bash
set -x
set -e
cd /tmp
# Install go
GODIST=go1.3.3.linux-386.tar.gz
wget http://storage.googleapis.com/golang/$GODIST
tar xvfz $GODIST -C /usr/local
rm -f $GODIST
export PATH=/usr/local/go/bin:$PATH



export GOPATH=/tmp/thisbuild
export ARCH=386
export GOOS=linux
export CGO_ENABLED=1
go get -a -ldflags '-extldflags "-static" -s' github.com/hashicorp/consul
go build -ldflags '-extldflags "-static" -s' -o /output/consul github.com/hashicorp/consul

export CGO_ENABLED=0
go get -a -ldflags '-s' github.com/hashicorp/consul-template
go build -ldflags '-s' -o /output/consul-template github.com/hashicorp/consul-template
exit 0
# Compile consul static from git... ?
cd /usr/local/go/src
git clone https://github.com/hashicorp/consul.git
cd consul
git checkout -b v0.4.1-static v0.4.1
# make
#CGO_ENABLED=0 GO ARCH=386 GOOS=linux go build -a -tags netgo -ldflags "-w" -v -o /out/consul
#export GOPATH=/tmp/gopath:$(pwd)
#GOPATH=/tmp/gopath go get -u ./...
#CGO_ENABLED=0 ARCH=386 GOOS=linux go build -a -tags netgo -ldflags "-c" -v -o /tmp/consul
#/output/consul
#strip /out/consul

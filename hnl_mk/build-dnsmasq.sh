#!/bin/bash
set -x
set -e
cd /tmp
# no wget or curl... just use bash
wget http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.72.tar.gz
tar xfz dnsmasq-2.72.tar.gz
cd dnsmasq-2.72
sed -i 's/^LDFLAGS.*/LDFLAGS = -static -static-libgcc/' Makefile
make
strip src/dnsmasq
cp src/dnsmasq /output/dnsmasq

#!/bin/sh
# script that downloads and builds squid
# supposed to be run in a tinycorelinux container
# Our defaults

[ -z "$SQUID" ] && SQUID=squid-3.4.9
[ -z "$SQUID_URL" ] && SQUID_URL=http://www.squid-cache.org/Versions/v3/3.4/$SQUID.tar.gz
[ -z "$MAKE_JOBS" ] && MAKE_JOBS=$(getconf _NPROCESSORS_ONLN)
mkdir /tmp/stage
cd /tmp/stage
wget ${SQUID_URL}
tar zxfz ${SQUID}.tar.gz
cd ${SQUID}/

#for f in /build/patches/squid/*.patch ; do
#patch -p0 < $f
#done
# su -c 'tce-load -wicl openssl-1.0.0-dev' tc
# --disable-loadable-modules \
# --enable-static=yes \
# --enable-shared=no \

./configure \
--prefix=/ \
--enable-wccpv2 \
--enable-ssl \
--enable-ssl-crtd \
--enable-delay-pool \
--enable-snmp \
--enable-auth=no \
--enable-cache-digests \
--enable-kill-parent-hack \
--disable-ident-lookups \
--enable-removal-policies='lru heap' \
--enable-storagio='ufs aufs diskd' \
--enable-useragent-log \
--enable-referer-log \
--enable-linux-netfilter \
--enable-build-info="static build for ii" | tee config.out

make -j $MAKE_JOBS | tee build.out

make DESTDIR=/tmp/stage/squid install
#cd src
# I can't get the make files to build a static version
# So I just run the command at the end to link it 'correctly' for a static build
# g++ -static -Wall -Wpointer-arith -Wwrite-strings -Wcomments -Wshadow -Werror -pipe -D_REENTRANT -g -O2 -march=native -std=c++11 -g -o /output/squid AclRegs.o AuthReg.o AccessLogEntry.o AsyncEngine.o YesNoNone.o cache_cf.o CacheDigest.o cache_manager.o carp.o cbdata.o ChunkedCodingParser.o client_db.o client_side.o client_side_reply.o client_side_request.o BodyPipe.o clientStream.o CompletionDispatcher.o ConfigOption.o ConfigParser.o CpuAffinity.o CpuAffinityMap.o CpuAffinitySet.o debug.o disk.o DiskIO/DiskIOModule.o DiskIO/ReadRequest.o DiskIO/WriteRequest.o dlink.o dns_internal.o DnsLookupDetails.o errorpage.o ETag.o event.o EventLoop.o external_acl.o ExternalACLEntry.o FadingCounter.o fatal.o fd.o fde.o filemap.o fqdncache.o ftp.o FwdState.o gopher.o helper.o HelperChildConfig.o HelperReply.o htcp.o http.o HttpHdrCc.o HttpHdrRange.o HttpHdrSc.o HttpHdrScTarget.o HttpHdrContRange.o HttpHeader.o HttpHeaderTools.o HttpBody.o HttpMsg.o HttpParser.o HttpReply.o RequestFlags.o HttpRequest.o HttpRequestMethod.o icp_v2.o icp_v3.o int.o internal.o ipc.o ipcache.o SquidList.o main.o MasterXaction.o mem.o mem_node.o MemBuf.o MemObject.o mime.o mime_header.o multicast.o neighbors.o Notes.o Packer.o Parsing.o pconn.o peer_digest.o peer_proxy_negotiate_auth.o peer_select.o peer_sourcehash.o peer_userhash.o redirect.o refresh.o RemovalPolicy.o send-announce.o MemBlob.o snmp_core.o snmp_agent.o SquidMath.o SquidNew.o stat.o StatCounters.o StatHist.o String.o StrList.o stmem.o store.o StoreFileSystem.o store_io.o StoreIOState.o store_client.o store_digest.o store_dir.o store_key_md5.o store_log.o store_rebuild.o store_swapin.o store_swapmeta.o store_swapout.o StoreMeta.o StoreMetaMD5.o StoreMetaSTD.o StoreMetaSTDLFS.o StoreMetaUnpacker.o StoreMetaURL.o StoreMetaVary.o StoreStats.o StoreSwapLogData.o Server.o SwapDir.o MemStore.o time.o tools.o tunnel.o unlinkd.o url.o URLScheme.o urn.o wccp.o wccp2.o whois.o wordlist.o DiskIO/DiskIOModules_gen.o err_type.o err_detail_type.o globals.o hier_code.o icp_opcode.o LogTags.o lookup_t.o repl_modules.o swap_log_op.o DiskIO/AIO/AIODiskIOModule.o DiskIO/Blocking/BlockingDiskIOModule.o DiskIO/DiskDaemon/DiskDaemonDiskIOModule.o DiskIO/DiskThreads/DiskThreadsDiskIOModule.o DiskIO/IpcIo/IpcIoDiskIOModule.o DiskIO/Mmapped/MmappedDiskIOModule.o  ident/.libs/libident.a acl/.libs/libacls.a acl/.libs/libstate.a libAIO.a libBlocking.a libDiskDaemon.a libDiskThreads.a libIpcIo.a libMmapped.a acl/.libs/libapi.a base/.libs/libbase.a ./.libs/libsquid.a ip/.libs/libip.a fs/.libs/libfs.a ipc/.libs/libipc.a mgr/.libs/libmgr.a anyp/.libs/libanyp.a comm/.libs/libcomm.a eui/.libs/libeui.a http/.libs/libsquid-http.a icmp/.libs/libicmp.a icmp/.libs/libicmp-core.a log/.libs/liblog.a format/.libs/libformat.a repl/liblru.a repl/libheap.a -lpthread -lcrypt ssl/.libs/libsslsquid.a ssl/.libs/libsslutil.a snmp/.libs/libsnmp.a ../snmplib/.libs/libsnmplib.a ../lib/.libs/libmisccontainers.a ../lib/.libs/libmiscencoding.a ../lib/.libs/libmiscutil.a -lssl -lcrypto ../compat/.libs/libcompat-squid.a -lstdc++ -lm -lnsl -lresolv -lrt -ldl -lz -lpthread
# It'll be nice at some point to get all of squid building, but
# for now we are just going to grab the squid binary

# Stripping things down is useful
find /tmp/stage/squid  -type f | \
		xargs -n1 file | grep 32-bit | awk -F: '{print $1}' | xargs strip

# My build only include en and en-us error locales
# find /tmp/stage/squid/usr/local/squid/share/errors/*  | grep -v /en$\\\|\/en\/\\\|/en-us$\\\|\/en-us\/\\\|templates/ | xargs rm -rf

(cd /tmp/stage && mksquashfs squid /build/$SQUID.tcz)


if [ -d /output ]; then
		cp /build/$SQUID.tcz /output
fi

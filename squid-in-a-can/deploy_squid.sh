#!/bin/busybox sh
export PATH=/libexec:$PATH
export LD_LIBRARY_PATH=/usr/local/lib

[ -n "$DISK_CACHE_SIZE" ] || DISK_CACHE_SIZE=5000
[ -n "$MAXIMUM_CACHE_OBJECT" ] || MAXIMUM_CACHE_OBJECT=1024
[ -n "$CA_SUBJ" ] || CA_SUBJ="/C=US/ST=Oregon/L=Portland/O=Instant Infrastructure/OU=Internet Speedups/CN=squid.intercept"

echo "Setting DISK_CACHE_SIZE $DISK_CACHE_SIZE"
echo cache_dir ufs /var/cache/squid $DISK_CACHE_SIZE 16 256\
		 >> /usr/local/squid/etc/squid.conf

echo "Setting MAXIMUM_CACHE_OBJECT $MAXIMUM_CACHE_OBJECT"
echo maximum_object_size $MAXIMUM_CACHE_OBJECT\
		 >> /usr/local/squid/etc/squid.conf

[ -f /usr/loal/ssl/squid.key ] || openssl req -x509 -newkey rsa:1024 -keyout /usr/local/ssl/squid.key -out /usr/local/ssl/squid.crt -days 3650 -nodes -subj "$CA_SUBJ"

mkdir -p /var/cache/squid /var/logs /var/log/squid
chown -R nobody:nogroup /var/cache/squid /var/logs /var/log/squid
# mkdir -p /usr/local/squid/var/lib
# LD_LIBRARY_PATH seems to not make it into subshells
# ldconfig also seems broken and doesn't update
ln -s /usr/local/lib/* /usr/lib
ssl_crtd -c -s /var/lib/ssl_db
squid -z
tail -F /var/cache/squid/access.log &
squid -N

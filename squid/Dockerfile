FROM vulk/tcl:core
# Install deps
COPY deps.list /tmp/
RUN cd /tmp && for dep in $(cat /tmp/deps.list); do \
		  sudo -u tc tce-load -wicl $dep ;\
		done
# Copy squid in manually for now
COPY squid-3.4.9.tcz /etc/sysconfig/tcedir/optional/
RUN su -c 'tce-load -ic squid-3.4.9' tc ;\
		mkdir -p /usr/local/ssl/
# We need an openssl.cnf to generate our certs
ENV LD_LIBRARY_PATH /usr/local/lib
COPY openssl.cnf /usr/local/ssl/

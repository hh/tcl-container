FROM vulk/tcl:core
# Without this path set, many things fail to load
ENV LD_LIBRARY_PATH /usr/local/lib

ENV TCL_REPO_BASE   http://tinycorelinux.net/5.x/x86

# Install the kernel sources and everything needed to build them
COPY linux-kernel-sources-env.sh.patch /tmp/
RUN sudo -u tc tce-load -wicl linux-kernel-sources-env ;\
    patch -p1 /usr/local/bin/linux-kernel-sources-env.sh < /tmp/linux-kernel-sources-env.sh.patch ;\
    sed -i 's/sleep 10/sleep 0.5/' /usr/local/bin/linux-kernel-sources-env.sh ;\
    sed -i 's/exit 6/exit 0/' /usr/local/bin/linux-kernel-sources-env.sh ;\
		mkdir -p /lib/modules/3.8.13-1 ;\
		su -c '/usr/local/bin/linux-kernel-sources-env.sh' tc

# Install all the dev stuff
COPY deps.list /tmp/
RUN cd /tmp && for dep in $(cat /tmp/deps.list); do \
		sudo -u tc tce-load -wicl $dep ;\
		done ;\
		mkdir -p /etc/sysconfig/tcedir/optional ;\
		mkdir -p /home/tc ;\
		chown -R tc /etc/sysconfig/tcedir ;\
		chown -R tc /home/tc
RUN wget http://tcztools.googlecode.com/hg/tcztools.tcz -cP /etc/sysconfig/tcedir/optional/ ;\
		su -c 'tce-load -ic tcztools' tc

# ldconfig -v
#ldconfig: uClibc version
#/lib:
#ldconfig: skipping /lib: Value too large for defined data type
#/usr/lib:
#ldconfig: skipping /usr/lib: Value too large for defined data type
#/u:
#ldconfig: skipping /u: No such file or directory
# I don't think uClibc and ldconfig are playing together well on 32bit bins on 64bit docker hosts
# RUN ldconfig



FROM vulk/tcl:core

COPY deps.list /tmp/deps.list

ENV TCL_REPO_BASE   http://tinycorelinux.net/5.x/x86
# Without this path set, many things fail to load
# ENV LD_LIBRARY_PATH /usr/local/lib

# Install the TCZ dependencies
RUN cd /tmp && for dep in $(cat /tmp/deps.list); do \
    echo "Download $TCL_REPO_BASE/tcz/$dep" &&\
        wget $TCL_REPO_BASE/tcz/$dep && \
        unsquashfs -f -d / /tmp/$dep && \
        rm -f /tmp/$dep ;\
    done

RUN ldconfig

COPY build-libdnet.sh /tmp/
RUN /bin/sh /tmp/build-libdnet.sh



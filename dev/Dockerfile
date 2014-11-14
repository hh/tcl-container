FROM vulk/tcl:core

COPY deps.list /tmp/deps.list
ENV http_proxy http://1.1.1.1:3128

ENV TCL_REPO_BASE   http://tinycorelinux.net/5.x/x86
# Without this path set, many things fail to load
ENV LD_LIBRARY_PATH /usr/local/lib

# Install the TCZ dependencies
RUN cd /tmp && for dep in $(cat /tmp/deps.list); do \
    echo "Download $TCL_REPO_BASE/tcz/$dep" &&\
        wget $TCL_REPO_BASE/tcz/$dep && \
        unsquashfs -f -d / /tmp/$dep && \
        rm -f /tmp/$dep ;\
    done

RUN  mkdir /usr/src ; \
		 cd /usr/src ; \
		 wget http://distro.ibiblio.org/tinycorelinux/5.x/x86/release/src/kernel/Module.symvers-3.8.13-tinycore	; \
		 wget http://distro.ibiblio.org/tinycorelinux/5.x/x86/release/src/kernel/config-3.8.13-tinycore ; \
     wget -O - http://distro.ibiblio.org/tinycorelinux/5.x/x86/release/src/kernel/linux-3.8.13-patched.txz | tar xJf - ; \
		 ln -s linux-3.8.13-patched /usr/src/linux ; \
		 cd /usr/src/linux ; \
		 cp ../Module.symvers-3.8.13-tinycore Module.symvers	; \
		 cp ../config-3.8.13-tinycore .config ; \
		 make mrproper CONFIG_SHELL=/usr/local/bin/bash ARCH=i386 ; \
		 cp ../config-3.8.13-tinycore .config ; \
		 make olddefconfig CONFIG_SHELL=/usr/local/bin/bash ARCH=i386 ; \
		 make prepare CONFIG_SHELL=/usr/local/bin/bash ARCH=i386 ; \
		 make modules_prepare  CONFIG_SHELL=/usr/local/bin/bash ARCH=i386 ; \
		 cp ../Module.symvers-3.8.13-tinycore Module.symvers	; \
		 make SUBDIRS=scripts/mod CONFIG_SHELL=/usr/local/bin/bash ARCH=i386 ; \
		 rm ../Module.symvers-3.8.13-tinycore	../config-3.8.13-tinycore

RUN ldconfig



# Create our IPMI modules

# load our patched version of the kernel source grabber
su -c '/usr/local/bin/linux-kernel-sources-env.sh' tc
cd /usr/src/linux-3.8.13
cat /build/ipmi-kernel.config >> .config
make olddefconfig CONFIG_SHELL=/usr/local/bin/bash ARCH=i386
make modules_prepare CONFIG_SHELL=/usr/local/bin/bash ARCH=i386
make modules CONFIG_SHELL=/usr/local/bin/bash ARCH=i386

find . -name '*ko' | \
		xargs -n1 file | grep 32-bit | awk -F: '{print $1}' | xargs strip


MOD_PATH=usr/local/lib/modules/3.8.13-tinycore/kernel/drivers/char/ipmi
STAGE_PATH=/tmp/stage/ipmi-modules
TARGET_PATH=$STAGE_PATH/$MOD_PATH
mkdir -p $TARGET_PATH
mv /usr/src/linux-3.8.13/drivers/char/ipmi/*ko $TARGET_PATH

(cd /tmp/stage && mksquashfs ipmi-modules /build/ipmi-modules-3.8.13-tinycore.tcz)
if [ -d /output ]; then
		cp /build/ipmi-modules-3.8.13-tinycore.tcz /output
fi





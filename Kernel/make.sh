#!/bin/bash

LINUX_KERNEL=$1
KERNEL_SRC=$(basename -s .tar.xz "$LINUX_KERNEL")

CONFIG_ACTUAL=/boot/config-`uname -r`
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ARCH=$(arch)
VERSION=$(cut -d'-' -f2)

CONFIG_FILE="$SCRIPT_DIR"/config

[ "$(whoami)" != 'root' ] && echo 'ERROR: RUN THIS SCRIPT AS ROOT!' && exit 1

if [ ! -d "$KERNEL_SRC" ]; then
  "$SCRIPT_DIR/unpack.sh" "$LINUX_KERNEL.tar.xz" "$KERNEL_SRC" || (
    echo -e '\nERROR: Kernel .tar.(b|g)z not found to be extract and source files not present in /usr/src/\n'
    exit 2
  )
fi

cd "$KERNEL_SRC" &&
echo -e '\n\tCleaning kernel build files and copying the running kernel .config file ...\n' &&
make -j4 mrproper clean
cp "$CONFIG_FILE" .config && 
make -j4 menuconfig &&
echo -e '\n\tCompiling the kernel .rpm files ...\n' &&
make -j4 rpm &&
echo -e '\n\tCleaning build files ...\n' &&
rm -r /usr/src/packages/SRPMS/kernel* /usr/src/packages/BUILD/kernel* &&
echo -e '\n\tCopying RPM files to the script directory ...\n' &&
cd /usr/src/packages/RPMS/"$ARCH" &&
KERNEL_RPMS=$(ls kernel*"$VERSION"*"$ARCH".rpm) &&
mv $KERNEL_RPMS "$SCRIPT_DIR" &&
rm -r -f kernel*.rpm &&
cd "$SCRIPT_DIR" &&
KERNEL_RPMS=$(echo $KERNEL_RPMS | sed -e 's/[^ ]*headers[^ ]*//gi' | tr -s ' ')
echo -e '\n\tTesting the kernel with the system for conflicts ...\n' &&
rpm -ivh --test $KERNEL_RPMS &&
echo -e '\n\tAll tests are OK, initiating installation of the new kernel ...\n' &&
rpm -ivh $KERNEL_RPMS &&
echo -e '\n\tAll went well and smooth :D - Enjoy your new kernel ! \n' 

# THIS STEPS ARE NOT NEEDED, RPM POST-INSTALL SCRIPT
# DOES THIS AUTOMATICALLY
# mkinitrd &&
# grub2-mkconfig -o /boot/grub2/grub.cfg 

# IF YOU NEED IT, YOU CAN USE YAST TO SET THE DEFAULT
# NEW KERNEL (UNCOMMENT THE LINE BELOW)
# yast

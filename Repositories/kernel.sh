#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

REPO_KERNEL_NAME="kernel-default repository"
REPO_FIRMWARE_NAME="kernel-firmware repository"

MSG="Adding kernel default and kernel firmware"

add_repo(){
    echo -e "\tAdding repository... \n" &&
    zypper -n --gpg-auto-import-keys --no-gpg-checks ar -p "$3" -f \
    "$2" "$1" &&
    zypper -n --gpg-auto-import-keys --no-gpg-checks refresh
}

#add repository
(   (zypper lr | grep "$REPO_KERNEL_NAME" > /dev/null) ||
    (
        add_repo "$REPO_KERNEL_NAME" "http://download.opensuse.org/repositories/Kernel:/stable/standard/" "100"
    )
) && (
    (zypper lr | grep "$REPO_FIRMWARE_NAME" > /dev/null) ||
    (
        add_repo "$REPO_FIRMWARE_NAME" "http://download.opensuse.org/repositories/Kernel:/HEAD/standard/" "101"
    )
) && (
    echo -e '\nUpdating kernel...\n' &&
    zypper -n in -l --from "$REPO_KERNEL_NAME" kernel-default kernel-devel kernel-default-devel &&
    zypper -n in -l --from "$REPO_FIRMWARE_NAME" kernel-firmware
)

if [ $? -eq 0 ]; then
    echo -e "\t$MSG - SUCCESS\n"
    exit 0
else
    echo -e "\t$MSG - FAILED\n"
    exit 1
fi




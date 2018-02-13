#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

# GET THE GENERAL FUNCTIONS
. "$UTILITIES_INCLUDE/general_functions.sh"

# GET THE REPOSITORY FUNCTIONS
. "$UTILITIES_INCLUDE/repository_functions.sh"

#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

REPO_KERNEL_NAME="kernel-default repository"
REPO_FIRMWARE_NAME="kernel-firmware repository"

#add repository
verify_add_repo "$REPO_KERNEL_NAME" "http://download.opensuse.org/repositories/Kernel:/stable/standard/" "100" "--no-gpg-checks" &&
verify_add_repo "$REPO_FIRMWARE_NAME" "http://download.opensuse.org/repositories/Kernel:/HEAD/standard/" "101" "--no-gpg-checks" &&
echo -e '\nUpdating kernel...\n' &&
sudo zypper -n in -l --from "$REPO_KERNEL_NAME" kernel-default kernel-devel kernel-default-devel &&
sudo zypper -n in -l --from "$REPO_FIRMWARE_NAME" kernel-firmware &&
display_result "Kernel Update Procedure"




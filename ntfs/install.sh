#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

# GET THE GENERAL FUNCTIONS
. "$UTILITIES_INCLUDE/general_functions.sh"

# GET THE CRON FUNCTIONS
. "$UTILITIES_INCLUDE/cron_functions.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#GENERAL CONFIG VARIABLES
INSTALL_DIR="/etc"

cpy_install "$SCRIPT_DIR" "$INSTALL_DIR" ntfs_mount.sh &&
cp "$SCRIPT_DIR/ntfs_to_mount.conf" /etc &&
create_cron_job "$SCRIPT_DIR" "$INSTALL_DIR" ntfs_mount.sh "@reboot" &&
display_result "Installation of NTFS automounter"

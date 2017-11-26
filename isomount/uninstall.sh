#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#GENERAL OPTIONS
INSTALL_DIR="/usr/sbin"
SUDOERS_SUBFILE="isomount"
SUDOERS_LUKS="/etc/sudoers.d/$SUDOERS_SUBFILE"

#MESSAGES
FINAL_MSG="Uninstall of ISO Utilities"

rm "$SUDOERS_LUKS" 2> /dev/null #try to remove sudoers entry, if it exists
cd "$INSTALL_DIR" && rm isomount isoumount &&
echo -e "$FINAL_MSG - SUCCESSFUL" || (
echo -e "$FINAL_MSG - FAILED" && exit 1)



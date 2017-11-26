#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

INSTALL_DIR="/usr/sbin"
SUDOERS_LUKS="/etc/sudoers.d/luks"

rm "$SUDOERS_LUKS" 2> /dev/null #try to remove luks entry in sudoers, if it exists
cd "$INSTALL_DIR" &&
rm lclose lopen lcreate &&
echo -e "Uninstall of luks scripts - SUCCESSFUL" &&
exit 0
echo -e "Uninstall of luks scripts - FAILED"
exit 0

 

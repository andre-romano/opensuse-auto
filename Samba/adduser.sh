#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

if [ $# -ne 1 ]; then
    echo -e "\n\tUsage: samba_adduser username\n"
    exit 1
fi
smbpasswd -a "$1"

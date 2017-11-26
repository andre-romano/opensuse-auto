#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
ADD_USER="$SCRIPT_DIR/adduser.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "-help" ]; then
    echo -e "\n\tUsage: install_samba USER"
    echo -e "\tOR"
    echo -e "\n\tUsage: install_samba\n"
    exit 1
fi
zypper -n install -l samba samba-client kdebase3-samba &&
if [ $# -eq 1 ]; then
    bash "$ADD_USER" "$1"
fi
echo -e "Samba installation finished"

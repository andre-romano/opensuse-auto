#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

if [ $# -ne 1 ]; then
    echo -e "\n\tUsage: vbox_adduser USER [USER2 [USER3 [..]]]\n"
    exit 1
fi

for var in "$@"; do
    usermod -a -G "vboxusers" "$var"
done &&
echo -e "User add to VirtualBox group - SUCCESS"  &&
echo -e "Please execute a logoff to use VirtualBox" &&
exit 0
echo -e "User add to VirtualBox group - FAILED" 
exit 1


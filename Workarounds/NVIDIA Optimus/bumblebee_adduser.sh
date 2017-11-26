#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#pass user to add
if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "-help" ]; then
    echo -e "\n\tUsage: bumblebee_adduser USER [USER2 [..]]\n"
    exit 0
fi
for var in "$@"; do
    usermod -G "video,bumblebee" "$var"
done &&
echo -e "\n\tUser added to NVIDIA OPTIMUS Bumblebee Group - SUCCESS" &&
exit 0
echo -e "\n\tUser added to NVIDIA OPTIMUS Bumblebee Group - FAILED" 
exit 1

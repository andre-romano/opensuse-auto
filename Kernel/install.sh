#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PWD=$(pwd)

[ "$(whoami)" != 'root' ] && echo 'ERROR: RUN THIS SCRIPT AS ROOT!' && exit 1

KERNEL_RPMS=' '
for var in "$SCRIPT_DIR"/kernel*.rpm ; do
    KERNEL_RPMS="$KERNEL_RPMS $(echo $var | grep -v headers)"
done
rpm -ivh $KERNEL_RPMS &&    
echo -e '\n\tAll went well and smooth :D - Enjoy your new kernel ! \n' 

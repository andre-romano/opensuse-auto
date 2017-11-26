#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1
int='^[0-9]+$'

PROG_NAME="LVM Logical Volume Creator"

#general purpose variables
DEV="/dev/mapper"

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "$PROG_NAME"
    echo -e "\n\tUsage: lvm_create size volume_group mapper_name filesystem\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\tsize\tThe logical volume that you want (you may also use the number% format to indicate how much of the free space available you want to use) "
    echo -e "\tvolume_group\tThe name fo the volume group that you want to add the logical volume to"
    echo -e "\tmapper_name\tThe name of the mapped logical volume"
    echo -e "\tfilesystem\tSpecify the filesystem that you want to format the LVM Logical Volume (Ex: ntfs,ext4,btrfs,xfs or others)"
    echo -e "\nUsage:\nlvm_create 100G MyStore ntfs"
    echo -e "\tlvm_create 80% This ext4"
    exit 0
}

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
    show_help
fi

raise_error() {
    echo -e "\n\t$PROG_NAME - FAILED"
    echo -e "$1"
    if [ -n "$2" ]; then rm "$2" 2> /dev/null; fi #remove file if needed
    exit 1
}

FILESYSTEM=$4
MAPPER_NAME=$3
VOLUME_GROUP=$2
SIZE=$1
if echo $SIZE | grep "%"; then
    lvcreate -l +"$SIZE"FREE "$VOLUME_GROUP" -n "$MAPPER_NAME"
else
    lvcreate -L "$SIZE" "$VOLUME_GROUP" -n "$MAPPER_NAME"
fi
if [ $? -ne 0 ]; then
    raise_error "\tCould not create the logical volume with the requested parameters!"
fi
echo -e "\n\tFormatting logical volume \"$MAPPER_NAME\" with filesystem \"$FILESYSTEM\"..."
if [ "$FILESYSTEM" = "swap" ]; then
    mkswap "$DEV/$VOLUME_GROUP-$MAPPER_NAME"
else
    mkfs -t "$FILESYSTEM" "$DEV/$VOLUME_GROUP-$MAPPER_NAME"
fi
if [ $? -ne 0 ]; then
    raise_error "\tFormatting logical volume \"$MAPPER_NAME\" with filesystem \"$FILESYSTEM\" - FAILED"
fi
echo -e "\t$PROG_NAME - SUCCESSFUL\n" &&
exit 0 || (
echo -e "\t$PROG_NAME - FAILED\n" &&
exit 1 )



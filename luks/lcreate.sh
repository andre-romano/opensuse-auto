#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1
int='^[0-9]+$'

#general purpose variables
DEFAULT_FILESYSTEM="ext4"
DEV="/dev/mapper"
LUKS_HEADER="lheader"
MOUNTPOINT="/run/media/root"

#options variables
FILESYSTEM_OPTION="-f"
SIZE_OPTION="-s"
ALL_OPTIONS="$FILESYSTEM_OPTION $SIZE_OPTION"

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "LUKS File Container Creator"
    echo -e "\tUsage: lcreate <block_device> <block_options>\n"
    echo -e "<block_device> is one of:"
    echo -e "\tdevice\tThe name of the partition or device that you want to format with LUKS"
    echo -e "\tfile\tThe name of the file that you want to create"
    echo -e "\n<block_options> is:"
    echo -e "\tGeneral Options:"
    echo -e "\t\t$FILESYSTEM_OPTION filesystem\tSpecify the filesystem that you want to format the LUKS file container (Ex: ntfs,ext4,btrfs,xfs or others)"
    echo -e "\t\t          \tDefault option: ext4"
    echo -e "\tFor <block_device> = file\n"
    echo -e "\t\t$SIZE_OPTION size\tThe size of the file (you can use the letters K,M or G to mean Kilo,Mega or Giga Bytes)"
    echo -e "\t\t\tEx: 50M (creates a LUKS file with 50 Megabytes of space), 10G (creates a file with 10 Gigabytes), etc"
    exit 0
}

check_help() {
    if [ $# -eq 0 ]; then return 0; fi #needs a file/device to operate
    NEXT_IS=""
    COUNTER=0
    for var in $@; do
        COUNTER=$(($COUNTER+1))
        if [ $COUNTER -eq 1 ]; then continue; fi #AVOID CHECKING file
        HELP_REQUEST="true"
        if [ -n "$NEXT_IS" ]; then
            NEXT_IS=""
            continue
        fi
        for option in $ALL_OPTIONS; do #check for all options provided
            if [ "$var" = "$option" ]; then
                HELP_REQUEST="false"
                NEXT_IS="$option"
                break
            fi
        done
        if [ "$HELP_REQUEST" = "true" ]; then return 0; fi
    done
    if [ -n "$NEXT_IS" ]; then return 0; fi #if part of the options is missing, show help
    return 1
}

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
check_help "$@" && show_help

raise_error() {
    echo -e "\n\tLUKS Container Creation - FAILED"
    echo -e "$1"
    if [ -n "$2" ]; then rm "$2" 2> /dev/null; fi #remove file if needed
    exit 1
}

FILE=$1
FILESYSTEM="$DEFAULT_FILESYSTEM"
#GET PARAMETERS
NEXT_IS=""
COUNTER=0
for var in "$@"; do
    COUNTER=$(($COUNTER+1)) #skip the first parameter from analysis
    if [ $COUNTER -eq 1 ]; then continue; fi
    case "$var" in
        "$SIZE_OPTION") NEXT_IS=$SIZE_OPTION ;;
        "$FILESYSTEM_OPTION") NEXT_IS=$FILESYSTEM_OPTION ;;
        *) case "$NEXT_IS" in
            "$SIZE_OPTION") SIZE="$var" ;;
            "$FILESYSTEM_OPTION") FILESYSTEM="$var" ;;
            *) show_help ;;
        esac ;;
    esac
done
#GET PARAMETERS - ENDED
if [ ! -e "$FILE" ]; then
    if [ -z "$SIZE" ]; then
        raise_error "\tThe size to create the file is not provided. Please use the option \"$SIZE_OPTION size\"."
    fi
    echo -e "\n\tCreating file \"$FILE\" with $SIZE B of size..." &&
    fallocate -l "$SIZE" "$FILE" ||
    raise_error "\tCreating file \"$FILE\" with $SIZE B - FAILED" "$FILE"
fi
echo -e "\n\tFormatting file \"$FILE\" to have a LUKS Header Layer..." &&
cryptsetup -y luksFormat "$FILE" ||
raise_error "\tFormatting file \"$FILE\" for LUKS Header Layer - FAILED" "$FILE"
UUID=$(cryptsetup luksUUID "$FILE") &&
echo -e "\tMounting the file \"$FILE\" inside LUKS Virtual Volumes..." &&
cryptsetup luksOpen "$FILE" "$UUID" ||
raise_error "\tOpenning LUKS file \"$FILE\" - FAILED" "$FILE"
DEVICE_MAPPER="$DEV/$UUID"
echo -e "\n\tFormatting device/file \"$FILE\" with filesystem \"$FILESYSTEM\"..." &&
mkfs -t "$FILESYSTEM" "$DEVICE_MAPPER" ||
raise_error "\tFormatting file \"$FILE\" with filesystem \"$FILESYSTEM\" - FAILED" "$FILE"
cryptsetup luksClose "$UUID" ||
raise_error "\tClosing file \"$FILE\" - FAILED" "$FILE"
MOUNTPOINT="$MOUNTPOINT/$UUID"
lopen "$FILE" && #the chown and chmod are only gonna work for native LINUX filesystems
chown -R root:users "$MOUNTPOINT" 2> /dev/null #try to change ownership to users
chmod -R 1770 "$MOUNTPOINT" 2> /dev/null #try to change permissions to better handle security issues
lclose "$FILE" &&
if [ ! -b "$FILE" ]; then
    echo -e "\tBacking up the LUKS Header for increased security\n" &&
    cryptsetup luksHeaderBackup "$FILE" --header-backup-file "$FILE.$LUKS_HEADER" ||
    echo -e "\tCould not backup LUKS header. Please ensure to do this backup as soon as possible!"
fi
echo -e "\tLUKS FILE CONTAINER CREATION - SUCCESSFUL\n" &&
exit 0
echo -e "\tLUKS FILE CONTAINER CREATION - FAILED\n"
if [ ! -b "$FILE" ]; then
    rm "$FILE"
fi
exit 1

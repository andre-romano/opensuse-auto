#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1
int='^[0-9]+$'

DEV="/dev/mapper"
MOUNTPOINT="/run/media/root"
LUKS_HEADER="lheader"

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "LUKS File Opener"
    echo -e "\n\tUsage: lopen file [file [..]]\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\tfile\tThe file that you want to open with LUKS"
    exit 0
}

check_help() {
    if [ $# -eq 0 ]; then return 0; fi #at least one file is needed
    for var in "$@"; do
        HELP_REQUEST="true"
        for option in "$ALL_OPTIONS"; do #check for all options provided
            if [ "$var" = "$option" ]; then
                HELP_REQUEST="false"
                break
            fi
        done
        if [ -e "$var" ]; then HELP_REQUEST="false"; fi #check if all files provided exist
        if [ "$HELP_REQUEST" = "true" ]; then return 0; fi
    done
    return 1
}

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
check_help "$@" && show_help

raise_error() {
    echo -e "\n\tLUKS Container Open - FAILED"
    echo -e "$1"
    if [ -n "$2" ]; then rm -d "$2"; fi 2> /dev/null #remove empty directory
    exit 1
}

recover_header() {
    echo "DETECTED LUKS MALFUNCITON - HEADER RECOVERY INITIATED"
    if [ -b "$1" ]; then
        raise_error "\tThe File is a block file (probably a device) and therefore no LUKS Header Backup was done \
in the \"lcreate\" command. Could not restore normal functionality of LUKS file/device!"
    fi
    HEADER="$1.$LUKS_HEADER"
    if [ ! -e "$HEADER" ]; then
        raise_error "\tThe File/Device \"$1\" is not LUKS formatted. Please use \"lcreate\" to format it."
    fi
    echo -e "\tWARNING: There's a problem with the LUKS Header. Trying to recover backup!"
    if cryptsetup isLuks "$HEADER" ; then
        raise_error "\The LUKS header backup of \"$1\" is compromised. Could not recover LUKS header!"
    fi
    cryptsetup luksHeaderRestore "$1" --header-backup-file "$HEADER" ||
    raise_error "\The LUKS header backup of \"$1\" is partially compromised. Could not recover LUKS header!"
}

for var in "$@"; do
    MOUNT_OPTIONS="relatime,nosuid" &&
    cryptsetup isLuks "$var" ||
    recover_header "$var"
    UUID=$(cryptsetup luksUUID "$var") &&
    DEVICE_MAPPER="$DEV/$UUID" &&
    MOUNTPOINT="$MOUNTPOINT/$UUID" &&
    cryptsetup luksOpen "$var" "$UUID" ||
    raise_error "\tCould not open LUKS container/device \"$var\""
    FILESYSTEM="$(blkid | grep "$DEVICE_MAPPER" | grep -Po "(?<=TYPE=\").+" | awk -F \" '{print$1}')"
    if [ "$FILESYSTEM" = "ntfs" ] || [ "$FILESYSTEM" = "msdos" ] || echo "$FILESYSTEM" | grep "fat"; then
        echo -e "\tWARNING: NTFS/FAT filesystem detected. UNIX/POSIX permissions disabled, allowing all users full-access control..."
        MOUNT_OPTIONS="$MOUNT_OPTIONS,umask=000" #handle non-native filesystems
    fi
    mkdir -p "$MOUNTPOINT" &&
    mount -o "$MOUNT_OPTIONS" "$DEVICE_MAPPER" "$MOUNTPOINT" ||
    raise_error "\tCould not mount the OPENED container \"$var\"\n" "$MOUNTPOINT"
done

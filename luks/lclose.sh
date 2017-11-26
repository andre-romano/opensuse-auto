#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1
int='^[0-9]+$'

DEV="/dev/mapper"
MOUNTPOINT="/run/media/root"

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "LUKS File Container Closer"
    echo -e "\tUsage: lclose file [file [..]]\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\tfile\tThe LUKS file that you want to close"
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
    echo -e "\n\tLUKS Container Close - FAILED"
    echo -e "$1"
    exit 1
}

LUKS_EXT="luks"
for var in "$@"; do
    if [ ! -e "$var" ] || ! cryptsetup isLuks "$var"; then
        raise_error "\tThe file \"$var\" is not a LUKS file or does NOT EXIST!\n"
    fi
    UUID=$(cryptsetup luksUUID "$var") &&
    MOUNTPOINT="$MOUNTPOINT/$UUID" &&
    DEVICE_MAPPER="$DEV/$UUID" &&
    while umount "$DEVICE_MAPPER"; do : ; done 2> /dev/null #keep unmounting until there's nothing else to unmount
    cryptsetup luksClose "$UUID"
    if [ $? -ne 0 ] && [ -d "$MOUNTPOINT" ]; then
        raise_error "\tFile \"$var\" is being used. Check for files inside the LUKS container \
that are OPENED by any program and close them. File explorers that are opened inside a path of the LUKS Container should also be closed!"
    fi
    rm -d "$MOUNTPOINT" 2> /dev/null
done



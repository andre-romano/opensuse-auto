#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1
int='^[0-9]+$'


show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "eCryptfs Folder Closer"
    echo -e "\tUsage: eclose file [file [..]]\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\tfile\tThe eCryptfs folder that you want to close"
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

for var in "$@"; do
    umount "$var" ||
    (echo -e "ERROR: Could not close \"$var\" encrypted folder!" && exit 1)
done



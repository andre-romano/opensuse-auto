#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#GENERAL CONFIG VARIABLES
INSTALL_DIR="/usr/sbin"
SUDOERS="/dev/null"
SUDOERS_SUBFILE="isomount"
CMND_ALIAS="ISOMOUNT_CMD"

#OPTIONS SECTION
SUDOERS_OPTION="-S"
ALL_OPTIONS=$SUDOERS_OPTION

#MESSAGES
INSTALL_MSG="Installation of ISO Utilities"

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "ISO Utilities Installer"
    echo -e "\n\tUsage: install [options]\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\t$SUDOERS_OPTION\tCreate Sudoers entries to avoid root password"
    exit 0
}

check_help() {
    for var in "$@"; do
        HELP_REQUEST="true"
        for option in "$ALL_OPTIONS"; do
            if [ "$var" = "$option" ]; then
                HELP_REQUEST="false"
                break
            fi
        done
        if [ "$HELP_REQUEST" = "true" ]; then return 0; fi
    done
    return 1
}

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
check_help "$@" && show_help

if [ "$1" = "$SUDOERS_OPTION" ]; then
    echo -e "WARNING: Sudoers entry option selected. These script utilities will NOT require
root permission and it's password to run! This might pose a SECURITY RISK!"
    SUDOERS="/etc/sudoers.d/$SUDOERS_SUBFILE" #send stdout to sudoers device
fi

cpy_install() {
    COUNTER=1
    echo -n "Cmnd_Alias $CMND_ALIAS = " > $SUDOERS
    for var in "$@"; do
        ORIGIN_FILE="$SCRIPT_DIR/$var"
        DEST_FILE="$INSTALL_DIR/$(basename "$var" .sh)"
        cp "$ORIGIN_FILE" "$DEST_FILE" &&
        chown root:root "$DEST_FILE" && chmod 755 "$DEST_FILE" &&
        echo -n "$DEST_FILE" >> $SUDOERS &&
        if [ $COUNTER -ne $# ]; then echo -n ", " >> $SUDOERS ;
        else echo -n -e "\n" >> $SUDOERS; fi
        COUNTER=$(($COUNTER+1))
    done
}

cpy_install isomount isoumount &&
#AVOID ROOT PASSWORD
echo -e "%users ALL=(root) NOPASSWD: $CMND_ALIAS" >> $SUDOERS &&
echo -e "$INSTALL_MSG - SUCCESSFUL" || (
echo -e "$INSTALL_MSG - FAILED")


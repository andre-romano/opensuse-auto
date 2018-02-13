#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

# GET THE GENERAL FUNCTIONS
. "$UTILITIES_INCLUDE/general_functions.sh"
. "$UTILITIES_INCLUDE/help.sh"

# GET THE CRON FUNCTIONS
. "$UTILITIES_INCLUDE/cron_functions.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#GENERAL CONFIG VARIABLES
INSTALL_DIR="/usr/sbin"
SUDOERS_SUBFILE="isomount"
SUDOERS="/etc/sudoers.d/$SUDOERS_SUBFILE" #send stdout to sudoers device
CMND_ALIAS="ISOMOUNT_CMD"

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help "ISO Utilities Installer" \
        "Install some convenient scripts to mount ISO images from command line" \
        "install"
fi

cpy_install_sudoers() {
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

cpy_install_sudoers isomount isoumount &&
#AVOID ROOT PASSWORD
echo -e "%users ALL=(root) NOPASSWD: $CMND_ALIAS" >> $SUDOERS &&
display_result "Installation of ISO Utilities"


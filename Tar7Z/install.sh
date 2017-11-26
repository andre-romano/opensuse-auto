#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#GENERAL CONFIG VARIABLES
INSTALL_DIR="/usr/bin"

MSG="Installation of Tar7Z Scripts"

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "Tar7Z - Preserve permissions, archive and compress/extract with 7z - Installer"
    echo -e "\n\tUsage: [sudo] install\n"
    exit 0
}

check_help() {
    for var in "$@"; do
    HELP_REQUEST="true"
    for option in "$ALL_OPTIONS"; do
        if [ "$var" = "$option" ]; then HELP_REQUEST="false"; fi
    done
    if [ "$HELP_REQUEST" = "true" ]; then return 0; fi
    done
    return 1
}

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
check_help $@ && show_help


cpy_install() {
    var=$1.sh
    ORIGIN_FILE="$SCRIPT_DIR/$var" &&
    DEST_FILE="$INSTALL_DIR/$(basename "$var" .sh)" &&
    cp "$ORIGIN_FILE" "$DEST_FILE" &&
    chown root:root "$DEST_FILE" && chmod 755 "$DEST_FILE"
}

cpy_install tar7z &&
echo -e "$MSG - SUCCESSFUL" ||
(echo -e "$MSG - FAILED" && exit 0)



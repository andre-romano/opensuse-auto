#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#GENERAL CONFIG VARIABLES
INSTALL_DIR=/opt/.bin
BINARIES='pdfcompress.sh'

#MESSAGES
INSTALL_MSG="Installation of PDF Utilities"

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "PDF Utilities Installer"
    echo -e "\n\tUsage: install [directory]\n"
    exit 0
}

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then show_help; fi

# install deps
sudo zypper -n in -l ghostscript ghostscript-fonts

# check for custom install dir
if [ $# -gt 0 ]; then INSTALL_DIR=$1; fi
# create dir if needed
mkdir -p "$INSTALL_DIR"
INSTALL_DIR_OWN=$(ls -ld "$INSTALL_DIR" | tr -s ' ' | cut -d' ' -f3)
INSTALL_DIR_GRP=$(ls -ld "$INSTALL_DIR" | tr -s ' ' | cut -d' ' -f4)
# install binaries
for bin in $BINARIES; do
    BIN_NAME=$(echo "$INSTALL_DIR/"$(basename -s .sh $bin))
    cp "$SCRIPT_DIR/$bin" "$INSTALL_DIR" &&
    mv "$INSTALL_DIR/$bin" "$BIN_NAME" &&
    chown "$INSTALL_DIR_OWN":"$INSTALL_DIR_GRP" "$BIN_NAME" &&
    chmod 755 "$BIN_NAME"
done
echo -e "$INSTALL_MSG - SUCCESSFUL" || (
echo -e "$INSTALL_MSG - FAILED")


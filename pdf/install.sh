#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

# GET THE GENERAL FUNCTIONS
. "$UTILITIES_INCLUDE/general_functions.sh"

# GET THE help FUNCTIONS
. "$UTILITIES_INCLUDE/help.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#GENERAL CONFIG VARIABLES
INSTALL_DIR=/usr/bin

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then 
    show_help "PDF Utilities Installer" \
        "Utilities to compress pdfs and other cool stuff :) " \
        "install"
fi

# install deps
sudo zypper -n in -l ghostscript ghostscript-fonts

# install binaries
cpy_install "$SCRIPT_DIR" "$INSTALL_DIR" "pdfcompress.sh" &&
mv "$INSTALL_DIR/pdfcompress.sh" "$INSTALL_DIR/pdfcompress" &&
display_result "Installation of PDF Utilities"


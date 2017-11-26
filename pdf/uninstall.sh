#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#GENERAL OPTIONS
INSTALL_DIR="/opt/.bin"

BINARIES='pdfcompress'

if [ -n "$1" ]; then INSTALL_DIR=$1; fi
for bin in $BINARIES; do
    rm -rf "$INSTALL_DIR/$bin" &&
    echo -en "Uninstall of $bin script - " && echo -e 'SUCESSFULL' ||
    (
        echo -e "FAILED"
        exit 1
    )
done

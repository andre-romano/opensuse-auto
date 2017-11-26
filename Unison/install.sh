#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

INSTALL_DIR=/usr/bin
DESKTOP_DIR=/usr/share/applications
PROGRAM_NAME=unison

zypper -n in -l $PROGRAM_NAME
#set ulimit to avoid memory leaking problems
cp "$SCRIPT_DIR/$PROGRAM_NAME.sh" "$INSTALL_DIR" &&
chmod 755 "$INSTALL_DIR/$PROGRAM_NAME.sh" &&
sed -i "s/^Exec=.*/Exec=$PROGRAM_NAME.sh/" "$DESKTOP_DIR/$PROGRAM_NAME.desktop" &&
echo "$PROGRAM_NAME INSTALLATION - SUCCESS" ||
(echo "$PROGRAM_NAME INSTALLATION - FAILED" && exit 1)

#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" == "root" ] && echo -e "\n\tRUN this script as NON-ROOT. Exiting...\n" && exit 1

PROGRAM_NAME="couchpotato"
DESKTOP_AUTOSTART="$PROGRAM_NAME"_auto.desktop

#set autostart
cp "$SCRIPT_DIR/$DESKTOP_AUTOSTART" ~/.config/autostart &&
echo "Couch Potato - Autostart Setting - SUCCESS" &&
exit 0
echo "Couch Potato - Autostart Setting - FAILED"
exit 1

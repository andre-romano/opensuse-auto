#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
PROGRAM_NAME="ums"
BASE_NAME="UMS"
ICON="$PROGRAM_NAME.png"
DESKTOP="$PROGRAM_NAME.desktop"
INSTALL_DIR="/opt/$BASE_NAME-"
INSTALL_LINK="/usr/bin/$PROGRAM_NAME"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#uninstall popcorn
rm -r "$INSTALL_DIR"*
rm "$INSTALL_LINK"
#uninstall desktop icon 
rm "/usr/share/applications/$DESKTOP"
rm "/usr/share/icons/hicolor/16x16/apps/$ICON"
rm "/usr/share/icons/hicolor/32x32/apps/$ICON" 
rm "/usr/share/icons/hicolor/64x64/apps/$ICON" 
rm "/usr/share/icons/hicolor/128x128/apps/$ICON" 

#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
EXECUTABLE_NAME="UMS.sh"
BASE_NAME="ums"
PROGRAM_NAME="ums"
LINK_LOCATION="/usr/bin/$PROGRAM_NAME"
BASE_DIR="/opt/$BASE_NAME-"

INDEX="index.html"
OFFICIAL_URL="http://www.universalmediaserver.com/"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

wget -O "$INDEX" "$OFFICIAL_URL"
if [ $? -ne 0 ]; then
    echo "Error downloading '$BASE_NAME'"	
    exit 1
fi
DOWNLOAD="$(grep Linux "$INDEX"" | head -n 2 | tail -n 1 | awk -F \" '{print$2}')"
rm "$INDEX"
VERSION="$(echo "$DOWNLOAD" | awk -F - '{print$2}')"
DIR="$BASE_DIR$VERSION"
if [ ! -d "$DIR" ]; then
    rm -r "$BASE_DIR"* 2> /dev/null 
    cd "/opt/"
    FILE="$(echo "$DOWNLOAD" | awk -F \/ '{print$9}')"
    wget -O "$FILE" "$DOWNLOAD"
    tar -axvf "$FILE" && chmod -R 750 "$DIR" && chown -R "$(whoami):users" "$DIR" &&
    rm "$LINK_LOCATION" 2> /dev/null
    ln -s "$DIR/$EXECUTABLE_NAME" "$LINK_LOCATION"
    rm "$FILE" 2> /dev/null
    echo -e "\n\tInstalation/Update completed with success!"
    echo -e "\n\tVersion installed: $VERSION - Architecture: $ARCH"
else
   echo -e "\n\tNothing to do, already updated version '$VERSION' installed"
fi

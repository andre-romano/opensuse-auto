#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

MSG="Deactivation of Desktop Search"

if [ "$SUSE_VERSION" = "13.2" ]; then
    DESKTOP_DIR=/usr/share/autostart
else
    DESKTOP_DIR=/etc/xdg/autostart
fi

for var in $DESKTOP_DIR/baloo*.desktop $DESKTOP_DIR/tracker-*.desktop ; do
    echo "Hidden=True" >> "$var" 
done
echo "$MSG - SUCCESS" ||
(echo "$MSG - FAILED" && exit 1)

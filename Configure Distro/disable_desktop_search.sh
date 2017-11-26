#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

MSG="Deactivation of BALOO Desktop Search"

if [ "$SUSE_VERSION" = "13.2" ]; then
    DESKTOP_FILE=/usr/share/autostart/baloo_file.desktop
else
    DESKTOP_FILE=/etc/xdg/autostart/baloo_file.desktop
fi

echo "Hidden=True" >> "$DESKTOP_FILE" &&
echo "$MSG - SUCCESS" ||
(echo "$MSG - FAILED" && exit 1)

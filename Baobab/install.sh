#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

MSG="Baobab Installation"
BAOBAB_DESKTOP=/usr/share/applications/org.gnome.baobab.desktop

zypper -n in -l baobab &&
sed -i 's/^NotShowIn=/#NotShowIn=/g' "$BAOBAB_DESKTOP" &&
echo "$MSG - SUCCESS" ||
(echo "$MSG - FAILED" && exit 1)


#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

MSG="Baobab Installation"
BAOBAB_DESKTOP=/usr/share/applications/org.gnome.baobab.desktop

sudo su -c "
zypper -n in -l baobab &&
sed -i 's/^NotShowIn=/#NotShowIn=/g' '$BAOBAB_DESKTOP' &&
" &&
echo "$MSG - SUCCESS" ||
(echo "$MSG - FAILED" && exit 1)


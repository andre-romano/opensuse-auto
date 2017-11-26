#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

MSG="Auto Update System"

SCRIPT=auto-update.sh
INSTALL_SCRIPT=/etc/cron.weekly/

install_cpy() {
  cp "$SCRIPT_DIR/$1" "$2" &&
  chmod 755 "$2/$1"
}

install_cpy "$SCRIPT" "$INSTALL_SCRIPT" &&
echo -e "$MSG - SUCCESS" ||
(echo -e "$MSG - FAILED" && exit 1)

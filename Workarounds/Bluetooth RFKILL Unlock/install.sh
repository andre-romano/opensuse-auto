#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(INSTALL_SCRIPT)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

MSG="Fix Bluetooth RFKILL Unlock"

SCRIPT=bluetooth_unlock
INSTALL_SERVICE=/etc/systemd/system/
INSTALL_SCRIPT=/opt/

install_cpy() {
  cp "$SCRIPT_DIR/$1" "$2" &&
  chmod +rx "$2/$1"
}

install_cpy "$SCRIPT.sh" "$INSTALL_SCRIPT" &&
install_cpy "$SCRIPT.service" "$INSTALL_SERVICE" &&
systemctl enable "$SCRIPT" &&
systemctl start "$SCRIPT" &&
echo -e "$MSG - SUCCESS" ||
(echo -e "$MSG - FAILED" && exit 1)

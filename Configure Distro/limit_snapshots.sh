#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

CUSTOM_CONFIG=root
DEFAULT_CONFIG_FILE=/etc/snapper/configs/root
MSG="Custom snapshot limits set"

if [ -e $DEFAULT_CONFIG_FILE ]; then
  mv $DEFAULT_CONFIG_FILE "$DEFAULT_CONFIG_FILE".bak &&
  cp $SCRIPT_DIR/$CUSTOM_CONFIG $DEFAULT_CONFIG_FILE &&
  echo -e "$MSG - SUCCESS (Backup also done)" ||
  (echo -e "$MSG - FAILED" && exit 1)
fi
echo -e "Custom snapshot limits set - NO CHANGES NEEDED (Snapper config doesn't exist - BTRFS not being used)"
exit 0

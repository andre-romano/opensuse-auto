#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

MSG="SWAPPINESS DESKTOP CONFIG"

VALUE=40
CONFIG=/etc/sysctl.d/swappiness.conf
ATTRIBUTE="vm.swappiness=$VALUE"

echo "$ATTRIBUTE" > "$CONFIG" &&
sysctl $ATTRIBUTE &&
echo -e "\n\t$MSG - SUCCESS\n"  ||
(echo -e "\n\t$MSG - FAILED\n" && exit 1)

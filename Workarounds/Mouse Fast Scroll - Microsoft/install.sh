#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/../.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

RESET_MS_MICE="$SCRIPT_DIR/resetmsmice"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

INSTALL_DIR="/usr/share/autostart"
DESKTOP_FILE="$RESET_MS_MICE.desktop"

# install package without any checks for dependency or signature
rpm -i --nodeps --nosignature "$RESET_MS_MICE"*.rpm &&
# make it run at system boot (any user login)
cp "$DESKTOP_FILE" "$INSTALL_DIR" && chmod 644 "$INSTALL_DIR/$(basename $DESKTOP_FILE)" &&
echo "Microsoft Mouse Workaround - SUCCESS" && exit 0
echo "Microsoft Mouse Workaround - FAILED" && exit 1


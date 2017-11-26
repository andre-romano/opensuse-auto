#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

INSTALL_DIR="/opt"
FILENAME="pycharm-*"

cd "$INSTALL_DIR"
tar --overwrite --group=users --mode=777 -xavf "$SCRIPT_DIR"/$FILENAME

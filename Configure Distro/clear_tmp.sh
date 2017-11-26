#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

CONFIG_FILE=/etc/tmpfiles.d/tmp.conf
MSG="Clear TMP Files At Boot"

echo "R /tmp/*" > "$CONFIG_FILE" &&
echo "R /var/tmp/*" >> "$CONFIG_FILE" &&
chown root:root "$CONFIG_FILE" &&
chmod 644 "$CONFIG_FILE" &&
echo "$MSG - SUCCESS" ||
(echo "$MSG - FAILED" && exit 1)

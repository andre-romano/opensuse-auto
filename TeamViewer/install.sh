#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
PROGRAM_NAME="teamviewer"
UPDATE_PERIOD="weekly"
UPDATE_FILE="update.sh"
#update/install Teamviewer

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

rpm --import "$SCRIPT_DIR/teamviewer.pub" #import key
bash "$SCRIPT_DIR/$UPDATE_FILE" &&
echo -e "\n\tInstalation completed with success. Proceed..." &&
#schedule updater
cp "$UPDATE_FILE" "/etc/cron.$UPDATE_PERIOD/$PROGRAM_NAME-$UPDATE_FILE" &&
chmod 750 "/etc/cron.$UPDATE_PERIOD/$PROGRAM_NAME-$UPDATE_FILE" &&
echo -e "All operations done with SUCCESS, '$PROGRAM_NAME' installed with success" &&
exit 0
echo -e "All operations done with FAILURE, '$PROGRAM_NAME' installation aborted"
exit 1

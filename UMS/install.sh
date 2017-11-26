#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
PROGRAM_NAME="ums"
UPDATE_PERIOD="weekly"
UPDATE_FILE="update.sh"
ICON="$PROGRAM_NAME.png"
DESKTOP="$PROGRAM_NAME.desktop"
#update/install UMS

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

bash "$SCRIPT_DIR/$UPDATE_FILE" &&
echo -e "\n\tInstalation completed with success. Adding desktop icons..." &&
#Install desktop icon 
cp "$DESKTOP" "/usr/share/applications/" && 
chmod 644 "/usr/share/applications/$DESKTOP"
cp "$ICON" "/usr/share/icons/hicolor/16x16/apps/" && 
chmod 644 "/usr/share/icons/hicolor/16x16/apps/$ICON"
ln -s "/usr/share/icons/hicolor/16x16/apps/$ICON" "/usr/share/icons/hicolor/32x32/apps/$ICON"
ln -s "/usr/share/icons/hicolor/16x16/apps/$ICON" "/usr/share/icons/hicolor/64x64/apps/$ICON"
ln -s "/usr/share/icons/hicolor/16x16/apps/$ICON" "/usr/share/icons/hicolor/128x128/apps/$ICON"
echo -e "\n\tDesktop icons added, registering auto-updater script..."
#schedule updater
cp "$SCRIPT_DIR/$UPDATE_FILE" "/etc/cron.$UPDATE_PERIOD/$PROGRAM_NAME-$UPDATE_FILE" &&
chmod 750 "/etc/cron.$UPDATE_PERIOD/$PROGRAM_NAME-$UPDATE_FILE" &&
echo -e "All operations done with SUCCESS, '$PROGRAM_NAME' installed with success" &&
exit 0
echo -e "All operations done with FAILURE, '$PROGRAM_NAME' installation aborted"
exit 1

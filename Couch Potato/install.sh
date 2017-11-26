#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#desktop info
PROGRAM_NAME="couchpotato"
ICON="$PROGRAM_NAME.png"
DESKTOP="$PROGRAM_NAME.desktop"

INSTALL_LINK="/usr/bin/$PROGRAM_NAME"
INSTALL_PATH="/opt/CouchPotato"


chg_perm(){
    chown -R root:users "$1" &&
    chmod -R 670 "$1"
}

install_couch(){
    zypper -n in -l git &&
    git clone "https://github.com/RuudBurger/CouchPotatoServer.git" "$INSTALL_PATH" &&
    chg_perm "$INSTALL_PATH" &&
    echo "#!/bin/bash
    python $INSTALL_PATH/CouchPotato.py &
    " > "$INSTALL_LINK" &&
    chg_perm "$INSTALL_LINK"
}

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

install_couch &&
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
echo -e "All operations done with SUCCESS, '$PROGRAM_NAME' installed with success" &&
exit 0
echo -e "All operations done with FAILURE, '$PROGRAM_NAME' installation aborted"
exit 1


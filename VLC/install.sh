#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"

# if it's not root, exit!
[ "$(whoami)" == "root" ] && echo -e "\n\tRUN this script as NON-ROOT. Exiting...\n" && exit 1

INSTALL_DIR=/usr/bin
DESKTOP_DIR=/usr/share/applications
PROGRAM_NAME=vlc
CONFIG_FILE=vlcrc
CONFIG_DIR=~/.config/vlc
CONFIG_PERMISSION=600
CONFIG_FULLFILENAME=$CONFIG_DIR/$CONFIG_FILE

show_failed(){
    echo "$PROGRAM_NAME INSTALLATION - FAILED"
    exit 1
}

change_config(){
    sed -i "s/^[#]*$1=.*/$1=$2/" "$CONFIG_FULLFILENAME"
}

echo -en "To complete this part of the script, type\n[root] " &&
#install and set ulimit to avoid memory leaking problems
su -c "
zypper -n in -l $PROGRAM_NAME &&
cp '$SCRIPT_DIR/$PROGRAM_NAME.sh' '$INSTALL_DIR' &&
chmod 755 '$INSTALL_DIR/$PROGRAM_NAME.sh' &&
sed -i 's/^Exec=.*vlc /Exec=vlc.sh /' '$DESKTOP_DIR/$PROGRAM_NAME.desktop' &&
sed -i 's/^TryExec=.*/TryExec=vlc.sh/' '$DESKTOP_DIR/$PROGRAM_NAME.desktop'
" || show_failed
if [ ! -e "$CONFIG_FULLFILENAME" ]; then
    mkdir -p "$CONFIG_DIR"
    if [ ! -d "$CONFIG_DIR" ]; then
    	echo -e "Could not create config dir inside your home directory. Please run \"$PROGRAM_NAME\" once to allow it to create this file for you."
    	show_failed
    fi
else
    cp $CONFIG_FULLFILENAME "$CONFIG_FULLFILENAME.bak" ||
    (echo "Could not generate backup of config file!" && show_failed)
    change_config vout xcb_xv &&
    change_config avcodec-hw none &&
    for cfg in file-caching live-caching disc-caching network-caching; do
        change_config "$cfg" 1500
    done
    if [ $? -ne 0 ]; then show_failed; fi
fi
echo "$PROGRAM_NAME INSTALLATION - SUCCESS" || show_failed


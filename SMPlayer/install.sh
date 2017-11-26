#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"

# if it's not root, exit!
[ "$(whoami)" == "root" ] && echo -e "\n\tRUN this script as NON-ROOT. Exiting...\n" && exit 1

INSTALL_DIR=/usr/bin
DESKTOP_DIR=/usr/share/applications
PROGRAM_NAME=smplayer
CONFIG_FILE=smplayer.ini
CONFIG_DIR=~/.config/smplayer
CONFIG_PERMISSION=700
CONFIG_FULLFILENAME=$CONFIG_DIR/$CONFIG_FILE

show_failed(){
    echo "$PROGRAM_NAME INSTALLATION - FAILED" 
    exit 1
}

sudo zypper -n in -l $PROGRAM_NAME
#set ulimit to avoid memory leaking problems
sudo cp "$SCRIPT_DIR/$PROGRAM_NAME.sh" "$INSTALL_DIR" &&
sudo chmod 755 "$INSTALL_DIR/$PROGRAM_NAME.sh" &&
sudo mv "$DESKTOP_DIR/$PROGRAM_NAME.desktop" "$DESKTOP_DIR/$PROGRAM_NAME.desktop.bak" &&
sudo cp "$SCRIPT_DIR/$PROGRAM_NAME.desktop" "$DESKTOP_DIR/$PROGRAM_NAME.desktop" ||
show_failed
if [ ! -e "$CONFIG_FULLFILENAME" ]; then    
    mkdir -p "$CONFIG_DIR"    
    if [ ! -d "$CONFIG_DIR" ]; then
	echo -e "Could not create config dir inside your home directory. Please run \"$PROGRAM_NAME\" once to allow it to create this file for you."
	show_failed
    fi
else
  cp $CONFIG_FULLFILENAME "$CONFIG_FULLFILENAME".bak ||  
  (echo "Could not generate backup of config file!" && show_failed)
fi
cp "$SCRIPT_DIR/$CONFIG_FILE" $CONFIG_FULLFILENAME &&
chmod $CONFIG_PERMISSION $CONFIG_FULLFILENAME &&
echo "$PROGRAM_NAME INSTALLATION - SUCCESS" ||
show_failed

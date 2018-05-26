#!/bin/bash

AUTOSTART_XDG="/etc/xdg/autostart"
AUTOSTART_SYSTEMD="/etc/systemd/system"

install_service(){
    local SERVICE=$1
    local SCRIPT=$2
    local DEST=$3
    shift; shift; shift
    cp "$SCRIPT_DIR/$SERVICE" "$AUTOSTART_SYSTEMD" &&
    chmod 644 "$AUTOSTART_SYSTEMD/$SERVICE" &&
    cp "$SCRIPT_DIR/$SCRIPT" "$DEST" &&
    chmod 755 "$DEST/$SCRIPT" &&    
    systemctl daemon-reload &&
    systemctl enable "$SERVICE" 
}

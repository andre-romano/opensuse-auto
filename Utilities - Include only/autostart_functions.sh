#!/bin/bash

AUTOSTART_XDG="/etc/xdg/autostart"
AUTOSTART_SYSTEMD="/etc/systemd/system"
AUTOSTART_UDEV="/etc/udev/rules.d"
AUTOSTART_MODULES="/etc/modules-load.d"

install_systemd_service(){
    while [ $# -gt 0 ]; do    
        local SERVICE=$1    
        shift
        cp "$SCRIPT_DIR/$SERVICE" "$AUTOSTART_SYSTEMD" &&
        chmod 644 "$AUTOSTART_SYSTEMD/$SERVICE" &&
        systemctl daemon-reload &&
        systemctl enable "$SERVICE" 
    done    
}

install_systemd_target(){
    while [ $# -gt 0 ]; do
        local SERVICE=$1
        shift
        cp "$SCRIPT_DIR/$SERVICE" "$AUTOSTART_SYSTEMD" &&
        chmod 644 "$AUTOSTART_SYSTEMD/$SERVICE" 
    done
    systemctl daemon-reload 
}

install_udev_rules(){
    while [ $# -gt 0 ]; do
        local UDEV_RULES=$1
        shift
        cp "$SCRIPT_DIR/$UDEV_RULES" "$AUTOSTART_UDEV" &&
        chmod 644 "$AUTOSTART_UDEV/$UDEV_RULES" 
    done
    udevadm control --reload-rules
}

install_module(){
    local DEST_FILE="$1"
    shift
    touch "$AUTOSTART_MODULES/$DEST_FILE" &&
    chmod 644 "$AUTOSTART_MODULES/$DEST_FILE"
    while [ $# -gt 0 ]; do
        if ! cat "$AUTOSTART_MODULES/$DEST_FILE" | grep -i -P "$1" &> /dev/null; then
            modprobe "$1" &&
            echo "$1" >> "$AUTOSTART_MODULES/$DEST_FILE"             
        fi
        shift
    done    
}
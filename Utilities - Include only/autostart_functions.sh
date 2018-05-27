#!/bin/bash

AUTOSTART_XDG="/etc/xdg/autostart"
AUTOSTART_SYSTEMD="/etc/systemd/system"
AUTOSTART_UDEV="/etc/udev/rules.d"

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

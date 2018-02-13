#!/bin/bash

blacklist_module() {
    local BLACKLIST_MODULE="$1"
    local MODPROBE_BLACKLIST="/etc/modprobe.d/$2"    

    # get ROOT PRIVILEDGES and create the blacklist module and then recreate the initram
    sudo su -c "
    echo 'blacklist $BLACKLIST_MODULE' >> '$MODPROBE_BLACKLIST' &&
    mkinitrd
    "    
}

load_module(){
    local LOAD_MODULE="$1"
    local CONFIG_FILE="/etc/modules-load.d/$2"
    sudo su -c "
    if [ ! -e '$CONFIG_FILE' ]; then
        touch '$CONFIG_FILE' &&
        chown root:root '$CONFIG_FILE' &&
        chmod 644 '$CONFIG_FILE' 
    fi    
    echo '$LOAD_MODULE' >> '$CONFIG_FILE'
    "
}

#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

. "$UTILITIES_INCLUDE/general_functions.sh"
. "$UTILITIES_INCLUDE/cron_functions.sh"
. "$UTILITIES_INCLUDE/autostart_functions.sh"

RESOLV_FILE=/etc/resolv.conf

cpy_unbound(){
    local SOURCE_DIR=$1
    local DEST_DIR=$2
    shift; shift
    for var in "$@"; do
        local ORIGIN_FILE="$SOURCE_DIR/$var"
        local DEST_FILE="$DEST_DIR/$var"
        cp "$ORIGIN_FILE" "$DEST_DIR" &&
        chown root:unbound "$DEST_FILE" &&
        chmod 660 "$DEST_FILE"
    done
}

block_resolv(){    
    chattr -i "$RESOLV_FILE" &&
    echo '
nameserver 127.0.0.1
    ' > "$RESOLV_FILE" &&
    chattr +i "$RESOLV_FILE"
}

zypper -n in -l unbound &&
cpy_unbound "$SCRIPT_DIR" "/etc/unbound/local.d/" "00-local.conf" &&
cpy_unbound "$SCRIPT_DIR" "/etc/unbound/conf.d/" "00-stub-forward.conf" &&
block_resolv &&
systemctl enable unbound &&
systemctl start unbound &&
echo -e '\nUnbound Install - SUCCESS' ||
(
    echo -e '\nUnbound Install - FAILED' 
    exit 1
)

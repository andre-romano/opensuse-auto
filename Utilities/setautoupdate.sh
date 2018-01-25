#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

AUTOUPDATE_SCRIPT=/etc/cron.monthly/autoupdate.sh
AUTOUPDATE_LIST=/etc/autoupdate

# THIS SCRIPT SETS THE AUTO UPDATE FOR SPECIFIC PACKAGES OF THE SYSTEM (LIKE USER APPS AND SOME
# NON CRITICAL PACKAGES)

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

create_file(){
    if [ ! -e "$1" ]; then
        touch "$1"
        chmod 755 "$1"
    fi
}

create_script(){
    if [ ! -e "$1" ]; then
        touch "$1"
        chmod 755 "$1"
        echo "$2" >> "$1"
    fi
}

create_file "$AUTOUPDATE_LIST" &&
create_script "$AUTOUPDATE_SCRIPT" '#!/bin/bash

LIST=$(cat '"$AUTOUPDATE_LIST"' | xargs)
LOG=/var/log/autoupdate.log

echo " " > "$LOG"
echo "AUTO UPDATE ROUTINE  -  $(date)" >> "$LOG"
echo " " >> "$LOG"
zypper -n in -l $LIST >> "$LOG" 2>&1
'
for var in "$@"; do
    if ! grep -q "$var" "$AUTOUPDATE_LIST"; then
        echo "$var" >> "$AUTOUPDATE_LIST"
    fi
done


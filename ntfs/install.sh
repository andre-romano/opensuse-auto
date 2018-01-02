#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#GENERAL CONFIG VARIABLES
INSTALL_DIR="/usr/bin"

cpy_install() {
    for var in "$@"; do
        ORIGIN_FILE="$SCRIPT_DIR/$var"
        DEST_FILE="$INSTALL_DIR/$(basename "$var" .sh)"
        cp "$ORIGIN_FILE" "$DEST_FILE" &&
        chown root:root "$DEST_FILE" &&
        chmod 755 "$DEST_FILE"
    done
}

create_cron_job(){
    RUN_SCRIPT_DIR=$1
    RUN_SCRIPT=$2
    CRON_SCHEDULE=$3

    CRON_ENTRY="$CRON_SCHEDULE bash $RUN_SCRIPT_DIR/$RUN_SCRIPT"

    # if entry DOES NOT exists in cron, create it
    crontab -l | grep "$CRON_ENTRY" &> /dev/null || (
        echo -e "\tCreating cron entry ...\n"
        crontab -l | { cat; echo "$CRON_ENTRY"; } | crontab -
    )

    if [ $? -eq 0 ]; then
        echo -e "\tINSTALLED - cron job $RUN_SCRIPT - SCHEDULE: $CRON_SCHEDULE\n"
    else
        exit 1
    fi
}

cpy_install ntfs_mount.sh &&
cp "$SCRIPT_DIR/ntfs_to_mount.conf" /etc &&
create_cron_job "$INSTALL_DIR" ntfs_mount.sh "@reboot" &&
echo -e "Installation of NTFS automounter - SUCCESSFUL" || (
    echo -e "Installation of NTFS automounter - FAILED"
    exit 1
)

#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1


create_cron_job(){
    RUN_SCRIPT_DIR=$1
    RUN_SCRIPT=$2
    CRON_SCHEDULE=$3
    
    CRON_ENTRY="$CRON_SCHEDULE bash $RUN_SCRIPT_DIR/$RUN_SCRIPT"    
    
    cp "$SCRIPT_DIR/$RUN_SCRIPT" "$RUN_SCRIPT_DIR/" &&
    chmod +rx "$RUN_SCRIPT_DIR/$RUN_SCRIPT" &&
            
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

create_cron_job "/etc" "wifi_power_mgr.sh" "@reboot"




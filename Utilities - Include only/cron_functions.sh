#!/bin/bash

create_cron_job(){
    local ACTUAL_SCRIPT_DIR=$1
    local RUN_SCRIPT_DIR=$2
    local RUN_SCRIPT=$3
    local CRON_SCHEDULE=$4
    
    local CRON_ENTRY="$CRON_SCHEDULE bash $RUN_SCRIPT_DIR/$RUN_SCRIPT"    
    
    sudo su -c "
    cp '$ACTUAL_SCRIPT_DIR/$RUN_SCRIPT' '$RUN_SCRIPT_DIR/' &&
    chmod +rx '$RUN_SCRIPT_DIR/$RUN_SCRIPT' &&
            
    # if entry DOES NOT exists in cron, create it
    crontab -l | grep '$CRON_ENTRY' &> /dev/null || (
        echo -e '\tCreating cron entry ...\n'
        crontab -l | { cat; echo '$CRON_ENTRY'; } | crontab - 
    )
    "
    
    if [ $? -eq 0 ]; then
        echo -e "\tINSTALLED - cron job $RUN_SCRIPT - SCHEDULE: $CRON_SCHEDULE\n"
    else
        exit 1
    fi
}
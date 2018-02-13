#!/bin/bash

get_pulse_user(){
    # allow time to PulseAudio daemon to startup
    local WAIT_TIME=6 # WAIT TIME IN SECS
    local TIMEOUT=600 # TIMEOUT OF THE DAEMON START PROCESS
    local MAX_COUNT=$((TIMEOUT / WAIT_TIME))
    local COUNT=0
    while [ -z "$PULSE_USER" ]; do    
        sleep $WAIT_TIME        
        COUNT=$((COUNT + 1))
        if [ "$COUNT" -eq "$MAX_COUNT" ]; then
            echo -e '\n\tERROR: Timeout - PulseAudio has not started ...\n' 1>&2
            exit 1
        fi
        local PULSE_USER="$(ps -ef | grep pulseaudio | grep -v grep | tr -s ' ' | cut -d' ' -f1)"
    done    
    echo $PULSE_USER | tr -s ' '
}

check_port_connected(){
    local PULSE_USER_UID="$1"

    # WE KNOW PULSEAUDIO IS RUNNING AND WE ALSO KNOW its user name, now lets define where 
    # is the process .PID file    
    export PULSE_RUNTIME_PATH="/var/run/user/$PULSE_USER_UID/pulse" 

    # check if the headphones are connected right now
    local OUTPUT_PORT='analog-output-headphones'
    local PORT_CONNECTED=$(pacmd list-cards | awk '{print tolower($0)}' | grep "$OUTPUT_PORT" | grep -o 'available: [a-zA-Z]*' | cut -d' ' -f2)

    # if the PORT IS CONNECTED then SET IT AS THE CURRENT OUTPUT PORT ( this change is not 
    # persistent, but since this script runs at every boot, then if the port is connected
    # during boot time, then it will become the default output port )
    if [ "$PORT_CONNECTED" == 'yes' ]; then
        pacmd set-sink-port 1 "$OUTPUT_PORT"
    fi
}


for user in $(get_pulse_user); do
    check_port_connected "$(id -u "$user")"
done





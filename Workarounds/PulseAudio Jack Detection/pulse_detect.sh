#!/bin/bash
SU=/usr/bin/su
PACMD=/usr/bin/pacmd

PULSEAUDIO_RUNNING=0

while [ $PULSEAUDIO_RUNNING -eq 0 ]; do    
    sleep 3
    PULSE_USERS="$(ps -ef | grep pulseaudio | grep -v grep | tr -s ' ' | cut -d' ' -f1 | tr -s ' ' | xargs)"
    for user in $PULSE_USERS; do
        PULSE_USER_UID=$(id -u "$user")

        # WE KNOW PULSEAUDIO IS RUNNING AND WE ALSO KNOW its user name, now lets define where 
        # is the process .PID file    
        export PULSE_RUNTIME_PATH="/var/run/user/$PULSE_USER_UID/pulse"

        # check if the headphones are connected right now
        OUTPUT_PORT='analog-output-headphones'
        PORT_CONNECTED=$($PACMD list-cards | grep -i "$OUTPUT_PORT" | grep -i -o -P 'available: [a-zA-Z]*' | cut -d' ' -f2)

        # if the PORT IS CONNECTED then SET IT AS THE CURRENT OUTPUT PORT ( this change is not 
        # persistent, but since this script runs at every boot, then if the port is connected
        # during boot time, then it will become the default output port )
        if [ "$PORT_CONNECTED" == 'yes' ]; then
            $PACMD set-sink-port 1 "$OUTPUT_PORT"
            echo ' '
            echo 'Headphones have been set'            
            echo ' '
        else
            echo ' '
            echo 'No headphones detected on boot'
            echo ' '
        fi
        chown "$user" -R "$PULSE_RUNTIME_PATH"
        PULSEAUDIO_RUNNING=1
    done    
done







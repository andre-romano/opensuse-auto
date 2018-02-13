#!/bin/bash

# allow time to PulseAudio daemon and other required services to startup
sleep 5

# check if the headphones are connected right now
OUTPUT_PORT='analog-output-headphones'
PORT_CONNECTED=$(pacmd list-cards | awk '{print tolower($0)}' | grep "$OUTPUT_PORT" | grep -o 'available: [a-zA-Z]*' | cut -d' ' -f2)

# if the PORT IS CONNECTED then SET IT AS THE CURRENT OUTPUT PORT ( this change is not 
# persistent, but since this script runs at every boot, then if the port is connected
# during boot time, then it will become the default output port )
if [ "$PORT_CONNECTED" == 'yes' ]; then
    pacmd set-sink-port 1 "$OUTPUT_PORT"
fi
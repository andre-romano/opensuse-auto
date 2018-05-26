#!/bin/bash
STATUS=0

set_cpu_governor(){
    local CPUPOWER=/usr/bin/cpupower
    local GOVERNOR=performance
    $CPUPOWER frequency-set -g $GOVERNOR &&
    echo "CPU governor set to \"$GOVERNOR\"" ||
    (
        echo "ERROR: Could not set CPU governor to $GOVERNOR"
        return 1
    )
}

set_wifi_performance(){
    local IWCONFIG=/usr/sbin/iwconfig
    local WIFI_IFACES=$($IWCONFIG 2>&1 | grep -v 'no wireless' | xargs | cut -d' ' -f1)   
    for wifi in $WIFI_IFACES; do
        $IWCONFIG $wifi power off
    done
}

set_hdd_performance(){    
    for BLOCK in /sys/block/*; do
        BLOCK=$(basename "$BLOCK")        
        if ! hdparm -B /dev/$BLOCK 2>&1 | grep 'not supported' &> /dev/null; then
            hdparm -B 255 /dev/$BLOCK    
        fi
        if ! hdparm -M /dev/$BLOCK 2>&1 | grep 'not supported' &> /dev/null; then
            hdparm -M 254 /dev/$BLOCK
        fi
        hdparm -S 0 /dev/$BLOCK
    done
}

set_cpu_governor
[ $? -ne 0 ] && STATUS=$(($STATUS + 1))
set_wifi_performance
[ $? -ne 0 ] && STATUS=$(($STATUS + 1))
set_hdd_performance
[ $? -ne 0 ] && STATUS=$(($STATUS + 1))

if [ $STATUS -eq 0 ]; then
    echo ' '
    echo 'Tuned System Performance - SUCCESS'
    echo ' '
else
    echo ' '
    echo 'Tuned System Performance - FAILED'
    echo ' '
    exit 1
fi


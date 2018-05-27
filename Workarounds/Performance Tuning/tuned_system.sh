#!/bin/bash
IWCONFIG=/usr/sbin/iwconfig
HDDPARM=/usr/sbin/hdparm

STATUS=0

# CPU_GOVERNOR = powersave OR performance                         | CPU governor
# IW_POWER = off OR on                                            | wireless power mgr
# HDD_APM = 1-127 favor power savings, 128-254 favor performance  | HDD Advanced power mgr
# HDD_ACCOUSTIC = 128 for quiet, 254 for fast                     | HDD Accoustic Mgr 
# HDD_TIMEOUT = 0 for disabled                                    | HDD wakeup timeout
TUNED_PROFILE=$1
shift

case "$TUNED_PROFILE" in
powersave)
    CPU_GOVERNOR=powersave
    IW_POWER=on
    HDD_APM=128
    HDD_ACCOUSTIC=128
    HDD_TIMEOUT=0
    ;;
balance)    
    CPU_GOVERNOR=powersave  
    IW_POWER=off
    HDD_APM=128
    HDD_ACCOUSTIC=128
    HDD_TIMEOUT=0
    ;;
*)    
    CPU_GOVERNOR=performance  
    IW_POWER=off
    HDD_APM=254
    HDD_ACCOUSTIC=254
    HDD_TIMEOUT=0
    ;;
esac

set_cpu_governor(){        
    for var in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do 
        echo "$CPU_GOVERNOR" > "$var" &&
        echo " CPU $var:" &&
        echo "    GOVERNOR = $CPU_GOVERNOR" &&           
        echo " " ||
        (            
            echo " ERROR: Cannot set CPU GOVERNOR to $CPU_GOVERNOR"             
            STATUS=$(($STATUS + 1))
        )
    done
}

set_wifi_performance(){    
    local WIFI_IFACES=$($IWCONFIG 2>&1 | grep -v 'no wireless' | xargs | cut -d' ' -f1)   
    for wifi in $WIFI_IFACES; do
        $IWCONFIG $wifi power $IW_POWER &&
        echo " WiFi Iface $wifi:" &&
        echo "    POWER = $IW_POWER" &&           
        echo " " ||
        (            
            echo " ERROR: Cannot set WiFi Iface $wifi power = $IW_POWER"             
            STATUS=$(($STATUS + 1))
        )        
    done
}

set_hdd_performance(){    
    for BLOCK in /sys/block/*; do
        BLOCK=/dev/$(basename "$BLOCK")        
        echo "  Device $BLOCK:  "
        if ! $HDDPARM -B $BLOCK 2>&1 | grep 'not supported' &> /dev/null; then
            $HDDPARM -B $HDD_APM $BLOCK &&
            echo ' ' && 
            echo " APM = $HDD_APM" ||
            (            
                echo " ERROR: Cannot set APM = $HDD_APM"             
                STATUS=$(($STATUS + 1))
            )            
        fi
        if ! $HDDPARM -M $BLOCK 2>&1 | grep 'not supported' &> /dev/null; then
            $HDDPARM -M $HDD_ACCOUSTIC $BLOCK &&            
            echo " Accoustic = $HDD_ACCOUSTIC" ||
            (            
                echo " ERROR: Cannot set Accoustic = $HDD_APM"             
                STATUS=$(($STATUS + 1))
            )           
        fi
        $HDDPARM -S $HDD_TIMEOUT $BLOCK &&
        echo " Timeout = $HDD_ACCOUSTIC" &&
        echo ' ' ||
        (            
            echo " ERROR: Cannot set Timeout = $HDD_APM"             
            STATUS=$(($STATUS + 1))
        )       
    done
}

set_cpu_governor
set_wifi_performance
set_hdd_performance

if [ $STATUS -eq 0 ]; then
    echo ' '
    echo "Tuned System for $TUNED_PROFILE - SUCCESS"
    echo ' '
else
    echo ' '
    echo "Tuned System for $TUNED_PROFILE - FAILED"
    echo ' '
    exit 1
fi


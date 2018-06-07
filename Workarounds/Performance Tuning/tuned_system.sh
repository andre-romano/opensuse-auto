#!/bin/bash
IWCONFIG=/usr/sbin/iwconfig
HDDPARM=/usr/sbin/hdparm
RFKILL=/usr/sbin/rfkill

STATUS=0

# CPU_GOVERNOR = powersave OR performance                         | CPU governor
# IW_POWER = off OR on                                            | wireless power mgr
# IW_RTS = off OR [250-1600]                                      | wireless min packet to start handshake RTS
# IW_FRAG = off OR [250-1600]                                     | wireless min packet to start handshake RTS
# HDD_APM = 1-127 favor power savings, 128-254 favor performance  | HDD Advanced power mgr
# HDD_ACCOUSTIC = 128 for quiet, 254 for fast                     | HDD Accoustic Mgr 
# HDD_TIMEOUT = 0 for disabled                                    | HDD wakeup timeout
TUNED_PROFILE=$1
shift

# default parameters (invariant of profile)
IW_RTS=600
IW_FRAG=600
HDD_TIMEOUT=0

case "$TUNED_PROFILE" in
powersave)
    CPU_GOVERNOR=powersave
    IW_POWER=on        
    HDD_APM=128
    HDD_ACCOUSTIC=128    
    ;;
balance)    
    CPU_GOVERNOR=powersave          
    IW_POWER=off    
    HDD_APM=128
    HDD_ACCOUSTIC=128        
    ;;
*)       
    CPU_GOVERNOR=performance  
    IW_POWER=off    
    HDD_APM=254
    HDD_ACCOUSTIC=254
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
        $IWCONFIG $wifi power $IW_POWER 
        $IWCONFIG $wifi rts $IW_RTS
        $IWCONFIG $wifi frag $IW_FRAG
        echo " WiFi Iface $wifi:" 
        echo "    POWER MGR = $(iwconfig $wifi | grep -o -P 'Power Management:[A-Za-z]*' | cut -d':' -f2)" 
        echo "    RTS       = $(iwconfig $wifi | grep -o -P 'RTS thr=[0-9]* B' | cut -d'=' -f2)"            
        echo "    FRAG      = $(iwconfig $wifi | grep -o -P 'Fragment thr=[0-9]* B' | cut -d'=' -f2)"            
        echo " "         
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

rfkill_unblock(){
    "$RFKILL" unblock all &&
    echo ' ' &&
    echo " RFKILL Unblocked All" &&
    echo ' ' ||
    (            
        echo " ERROR: RFKILL Could not Unblock All Devices"             
        STATUS=$(($STATUS + 1))
    )  
}


set_cpu_governor 2>&1
set_wifi_performance 2>&1
set_hdd_performance 2>&1
rfkill_unblock 2>&1

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


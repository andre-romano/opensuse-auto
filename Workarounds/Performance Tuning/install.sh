#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/../.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

. "$UTILITIES_INCLUDE/general_functions.sh"
. "$UTILITIES_INCLUDE/cron_functions.sh"
. "$UTILITIES_INCLUDE/autostart_functions.sh"

sysctl_tuning(){
    local SYSCTL_CONF=/etc/sysctl.d/99-tweaks.conf
    echo '
# VIRTUAL MEMORY
vm.dirty_background_bytes=104857600
vm.dirty_ratio=10
vm.swappiness=20
vm.vfs_cache_pressure=50

# KERNEL
kernel.numa_balancing=0
kernel.sched_min_granularity_ns=10000000
kernel.sched_migration_cost_ns=5000000

# NETWORK 
net.core.busy_read=50
net.core.busy_poll=50
net.ipv4.tcp_fastopen=3
    ' > "$SYSCTL_CONF" &&
    sysctl --system &&
    echo -e '\n\tTweaks applied with SUCCESS\n'
}

# returns true (== 0) if its an SSD
is_ssd(){    
    if [ $(cat "/sys/block/$1/queue/rotational") -eq 0 ]; then
        # this value == 0 implies an SSD
        return 0
    else
        # this value == 1 implies a rotationary mechanical unit (HDD, TAPE, CD/DVD)
        return 1
    fi
}

get_device(){
    local DEV_UUID=$(echo $1 | tr -s ' ' | cut -d' ' -f1)
    if echo $DEV_UUID | grep -q 'UUID'; then
        local UUID=$(echo $DEV_UUID | cut -d'=' -f2)
        local DEV=$(blkid | grep $UUID | cut -d':' -f1)        
    else
        local DEV=$DEV_UUID
    fi
    local DEV=$(echo $DEV | sed -e 's@/dev/@@g')
    echo $DEV
}

change_to_tmpfs(){
    local MOUNTPOINT=$1
    local SIZE=$2
    local REPLACE="tmpfs  $MOUNTPOINT  tmpfs  nodev,nosuid,relatime,size=$SIZE  0  0"
    # perform the changes into the file fstab
    if grep -P " $MOUNTPOINT " /etc/fstab &> /dev/null; then
        # perform the changes into the file fstab
        sed -i -e "s@.*$MOUNTPOINT.*@$REPLACE@" /etc/fstab
    else
        echo "$REPLACE" >> /etc/fstab
    fi
}

tuning_filesystems(){    
    local FS=ext[234]
    local APPEND_OPTIONS="noatime commit=30"
    local APPEND_OPTIONS_SSD="discard"
    grep $FS /etc/fstab | while read -r line; do        
        # check for ssd
        local DEV=$(get_device "$line" | sed -e 's@[0-9]@@g')
        if is_ssd "$DEV" && [ -n "$APPEND_OPTIONS_SSD" ]; then 
            APPEND_OPTIONS="$APPEND_OPTIONS $APPEND_OPTIONS_SSD"
        fi
        # 
        local REPLACE="$line"
        # get all options and filter them out of append_options 
        local OPTIONS=$(echo $line | tr -s " " | cut -d' ' -f4 | tr ',' ' ')        
        for op in $OPTIONS; do        
            APPEND_OPTIONS=$(echo $APPEND_OPTIONS | sed -e "s@$op@@" | tr -s ' ' | xargs)
        done
        # restore options back into comma separation
        APPEND_OPTIONS=$(echo "$OPTIONS $APPEND_OPTIONS")
        OPTIONS=$(echo $OPTIONS | tr ' ' ',')
        APPEND_OPTIONS=$(echo $APPEND_OPTIONS | tr -s ' ' | tr ' ' ',' | sed -e 's@[,]\{2,\}@@g')
        # replace the options in the variable
        REPLACE=$(echo $REPLACE | sed -e "s/$OPTIONS/$APPEND_OPTIONS/")
        # perform the changes into the file fstab
        sed -i -e "s@$line@$REPLACE@" /etc/fstab
    done
    change_to_tmpfs '/tmp' '50M' &&
    change_to_tmpfs '/var/log' '512M'
}

sysctl_tuning &&
tuning_filesystems &&
install_service "tuned_perf.service" "tuned_perf.sh" "/etc"





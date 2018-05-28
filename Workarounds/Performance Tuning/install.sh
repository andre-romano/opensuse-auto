#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/../.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

. "$UTILITIES_INCLUDE/general_functions.sh"
. "$UTILITIES_INCLUDE/cron_functions.sh"
. "$UTILITIES_INCLUDE/autostart_functions.sh"

UNBOUND_DNS="$OPENSUSE_AUTO/Unbound/install.sh"

sysctl_tuning(){
    local SYSCTL_CONF=/etc/sysctl.d/99-tweaks.conf
    echo '
# VIRTUAL MEMORY
vm.dirty_background_bytes=52428800
vm.dirty_bytes=104857600
vm.swappiness=20
vm.vfs_cache_pressure=50

# KERNEL
kernel.hung_task_timeout_secs = 0
kernel.numa_balancing=0
kernel.sched_min_granularity_ns=10000000
kernel.sched_migration_cost_ns=5000000
kernel.msgmax = 65536
kernel.msgmnb = 65536
kernel.shmmax = 0xffffffffffffffff
kernel.shmall = 0x0fffffffffffff00

# NETWORK 
net.core.busy_read=50
net.core.busy_poll=50
net.core.netdev_max_backlog = 32768
net.core.optmem_max = 32768
net.core.somaxconn = 512

net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192

# speed increase, latency low
net.ipv4.tcp_mtu_probing=0
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_keepalive_time=60
net.ipv4.tcp_keepalive_intvl=10
net.ipv4.tcp_keepalive_probes=6

# harden the kernel against common attacks
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_rfc1337=1
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.rp_filter=1
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.icmp_ignore_bogus_error_responses=1

# no redirects (desktop machine should not do this)
net.ipv4.conf.default.send_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.accept_redirects=0
net.ipv6.conf.default.accept_redirects=0
net.ipv6.conf.all.accept_redirects=0
    ' > "$SYSCTL_CONF" &&
    sysctl --system &&
    echo -e '\nSysctl Tweaks - SUCCESS' ||
    (
        echo -e '\nSysctl Tweaks - FAILED'
        return 1
    )
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
    local STATUS=0
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
        STATUS=$(($STATUS + $?))
    done
    change_to_tmpfs '/tmp' '50M' &&
    change_to_tmpfs '/var/log' '512M' 
    STATUS=$(($STATUS + $?))
    [ $STATUS -eq 0 ] &&
    echo -e '\nFilesystems Tunning - SUCCESS' ||
    (
        echo -e '\nFilesystems Tunning - FAILED' 
        return 1        
    )
}

install_power_systemd(){
    install_systemd_target "ac.target" "battery.target" &&
    cpy_install "$SCRIPT_DIR" "/etc" "tuned_system.sh" &&
    install_systemd_service "tuned_performance.service" "tuned_balance.service" "tuned_powersave.service" &&
    install_udev_rules "00_power.rules" &&
    echo -e '\nSystemd Power Optimization - SUCCESS' ||
    (
        echo -e '\nSystemd Power Optimization - FAILED' 
        return 1  
    )    
}

zypper -n in -l hdparm cpupower wireless-tools net-tools procps &&
sysctl_tuning &&
tuning_filesystems &&
install_power_systemd &&
bash "$UNBOUND_DNS" &&
echo ' ' &&
echo ' Tuned Systemd - SUCCESS (ALL OPERATIONS - OK) ' &&
echo ' ' ||
(
    echo ' ' 
    echo ' Tuned Systemd - FAILED ' 
    echo ' '
    exit 1
)






#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

SCHEDULER_HDD=cfq
SCHEDULER_SSD=cfq

set_io_scheduler(){
    local DEVICE=$1
    local IS_HDD=$2    
    if [ "$IS_HDD" -eq 1 ]; then
        local SCHEDULER="$SCHEDULER_HDD"
    else
        local SCHEDULER="$SCHEDULER_SSD"        
    fi
    echo "$SCHEDULER" > "$DEVICE/queue/scheduler"
    # tuning scheduler for the machine
    case "$SCHEDULER" in
    noop)
        # theres no settings for this scheduler mode
        ;;
    deadline)
        # default is 500ms read deadline - < 500 improve read performance in regard to write performance
        echo 500 > "$DEVICE/queue/iosched/read_expire"        
        # default is 2 reads for each write operation deadline - > 2 improves read in regard to write performance
        echo 2 > "$DEVICE/queue/iosched/writes_starved"                
        # default is 16 batch operations to be performed - < 16 reduces latency and throughput
        echo 16 > "$DEVICE/queue/iosched/fifo_batch"  
        ;;    
    cfq)                    
        # set special settings for SSDs / HDDs
        if [ "$IS_HDD" -eq 0 ]; then
            # disable queue seek idle (SSD have no mechanical parts
            # and can read/write data in parallel, so theres no seek time to optimize)
            echo 0 > "$DEVICE/queue/iosched/slice_idle"
        else
            # special settings for HDDs
            echo 1 > "$DEVICE/queue/iosched/slice_idle"            
        fi        
        ;;
    *) ;;
    esac
}

sleep 3

# change IO scheduler to deadline to improve latency
for device in /sys/block/*; do
    local is_hdd=$(cat "$device/queue/rotational")
    set_io_scheduler "$device" "$is_hdd"
done


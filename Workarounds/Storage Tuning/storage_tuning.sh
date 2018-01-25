#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

SCHEDULER_HDD=cfq
SCHEDULER_SSD=noop

set_io_scheduler(){
    DEVICE=$1
    SCHEDULER=$2
    echo "$SCHEDULER" > "$DEVICE/queue/scheduler"
    # tuning scheduler for the machine
    case "$SCHEDULER" in
    deadline)
        # default is 500ms read deadline - < 500 improve read performance in regard to write performance
        echo 100 > "$DEVICE/queue/iosched/read_expire"        
        # default is 2 reads for each write operation deadline - > 2 improves read in regard to write performance
        echo 4 > "$DEVICE/queue/iosched/writes_starved"                
        # default is 16 batch operations to be performed - < 16 reduces latency and throughput
        echo 16 > "$DEVICE/queue/iosched/fifo_batch"  
        ;;
    noop)
        # theres no settings for this scheduler mode
        ;;
    cfq)
        # leave the default settings
        ;;
    *) ;;
    esac
}

sleep 3

# change IO scheduler to deadline to improve latency
for device in /sys/block/*; do
    if [ $(cat "$device/queue/rotational") -eq 0 ]; then
        # this value == 0 implies an SSD
        scheduler=$SCHEDULER_SSD
    else
        # this value == 1 implies a rotationary mechanical unit (HDD, TAPE, CD/DVD)
        scheduler=$SCHEDULER_HDD
    fi
    set_io_scheduler "$device" "$scheduler"
done


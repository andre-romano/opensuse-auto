#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/../.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

. "$UTILITIES_INCLUDE/general_functions.sh"
. "$UTILITIES_INCLUDE/cron_functions.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

get_device(){
    DEV_UUID=$(echo $1 | tr -s ' ' | cut -d' ' -f1)
    if echo $DEV_UUID | grep -q 'UUID'; then
        UUID=$(echo $DEV_UUID | cut -d'=' -f2)
        DEV=$(blkid | grep $UUID | cut -d':' -f1)        
    else
        DEV=$DEV_UUID
    fi
    DEV=$(echo $DEV | sed -e 's@/dev/@@g')
    echo $DEV
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

tuning_filesystems(){    
    FS=ext[234]
    APPEND_OPTIONS="noatime commit=30"
    APPEND_OPTIONS_SSD="discard"
    grep $FS /etc/fstab | while read -r line; do        
        # check for ssd
        DEV=$(get_device "$line" | sed -e 's@[0-9]@@g')
        if is_ssd "$DEV" && [ -n "$APPEND_OPTIONS_SSD" ]; then 
            APPEND_OPTIONS="$APPEND_OPTIONS $APPEND_OPTIONS_SSD"
        fi
        # 
        REPLACE="$line"
        # get all options and filter them out of append_options 
        OPTIONS=$(echo $line | tr -s " " | cut -d' ' -f4 | tr ',' ' ')        
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
}

# this makes the filesystems mounted at boot in /etc/fstab to run with no_atime
tuning_filesystems &&

# THIS SCRIPTS INSTALLS THE FOLLOWING SCRIPT INSIDE THE SYSTEM SO THAT IT RUNS
# PERIODICALLY WITH CRON (ACCORDING TO THE SCHEDULE BELOW)
create_cron_job "$SCRIPT_DIR" "/etc" "storage_tuning.sh" "@reboot" 

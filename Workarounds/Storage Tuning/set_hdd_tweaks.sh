#!/bin/bash
sleep 60
for BLOCK in /sys/block/*; do
    BLOCK=$(basename "$BLOCK")
    # NO POWER MGR
    hdparm -B 255 /dev/$BLOCK
    # NO ACCOUSTIC MGR
    hdparm -M 254 /dev/$BLOCK
done

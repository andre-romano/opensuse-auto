#!/bin/bash

IWCONFIG=/usr/sbin/iwconfig

sleep 5
WIFI_IFACES=$($IWCONFIG 2>&1 | grep -v 'no wireless' | xargs | cut -d' ' -f1)   

# disable power management
for wifi in $WIFI_IFACES; do
    $IWCONFIG $wifi power off
done


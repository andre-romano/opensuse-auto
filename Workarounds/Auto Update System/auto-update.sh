#!/bin/bash
echo -e '\tStarting system auto update ...\n'
zypper ref &&
zypper -n up -l &&
echo -e '\tAuto update - SUCCESS\n' ||
(
    echo -e '\tAuto update - FAILED\n'
    exit 1
    )

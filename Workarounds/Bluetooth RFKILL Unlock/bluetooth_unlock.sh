#!/bin/bash
rfkill unblock bluetooth &&
hciconfig hci0 up

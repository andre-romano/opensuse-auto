#!/bin/bash
OS_FILE="/etc/os-release"
VERSION="$(cat "$OS_FILE" | grep VERSION_ID | awk -F \" '{print$2}')"
TYPE="$(cat "$OS_FILE" | grep NAME | head -n 1 | awk -F \" '{print $2}' | awk -F \  '{print $2}')"
#GET OPENSUSE VERSION
if [ -n "$TYPE" ]; then #opensuse Leap or other variant
    echo $TYPE"_"$VERSION
else
    echo $VERSION
fi

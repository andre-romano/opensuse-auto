#!/bin/bash

get_extension(){
    FILENAME=$(basename "$1")
    echo "${FILENAME##*.}"
}

get_filename(){
    FILENAME=$(basename "$1")
    echo "${FILENAME%.*}"
}

cpy_install(){
    local SOURCE_DIR=$1
    local DEST_DIR=$2
    shift; shift
    for var in "$@"; do
        local ORIGIN_FILE="$SOURCE_DIR/$var"
        local DEST_FILE="$DEST_DIR/$var"
        cp "$ORIGIN_FILE" "$DEST_DIR" &&
        chown root:root "$DEST_FILE" &&
        chmod 755 "$DEST_FILE"
    done
}

cpy_install_no_ext(){
    local SOURCE_DIR=$1
    local DEST_DIR=$2
    shift; shift
    cpy_install "$1" "$2" $@
    for var in "$@"; do
        local FILENAME=$(get_filename "$var")
        mv "$DEST_DIR/$var" "$DEST_DIR/$FILENAME"
    done    
}

display_result(){
    local STATUS=$?
    local MSG=$1
    if [ "$STATUS" -eq 0 ]; then
        echo -e "\t$MSG - SUCCESS\n"
    else
        echo -e "\t$MSG - FAILED\n"
        exit 1
    fi     
}
#!/bin/bash

get_gpg(){
    local URL=$1
    local TEMP=$(echo "$(basename "$1")_temp")
    echo -e "\n\tGetting GPG Key for $URL (this will take a couple of secs) ...\n"
    wget -O "$TEMP" "$URL" &&
    rpm -import "$TEMP" 
    rm -f "$TEMP" &> /dev/null
}

add_repo(){
    local NAME=$1
    local URL=$2
    local PRIORITY=$3
    shift; shift; shift
    echo -e "\tAdding repository... \n" &&
    sudo zypper -n --gpg-auto-import-keys $@ ar -p "$PRIORITY" -f \
    "$URL" "$NAME" &&
    sudo zypper -n --gpg-auto-import-keys $@ refresh
}

verify_add_repo(){
    local REPO_NAME=$1
    local URL=$2
    local PRIORITY=$3
    shift; shift; shift
    sudo zypper lr | grep "$REPO_NAME" > /dev/null &&    
    echo -e '\n\tRepository $REPO_NAME already in the system repostiories, no changes done ...\n' ||        
    add_repo "$REPO_NAME" "$URL" "$PRIORITY" $@    
} 

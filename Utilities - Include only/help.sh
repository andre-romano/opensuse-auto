#!/bin/bash

show_copywrite() {
    echo -e "\nCopyright © 2017 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    local HELP_TITLE="$1"
    local HELP_DESCRIPTION="$2"
    local HELP_USAGE="$3"
    shift; shift; shift
    show_copywrite
    echo -e "\t$HELP_TITLE:" 
    if [ -n "$HELP_DESCRIPTION" ]; then
        echo -e "$HELP_DESCRIPTION." 
    fi
    echo -e "\n\tUsage:\n\t$HELP_USAGE\n"
    if [ -n "$@" ]; then
        echo -e "\tOPTION\tDESCRIPTION"
        for OPTION in $@; do
            echo -e "\t$OPTION"        
        done
    fi    
    echo ' '
    exit 0
}
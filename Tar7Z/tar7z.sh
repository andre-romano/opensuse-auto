#!/bin/bash
#usage: tar7z source destination [options]

SOURCE=$1
DESTINATION=$2
ACTION=$3
shift
shift
shift
OPTIONS_7Z=$@

show_help() {
    echo -e "Tar7Z - Preserve permissions, archive and compress/extract with 7z\n"
    echo -e "Usage: usage: tar7z source destination action [7z_options]\n"
    echo -e "ACTION:"
    echo -e "-c compress"
    echo -e "-x extract"
    EXIT_CODE=$1
    if [ -z "$EXIT_CODE" ]; then EXIT_CODE=0; fi
    exit $EXIT_CODE
}

if [ "$SOURCE" = "--help" ] || [ "$SOURCE" = "-help" ] || [ "$SOURCE" = "-h" ]; then
    show_help 0
fi

if [ "$ACTION" = "-c" ]; then
    tar -cvpf - $SOURCE | 7z a $OPTIONS_7Z -si "$DESTINATION"
elif [ "$ACTION" = "-x" ]; then
    7z x -so "$SOURCE" | tar xvpf - -C "$DESTINATION"
else
    show_help 1
fi

#!/bin/bash

# set default variables
#
AUDIO_CODEC='libmp3lame'
AUDIO_ARGS_SD='-cutoff:a 20000 -q:a 4'
AUDIO_ARGS_HD='-cutoff:a 20000 -q:a 2'
AUDIO_ARGS=$AUDIO_ARGS_SD

#set default control variables
SET_REMOVE=0 # 1 to remove file after convertion
SET_QUALITY=0 # 1 when we should read quality
STATUS=0 # no errors in the convertion operation

# set user options
REMOVE=-r
QUALITY=-q

#colors and fancy things
bold=$(tput bold)
normal=$(tput sgr0)

Black=$(tput setaf 0)
Red=$(tput setaf 1)
Green=$(tput setaf 2)
Yellow=$(tput setaf 3)
Blue=$(tput setaf 4)
Magenta=$(tput setaf 5)
Cyan=$(tput setaf 6)
White=$(tput setaf 7)

FancyX='\342\234\227'
Checkmark='\342\234\223'

# copywrite here
show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

# help here
show_help() {
    show_copywrite "FFMPEG Convert to MP3"
    echo -e "\n\tUsage: mp3_encode [options] file1 [file2 [...]]\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\t$REMOVE\tRemove old file when convertion is done"
    echo -e "\t$QUALITY\tDefine quality of the output (sd, hd). Default is sd"
    echo -e "\n\tEXAMPLES"
    echo -e "# create a file with SD quality"
    echo -e "mp3_encode -q sd file1.wmv\n"
    echo -e "# create a file with HD quality and remove the original file"
    echo -e "mp3_encode -r -q sd file1.wmv"
    echo -e "\n" ; exit 0
}

# indicate that an error happened
flag_error(){
    MSG=$1
    FILE=$2
    FILE_DEST=$3
    # indicate error
    STATUS=1
    # clean temp files
    rm "$FILE_DEST" 2> /dev/null
    # print result
    echo -e "\n\t${bold}${Red}"$(python -c "print \"$FancyX $MSG - $FILE\"")"\n${normal}${White}"
}

convert_file(){
    # FILE INPUT
    FULL_FILENAME=$1
    DIR=$(dirname "$FULL_FILENAME")
    FILENAME=$(basename "$FULL_FILENAME")
    EXT="${FILENAME##*.}"
    FILENAME="${FILENAME%.*}"
    # DESTINATION OF THE FILE
    FULL_DEST_FILENAME="$DIR/$FILENAME.mp3"

    # encode high quality sound
    ffmpeg -i "$FULL_FILENAME" -acodec "$AUDIO_CODEC" $AUDIO_ARGS "$FULL_DEST_FILENAME"

    # remove file once finished
    if [ $? -eq 0 ]; then
        # remove file if user requested it
        if [ "$SET_REMOVE" -eq 1 ]; then rm "$FULL_FILENAME"; fi
        # print result
        [ $? -eq 0 ] && echo -e "\n\t${bold}${Green}"$(python -c "print \"$Checkmark Convertion SUCCESS - $FULL_FILENAME\"")"\n${normal}${White}"
    else
        flag_error 'Convertion FAILED' "$FULL_FILENAME" "$FULL_DEST_FILENAME"
    fi
}

# display help if user requested it
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then show_help; fi

# read options here
for var in "$@"; do
    case "$var" in
    "$REMOVE")
        SET_REMOVE=1
        ;;
    "$QUALITY")
        SET_QUALITY=1
        ;;
    *)
        if [ "$SET_QUALITY" -eq 1 ]; then
            SET_QUALITY=0
            if [ "$var" == "sd" ]; then
                AUDIO_ARGS=$AUDIO_ARGS_SD
            elif [ "$var" == "hd" ]; then
                AUDIO_ARGS=$AUDIO_ARGS_HD
            fi
        else # $var is a file, process it
            convert_file "$var"
        fi
        ;;
    esac
done

# check for general list errors
if [ "$STATUS" -eq 0 ]; then
    echo -e "\n\t${bold}${Green}"$(python -c "print \"$Checkmark Generate Convertion SUCCESS - All files converted sucessfully\"")"\n${normal}${White}"
else
    echo -e "\n\t${bold}${Red}"$(python -c "print \"$FancyX Convertion FAILED - Some files could not be converted, check log for details\"")"\n${normal}${White}"
    exit 1
fi


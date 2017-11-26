#!/bin/bash

# verify if the required variables that specify the output format are defined

if  [ -z "$VIDEO_CODEC" ] ||
    [ -z "$VIDEO_ARGS_SD" ] ||
    [ -z "$VIDEO_ARGS_HD" ] ||
    [ -z "$VIDEO_ARGS" ] ||
    [ -z "$MEDIA_CONTAINER" ] ||
    [ -z "$AUDIO_CODEC" ] ||
    [ -z "$AUDIO_ARGS_SD" ] ||
    [ -z "$AUDIO_ARGS_HD" ] ||
    [ -z "$AUDIO_ARGS" ]
    then
    echo -e '\tThis script (video_encode) should not be used directly, please use x264_encode or the others to perform the convertion...\n'
    exit 1
fi

# set default variables
HD_WIDTH=1280
HD_HEIGHT=720

FFMPEG='ffmpeg'
FFMPEG_ARGS='-threads 0 -cpuflags all -stats'

# set filters
COMPRESSOR="-af acompressor=threshold=-40dB:ratio=3:attack=50:release=300"
MOTION_INTERPOLATION="-vf minterpolate='fps=60'"
FILTERS="$COMPRESSOR "

#set default control variables
SET_REMOVE=0 # 1 to remove file after convertion
SET_PREVIEW=0 # 1 when we want to render a preview of the file
STATUS=0 # no errors in the convertion operation

# set user options
REMOVE=-r
PREVIEW=-p
MINTERPOLATE=-i

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
    show_copywrite "FFMPEG Convert to $MEDIA_CONTAINER ($VIDEO_CODEC / $AUDIO_CODEC)"
    echo -e "\n\tUsage: video_encode [options] file1 [file2 [...]]\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\t$REMOVE\tRemove old file when convertion is done"
    echo -e "\t$PREVIEW\tGenerate a preview starting in the middle of the video, with duration of 30 secs"
    echo -e "\n\tEXAMPLES"
    echo -e "# convert file file1.wmv"
    echo -e "video_encode file1.wmv\n"
    echo -e "# cconvert files 1 and 2, then remove the original files if operation succeeds"
    echo -e "video_encode -r file1.wmv file2.wmv"
    echo -e "\n" ; exit 0
}

# get video resolution and set conversion quality accordingly
set_quality(){
    FILE=$1
    WIDTH=$(mediainfo "$FILE" | grep Width | cut -d: -f2 | sed 's/pixels//g' | sed 's/ //g')
    HEIGHT=$(mediainfo "$FILE" | grep Height | cut -d: -f2 | sed 's/pixels//g' | sed 's/ //g')

    if [ $WIDTH -ge $HD_WIDTH ] || [ $HEIGHT -ge $HD_HEIGHT ]; then
        VIDEO_ARGS=$VIDEO_ARGS_HD
        AUDIO_ARGS=$AUDIO_ARGS_HD
        QA='Full HD / HD'
    else
        VIDEO_ARGS=$VIDEO_ARGS_SD
        AUDIO_ARGS=$AUDIO_ARGS_SD
        QA='SD'
    fi
    echo -e "\nVideo Quality Detected: $QA ($WIDTH / $HEIGHT)\n"
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

# convert file
convert_file(){
    # FILE INPUT
    FULL_FILENAME=$1
    DIR=$(dirname "$FULL_FILENAME")
    FILENAME=$(basename "$FULL_FILENAME")
    EXT="${FILENAME##*.}"
    FILENAME="${FILENAME%.*}"
    # DESTINATION OF THE FILE
    FULL_DEST_FILENAME="$DIR/$FILENAME"
    if [ "$EXT" == "$MEDIA_CONTAINER" ]; then
        FULL_DEST_FILENAME="$FULL_DEST_FILENAME"_2
    fi
    FULL_DEST_FILENAME="$FULL_DEST_FILENAME.$MEDIA_CONTAINER"

    # encode high quality
    echo "$FFMPEG -i \"$FULL_FILENAME\" $FILTERS -acodec \"$AUDIO_CODEC\" $AUDIO_ARGS -vcodec \"$VIDEO_CODEC\" $VIDEO_ARGS $FFMPEG_ARGS \"$FULL_DEST_FILENAME\"" && echo " "
    $FFMPEG -i "$FULL_FILENAME" $FILTERS -acodec "$AUDIO_CODEC" $AUDIO_ARGS -vcodec "$VIDEO_CODEC" $VIDEO_ARGS $FFMPEG_ARGS "$FULL_DEST_FILENAME"

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

generate_preview(){
    # FILE INPUT
    FULL_FILENAME=$1
    DIR=$(dirname "$FULL_FILENAME")
    FILENAME=$(basename "$FULL_FILENAME")
    EXT="${FILENAME##*.}"
    FILENAME="${FILENAME%.*}"
    # DESTINATION OF THE FILE
    FULL_DEST_FILENAME="$DIR/$FILENAME"_preview.mkv

    #get video duration (is floor(secs))
    DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FULL_FILENAME")
    DURATION="${DURATION%.*}"
    # set the start of the preview as half the video
    START=$(( $DURATION / 2 ))
    # set duration of the preview as maximum of 30 secs
    PREVIEW_DURATION=30
    if [ $PREVIEW_DURATION -gt $START ]; then
        PREVIEW_DURATION=$(($START-1))
    fi

    # echo $FULL_DEST_FILENAME
    # exit 0
    echo "$FFMPEG -ss \"$START\" -i \"$FULL_FILENAME\" -t \"$PREVIEW_DURATION\" $FILTERS -acodec \"$AUDIO_CODEC\" $AUDIO_ARGS -vcodec \"$VIDEO_CODEC\" $VIDEO_ARGS $FFMPEG_ARGS \"$FULL_DEST_FILENAME\"" && echo " "
    $FFMPEG -ss "$START" -i "$FULL_FILENAME" -t "$PREVIEW_DURATION" $FILTERS -acodec "$AUDIO_CODEC" $AUDIO_ARGS -vcodec "$VIDEO_CODEC" $VIDEO_ARGS $FFMPEG_ARGS "$FULL_DEST_FILENAME"
    # remove file once finished
    if [ $? -eq 0 ]; then
        # print result
        [ $? -eq 0 ] && echo -e "\n\t${bold}${Green}"$(python -c "print \"$Checkmark Generate Preview SUCCESS - $FULL_FILENAME\"")"\n${normal}${White}"
    else
        flag_error 'Preview Generation FAILED' "$FULL_FILENAME" "$FULL_DEST_FILENAME"
    fi
}

# display help if user requested it
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then show_help; fi

# read options here
for var in "$@"; do
    case "$var" in
    "$REMOVE")
        echo -e "\nRemove Original File When Done - ON"
        SET_REMOVE=1
        ;;
    "$PREVIEW")
        echo -e "\nPreview Generation Mode - ON"
        SET_PREVIEW=1
        ;;
    "$MINTERPOLATE")
        echo -e "\Motion Interpolation (60 fps) - ON"
        FILTERS="$FILTERS $MOTION_INTERPOLATION"
        ;;
    *)
        set_quality "$var"
        if [ "$SET_PREVIEW" -eq 1 ]; then
            generate_preview "$var"
        else
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


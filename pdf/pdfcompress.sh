#!/bin/bash

#set default control variables
SET_REMOVE=0 # 1 to remove file after convertion
STATUS=0 # no errors in the convertion operation


# set user options
REMOVE=-r
PREVIEW=-p

# NEW PDF FINAL NAME
PDF_FILEEND=_compress

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
    show_copywrite "PDF Compressor"
    echo -e "\n\tUsage: pdfcompress file1 [file2 [...]]\n"
    echo -e "Generates a compressed PDF file with \"$PDF_FILEEND\" in the end of the filename.\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\t$REMOVE\tReplace the old file when compression is done (original file is overritten)"
    echo -e "\n" ; exit 0
}

err_display(){
    MSG=$1
    echo -e "\n\t${bold}${Red}"$(python -c "print \"$FancyX $MSG\"")"\n${normal}${White}"
}

success_display(){
    MSG=$1
    echo -e "\n\t${bold}${Green}"$(python -c "print \"$Checkmark $MSG\"")"\n${normal}${White}"
}

# indicate that an error happened
flag_error(){
    MSG=$1
    FILE=$2
    # indicate error
    STATUS=1
    # print result
    echo -e "\n\t${bold}${Red}"$(python -c "print \"$FancyX $MSG - $FILE\"")"\n${normal}${White}"
}

# compress pdf
compress_pdf(){
    # FILE INPUT
    FULL_FILENAME=$1
    DIR=$(dirname "$FULL_FILENAME")
    FILENAME=$(basename "$FULL_FILENAME")
    EXT="${FILENAME##*.}"
    FILENAME="${FILENAME%.*}"
    # DESTINATION OF THE FILE
    FULL_DEST_FILENAME="$DIR/$FILENAME""$PDF_FILEEND".pdf

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH "-sOutputFile=$FULL_DEST_FILENAME" "$FULL_FILENAME" &> /dev/null

    # remove file once finished
    if [ $? -eq 0 ]; then
        # remove file if user requested it
        if [ "$SET_REMOVE" -eq 1 ]; then
            rm "$FULL_FILENAME" &&
            mv "$FULL_DEST_FILENAME" "$FULL_FILENAME"
        fi
        # print result
        [ $? -eq 0 ] &&
        success_display "Convertion SUCCESS - $FULL_FILENAME" ||
        err_display "Convertion SUCCESS - Could not replace old file with new one - $FULL_FILENAME"
    else
        rm "$FULL_DEST_FILENAME" 2> /dev/null
        flag_error 'Convertion FAILED' "$FULL_FILENAME"
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
    *)
        # allow multithreding
        compress_pdf "$var"
        ;;
    esac
done

exit $STATUS

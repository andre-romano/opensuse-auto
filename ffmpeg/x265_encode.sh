#!/bin/bash

# get actual dir
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
VIDEO_ENCODER=$SCRIPT_DIR/video_encode.sh

# define output
export VIDEO_CODEC='libx265'
export VIDEO_ARGS_SD='-preset:v fast -crf:v 23'
export VIDEO_ARGS_HD='-preset:v faster -crf:v 26'
export VIDEO_ARGS=$VIDEO_ARGS_SD

export MEDIA_CONTAINER='mkv'

export AUDIO_CODEC='libopus'
export AUDIO_ARGS_SD='-application:a audio -cutoff:a 20000 -vbr:a on -b:a 128k -compression_level:a 8'
export AUDIO_ARGS_HD='-application:a audio -cutoff:a 20000 -vbr:a on -b:a 192k -compression_level:a 10'
export AUDIO_ARGS=$AUDIO_ARGS_SD

# run the encoder
$VIDEO_ENCODER "$@"

#!/bin/bash

# get actual dir
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
VIDEO_ENCODER=$SCRIPT_DIR/video_encode.sh

# define output as .mp4 (x264 / aac)
export VIDEO_CODEC='libx264'
export VIDEO_ARGS_SD='-profile:v high -level:v 4.0 -preset:v fast -crf 19'
export VIDEO_ARGS_HD='-profile:v high -level:v 4.0 -preset:v faster -crf 21'
export VIDEO_ARGS=$VIDEO_ARGS_SD

export MEDIA_CONTAINER='mp4'

export AUDIO_CODEC='libfdk_aac'
export AUDIO_ARGS_SD='-cutoff:a 18000 -vbr:a 4'
export AUDIO_ARGS_HD='-cutoff:a 18000 -vbr:a 5'
export AUDIO_ARGS=$AUDIO_ARGS_SD

# run the encoder
$VIDEO_ENCODER "$@"

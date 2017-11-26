#!/bin/bash

# get actual dir
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
VIDEO_ENCODER=$SCRIPT_DIR/video_encode.sh

# define output
export VIDEO_CODEC='libvpx-vp9'
export VIDEO_ARGS_SD='-quality:v good -speed:v 1 -tile-columns:v 1 -frame-parallel:v 1 -crf:v 34 -b:v 0'
export VIDEO_ARGS_HD='-quality:v good -speed:v 2 -tile-columns:v 2 -frame-parallel:v 1 -crf:v 32 -b:v 0'
export VIDEO_ARGS=$VIDEO_ARGS_SD

export MEDIA_CONTAINER='mkv'

export AUDIO_CODEC='libopus'
export AUDIO_ARGS_SD='-application:a audio -cutoff:a 20000 -vbr:a on -b:a 128k -compression_level:a 8'
export AUDIO_ARGS_HD='-application:a audio -cutoff:a 20000 -vbr:a on -b:a 192k -compression_level:a 10'
export AUDIO_ARGS=$AUDIO_ARGS_SD

# run the encoder
$VIDEO_ENCODER "$@"

#!/bin/bash
source /etc/profile
#set a permanent limit of 2GB
ulimit -v 2097152
smplayer "$@"

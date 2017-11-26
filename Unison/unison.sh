#!/bin/bash
source /etc/profile
#set a permanent limit of 4GB
ulimit -v 3145728
unison "$@"

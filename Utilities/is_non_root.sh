#!/bin/bash
#return -1 if it's non-root, otherwise 0
if [ "$(whoami)" == "root" ]; then exit -1; fi
exit 0

#!/bin/bash

LIST_MODULES=/usr/bin/list_modules

echo "
find /lib/modules/`uname -r` -name '*.ko' | sed -e \"s/\/lib\/modules\/`uname -r`//gi\"
" > "$LIST_MODULES" &&
chmod 755 "$LIST_MODULES"
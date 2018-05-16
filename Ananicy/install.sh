#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

PWD=$(pwd) 
git clone 'https://github.com/Nefelim4ag/Ananicy.git' "$SCRIPT_DIR"/src &&
cd "$SCRIPT_DIR"/src &&
make -j4 install 
STATUS=$?
cd "$PWD"
if [ $STATUS -eq 0 ]; then
  echo -e '\n\tAll went fine, Ananicy Installed with SUCCESS\n'
else
  echo -e '\n\tAnanicy Installation - ERROR\n'
  exit $STATUS
fi

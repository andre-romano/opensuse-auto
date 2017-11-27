#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

# load help
HELP_TITLE='Driver Finder Utility'
HELP_DESCRIPTION='Finds all drivers currently being used by the system'
HELP_USAGE='drivers'
. "$UTILITIES/help.sh"

# show help
if [ -n "$1" ]; then show_help; fi

TEMP_LSPCI="$SCRIPT_DIR/.temp_drv_lspci"
TEMP_FIND="$SCRIPT_DIR/.temp_drv_find"

SEPARATOR='|'
DEV_ID=$(lspci | cut -d' ' -f1 | xargs)

empty_line(){
    echo " $SEPARATOR $SEPARATOR " >> "$TEMP_LSPCI"
}

echo -e '\n\tDiscovering drivers ...\n'

# find drivers
find /sys | grep -i "drivers" > "$TEMP_FIND"

echo 'DRIVER'"$SEPARATOR"'  ID '"$SEPARATOR"'DESCRIPTION' > "$TEMP_LSPCI"
empty_line
while IFS='' read -r line || [[ -n "$line" ]]; do
    ID=$(echo $line | cut -d' ' -f1)
    PCI_DEV=$(echo $line | cut -d' ' -f2-)
    DRIVER=$(cat "$TEMP_FIND" | grep -i "drivers.*:$ID" | sed -e 's/.*drivers\///g' -e "s/\/.*//g" | xargs)    
    if [ -n "$PCI_DEV" ] && [ -n "$DRIVER" ]; then
        echo -e "$DRIVER""$SEPARATOR""$ID""$SEPARATOR""$PCI_DEV" >> "$TEMP_LSPCI"
    fi    
done < <( lspci )
empty_line
cat "$TEMP_LSPCI" | column -t -s "$SEPARATOR"
rm -f "$TEMP_LSPCI" "$TEMP_FIND" &> /dev/null

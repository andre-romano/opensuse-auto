#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

TEMP="$SCRIPT_DIR/.temp_lspci"

SEPARATOR='|'
DEV_ID=$(lspci | cut -d' ' -f1 | xargs)

empty_line(){
    echo " $SEPARATOR $SEPARATOR " >> "$TEMP"
}

echo -e '\n\tDiscovering drivers ...\n'
echo 'DRIVER'"$SEPARATOR"'  ID '"$SEPARATOR"'DESCRIPTION' > "$TEMP"
empty_line
while IFS='' read -r line || [[ -n "$line" ]]; do
    ID=$(echo $line | cut -d' ' -f1)
    PCI_DEV=$(echo $line | cut -d' ' -f2-)
    DRIVER=$(find /sys | grep -i "drivers.*:$ID" | sed -e 's/.*drivers\///g' -e "s/\/.*//g" | xargs)    
    if [ -n "$PCI_DEV" ] && [ -n "$DRIVER" ]; then
        echo -e "$DRIVER$SEPARATOR$ID$SEPARATOR$PCI_DEV" >> "$TEMP"
    fi    
done < <( lspci )
empty_line
cat "$TEMP" | column -t -s "$SEPARATOR"
rm -f "$TEMP" &> /dev/null

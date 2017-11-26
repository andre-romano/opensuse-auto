#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" = "root" ] && echo -e "\n\tRUN this script as NON-ROOT. Exiting...\n" && exit 1

MSG="AutoFix Screen Issues (XRANDR)"

# TODO (fix this scripts - instead of polling xrandr every 10 secs, its better to attach a keybinding to the KDE5
# workspace - GLOBLA KEYBINDING)
echo -e "$MSG - SUCCESS" ||
(echo -e "$MSG - FAILED" && exit 1)

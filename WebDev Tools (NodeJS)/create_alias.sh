#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
WEB_PROJECT="$(readlink -f "../WebDev Project/web_project.sh")"

echo -e "To create an Alias, type the user's names separated by a whitespace below. If do not want alias creation, don't type anything, just press OK. " &&
read USERS_NAME
if [ -n "$USERS_NAME" ]; then
    for u in $USERS_NAME; do
        echo -e "\n#alias for web initial project config\nalias webcreate=\"$WEB_PROJECT\"" >> "/home/$u/.bashrc" ||
        echo -e "ERROR: Could not create alias for \"$u\" user."
    done
fi
echo -e "All operations done, aliases created!"

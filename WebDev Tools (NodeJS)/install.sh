 #!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

MSG="NodeJS Installation and Configuration"

ALIAS="$SCRIPT_DIR/create_alias.sh"
WEB_PROJECT="../WebDev Project/"
INSTALL_NPM="browser-sync bower eslint babel-cli babel-preset-es2015 gulp-cli sass imagemin-pngquant"
LINK_NPM=$(echo $INSTALL_NPM | sed -e 's/gulp-cli //g')

#install programs
zypper -n in -l git nodejs npm php5 php5-mysql php5-pgsql &&
echo -e "\nGit, NodeJS and NPM installed. Continue extensions installation...\n" &&
npm install -g $INSTALL_NPM &&
# no need for this, links already created
echo -e "Installation completed. Creating local links..." &&
cd "$WEB_PROJECT" &&
npm link $LINK_NPM &&
echo -e "Link completed, assuring permission of access..." &&
chown root:users -R node_modules/ && chmod 775 -R node_modules/ &&
echo "$MSG - SUCCESS" ||
(echo "$MSG - FAILED" && exit 1)

#add alias
echo -e "\nDo you wish to add an alias to a user?" &&
"$ALIAS"


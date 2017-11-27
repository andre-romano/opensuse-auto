#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

# varaibles
INSTALLED_RPM="installed.packages"
INSTALLED_REPO="installed.repositories"

# load help
HELP_TITLE='List Installed Packages'
HELP_DESCRIPTION='List all installed RPM packages and openSUSE repositories in the system.'
HELP_USAGE='list_installed'
. "$UTILITIES/help.sh"

# show help
if [ -n "$1" ]; then show_help; fi

display_lines(){
    echo -e $(wc -l "$1" | cut -d' ' -f1)
}

# returns a comma separated list of all installed packages
echo -e '\n\tAcquiring data (this will take a while) ...\n'
echo -en '   Installed Packages = '
rpm -qa --qf "%{NAME}," | sed -e 's/,/\n/g' > "$INSTALLED_RPM"
display_lines "$INSTALLED_RPM"
echo -en 'OpenSUSE repositories = '
find /etc/zypp/repos.d/ -type f -exec cat '{}' \; | grep url | cut -d'=' -f2 > "$INSTALLED_REPO"
display_lines "$INSTALLED_REPO"
echo -e "\n\tInformation stored SUCCESSFULLY to \"$INSTALLED_RPM\" and \"$INSTALLED_REPO\"\n"

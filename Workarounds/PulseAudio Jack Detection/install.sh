#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/../.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

. "$UTILITIES_INCLUDE/cron_functions.sh"
. "$UTILITIES_INCLUDE/general_functions.sh"

create_cron_job "$SCRIPT_DIR" "/etc" "pulse_detect.sh" "@reboot"



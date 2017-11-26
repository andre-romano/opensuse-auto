#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#SAVE SCRIPT BELOW INTO SCRIPT_PATH
SCRIPT_PATH="/etc/pm/sleep.d/20_custom-ehci_hcd"
mkdir -p $(dirname $SCRIPT_PATH) &&
echo -e '#!'"/bin/sh
#inspired by http://art.ubuntuforums.org/showpost.php?p=9744970&postcount=19
#...and http://thecodecentral.com/2011/01/18/fix-ubuntu-10-10-suspendhibernate-not-working-bug    
# tidied by tqzzaa :)

VERSION=1.1
DEV_LIST=/tmp/usb-dev-list
DRIVERS_DIR=/sys/bus/pci/drivers
DRIVERS=\"ehci xhci\" # ehci_hcd, xhci_hcd
HEX=\"[[:xdigit:]]\"
MAX_BIND_ATTEMPTS=2
BIND_WAIT=0.1

unbindDev() {
  echo -n > $DEV_LIST 2>/dev/null
  for driver in $DRIVERS; do
    DDIR=$DRIVERS_DIR/${driver}_hcd
    for dev in `ls $DDIR 2>/dev/null | egrep \"^$HEX+:$HEX+:$HEX\"`; do
      echo -n \"$dev\" > $DDIR/unbind
      echo \"$driver $dev\" >> $DEV_LIST
    done
  done
}

bindDev() {
  if [ -s $DEV_LIST ]; then
    while read driver dev; do
      DDIR=$DRIVERS_DIR/${driver}_hcd
      while [ $((MAX_BIND_ATTEMPTS)) -gt 0 ]; do
          echo -n \"$dev\" > $DDIR/bind
          if [ ! -L \"$DDIR/$dev\" ]; then
            sleep $BIND_WAIT
          else
            break
          fi
          MAX_BIND_ATTEMPTS=$((MAX_BIND_ATTEMPTS-1))
      done  
    done < $DEV_LIST
  fi
  rm $DEV_LIST 2>/dev/null
}

case \"$1\" in
  hibernate|suspend) unbindDev;;
  resume|thaw)       bindDev;;
esac
" > "$SCRIPT_PATH" &&
chmod 755 "$SCRIPT_PATH" &&
echo -e "\n\tSuspend and Hibernate issues fixed - SUCCESS\n" &&
exit 0
echo -e "\n\tSuspend and Hibernate issues fixed - FAILED\n" 
exit 1



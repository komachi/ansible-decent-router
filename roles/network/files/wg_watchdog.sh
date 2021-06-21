#!/bin/sh
# https://mullvad.net/en/help/running-wireguard-router/
PING_HOST="10.64.0.1" # mullvad dns

tries=0
while [[ $tries -lt 5 ]]; do
  if /bin/ping -c 1 $PING_HOST; then
      exit 0
  fi
  echo "wg watchdog fail"
  tries=$((tries+1))
done
echo "wg watchdog failed 5 times - rotate"

./srv/scripts/rotate_wg.sh
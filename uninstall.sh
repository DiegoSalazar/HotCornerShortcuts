#!/bin/bash
#
# uninstall.sh: removes the hot corners LaunchAgent

PLIST_DST="$HOME/Library/LaunchAgents/com.diegosalazar.hotcorners.plist"

if launchctl list | grep -q com.diegosalazar.hotcorners; then
  launchctl unload "$PLIST_DST"
fi

rm -f "$PLIST_DST"

echo "Uninstalled. Hot corners will no longer be auto-enforced."

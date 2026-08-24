#!/bin/bash
#
# uninstall.sh: removes both hot corners LaunchAgents

AGENTS_DIR="$HOME/Library/LaunchAgents"

for label in com.diegosalazar.hotcorners com.diegosalazar.hotcorners-monitor; do
  if launchctl list | grep -q "$label"; then
    launchctl unload "$AGENTS_DIR/$label.plist"
  fi
  rm -f "$AGENTS_DIR/$label.plist"
done

echo "Uninstalled. Hot corners will no longer be auto-enforced."

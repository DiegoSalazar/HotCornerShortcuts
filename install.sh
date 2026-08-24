#!/bin/bash
#
# install.sh: installs the hot corners LaunchAgent

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_SRC="$SCRIPT_DIR/com.diegosalazar.hotcorners.plist"
PLIST_DST="$HOME/Library/LaunchAgents/com.diegosalazar.hotcorners.plist"

# Make the main script executable
chmod +x "$SCRIPT_DIR/set-hot-corners.sh"

# Unload existing agent if present
if launchctl list | grep -q com.diegosalazar.hotcorners; then
  launchctl unload "$PLIST_DST" 2>/dev/null
fi

# Copy plist to LaunchAgents
cp "$PLIST_SRC" "$PLIST_DST"

# Load the agent
launchctl load "$PLIST_DST"

echo "Installed. Hot corners will be enforced on login and every 5 minutes."
echo "Run 'bash $SCRIPT_DIR/set-hot-corners.sh' to apply immediately."

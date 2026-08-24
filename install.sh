#!/bin/bash
#
# install.sh: compiles the display monitor and installs both LaunchAgents

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$HOME/Library/LaunchAgents"

# Build the display monitor binary
echo "Compiling display-monitor..."
swiftc -O -o "$SCRIPT_DIR/display-monitor" "$SCRIPT_DIR/display-monitor.swift" -framework CoreGraphics

chmod +x "$SCRIPT_DIR/set-hot-corners.sh"
chmod +x "$SCRIPT_DIR/display-monitor"

# Unload existing agents if present
for label in com.diegosalazar.hotcorners com.diegosalazar.hotcorners-monitor; do
  if launchctl list | grep -q "$label"; then
    launchctl unload "$AGENTS_DIR/$label.plist" 2>/dev/null
  fi
done

# Copy and load both agents
cp "$SCRIPT_DIR/com.diegosalazar.hotcorners.plist" "$AGENTS_DIR/"
cp "$SCRIPT_DIR/com.diegosalazar.hotcorners-monitor.plist" "$AGENTS_DIR/"
launchctl load "$AGENTS_DIR/com.diegosalazar.hotcorners.plist"
launchctl load "$AGENTS_DIR/com.diegosalazar.hotcorners-monitor.plist"

echo "Installed:"
echo "  - Display monitor: triggers on monitor plug/unplug"
echo "  - Scheduled check: Monday and Friday at 8:00 AM"
echo ""
echo "Run 'bash $SCRIPT_DIR/set-hot-corners.sh' to apply immediately."

#!/bin/bash
#
# install.sh: compiles the display monitor and installs both LaunchAgents

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$HOME/Library/LaunchAgents"
APP_BUNDLE="$SCRIPT_DIR/HotCornersMonitor.app"
APP_BIN="$APP_BUNDLE/Contents/MacOS/display-monitor"

# Build the display monitor binary into the app bundle
echo "Compiling display-monitor..."
mkdir -p "$APP_BUNDLE/Contents/MacOS"
swiftc -O -o "$APP_BIN" "$SCRIPT_DIR/display-monitor.swift" -framework CoreGraphics

chmod +x "$SCRIPT_DIR/set-hot-corners.sh"
chmod +x "$APP_BIN"

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

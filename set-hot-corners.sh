#!/bin/bash
#
# set-hot-corners.sh
#
# Fixes macOS hot corners that reset when docking/undocking external monitors.
# Only writes + restarts Dock if the current values are wrong.
#
# Hot corner action codes:
#   0  = No action           5  = Start Screen Saver
#   2  = Mission Control     6  = Disable Screen Saver
#   3  = Application Windows 7  = Dashboard
#   4  = Desktop            10  = Put Display to Sleep
#   11 = Launchpad          12  = Notification Center
#   13 = Lock Screen
#
# Desired config:
#   Top left:     Disable Screen Saver (6)
#   Bottom right: Start Screen Saver (5)
#   All others:   No action (0)

DOMAIN="com.apple.dock"
NEEDS_RESTART=false

check_and_set() {
  local key="$1"
  local expected="$2"
  local current
  current=$(defaults read "$DOMAIN" "$key" 2>/dev/null)
  if [ "$current" != "$expected" ]; then
    defaults write "$DOMAIN" "$key" -int "$expected"
    NEEDS_RESTART=true
  fi
}

check_and_set wvous-tl-corner    6
check_and_set wvous-tl-modifier  0
check_and_set wvous-tr-corner    0
check_and_set wvous-tr-modifier  0
check_and_set wvous-bl-corner    0
check_and_set wvous-bl-modifier  0
check_and_set wvous-br-corner    5
check_and_set wvous-br-modifier  0

if $NEEDS_RESTART; then
  killall Dock
  echo "$(date '+%Y-%m-%d %H:%M:%S') Hot corners fixed."
fi

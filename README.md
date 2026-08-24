# HotCornerShortcuts

Automatically fixes macOS hot corners that break when you plug in or unplug
an external monitor.

## The problem

macOS hot corners stop working after display configuration changes (docking,
undocking, monitor sleep/wake). This has been reported across every macOS
version from Leopard (2009) through Tahoe (2026) and Apple has never fixed it.

What actually happens: the Dock process manages hot corner triggers and maps
them to screen coordinates. When a display is added or removed, the Dock loses
track of the screen geometry. Corners either stop responding entirely or get
mapped to the wrong display's coordinate space (e.g. your top-left corner
triggers on the external monitor instead of your laptop). The settings in
System Settings may still look correct, but the Dock's internal state is stale.

The fix is simple: restart the Dock (`killall Dock`). But doing that manually
every time you plug in a monitor gets old fast.

## What this does

A background daemon detects monitor plug/unplug events and automatically
restarts the Dock to re-initialize hot corner mapping. It also re-applies your
preferred hot corner settings in case they drifted.

Two components:

1. **Display monitor daemon** (`display-monitor.swift`): uses
   `CGDisplayRegisterReconfigurationCallback` to detect display changes and
   runs the fix within 3 seconds.
2. **Scheduled safety net**: a LaunchAgent that runs every Monday and Friday
   at 8:00 AM to catch any drift missed by the daemon.

Default hot corner config (edit `set-hot-corners.sh` to change):

| Corner | Action |
|--------|--------|
| Top left | Disable Screen Saver |
| Bottom right | Start Screen Saver |

## Install

```bash
cd ~/code
git clone https://github.com/DiegoSalazar/HotCornerShortcuts.git
cd HotCornerShortcuts
bash install.sh
```

The LaunchAgent plists assume the repo lives at `~/code/HotCornerShortcuts`. If
you clone it somewhere else, update the paths in
`com.diegosalazar.hotcorners.plist` and `com.diegosalazar.hotcorners-monitor.plist`
before running `install.sh`.

Compiles the Swift daemon, copies both LaunchAgents to
`~/Library/LaunchAgents/`, and loads them. To apply settings right now:

```bash
bash set-hot-corners.sh
```

## Uninstall

```bash
bash uninstall.sh
```

## Customizing

Edit `set-hot-corners.sh`. Action codes:

| Code | Action |
|------|--------|
| 0 | No action |
| 2 | Mission Control |
| 3 | Application Windows |
| 4 | Desktop |
| 5 | Start Screen Saver |
| 6 | Disable Screen Saver |
| 10 | Put Display to Sleep |
| 11 | Launchpad |
| 12 | Notification Center |
| 13 | Lock Screen |

Corner keys: `wvous-tl-corner` (top left), `wvous-tr-corner` (top right),
`wvous-bl-corner` (bottom left), `wvous-br-corner` (bottom right).

## Logs

- Scheduled checks: `/tmp/hotcorners.log`
- Display monitor: `/tmp/hotcorners-monitor.log`

## References

### Bug reports (newest first)

- [Apple Community: Upper left hot corner not working - Sequoia 15.5](https://discussions.apple.com/thread/256084416) (2025) - corners map to wrong display after connecting second monitor
- [Apple Community: Hot Corners regularly stop working - Monterey](https://discussions.apple.com/thread/253855846) (2022) - corners stop responding after sleep/dock, `killall Dock` fixes temporarily
- [MacRumors: Hot corners not working after unplugging external monitor](https://forums.macrumors.com/threads/expose-hot-corners-not-working-after-unplugging-external-monitor.672825/) (2009, still active) - corners die after disconnecting external display, changing resolution or toggling settings restores them

### Technical references

- [Setting Mac hot corners in the terminal](https://dev.to/darrinndeal/setting-mac-hot-corners-in-the-terminal-3de)
- [Apple: CGDisplayRegisterReconfigurationCallback](https://developer.apple.com/documentation/coregraphics/1455336-cgdisplayregisterreconfiguration)
- [Display reconfigurations on macOS](https://nonstrict.eu/blog/2023/display-reconfigurations-on-macos/)

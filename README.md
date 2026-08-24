# HotCornerShortcuts

Workaround for the long-standing macOS bug where hot corner settings reset when
docking/undocking external monitors.

Apple has not fixed this across Sierra through Tahoe (macOS 26). The only
reliable fix is to re-apply the settings automatically.

## What it does

Enforces your hot corner config via two mechanisms:

1. **Display monitor daemon**: a small Swift binary that uses
   `CGDisplayRegisterReconfigurationCallback` to detect monitor plug/unplug
   events and re-apply settings instantly.
2. **Scheduled safety net**: a LaunchAgent that runs every Monday and Friday
   at 8:00 AM to catch any drift.

| Corner | Action |
|--------|--------|
| Top left | Disable Screen Saver |
| Top right | (none) |
| Bottom left | (none) |
| Bottom right | Start Screen Saver |

The script checks current values before writing, so the Dock only restarts when
settings have actually drifted.

## Install

```bash
bash install.sh
```

This compiles the display monitor, copies both LaunchAgents to
`~/Library/LaunchAgents/`, and loads them.

To apply settings immediately:

```bash
bash set-hot-corners.sh
```

## Uninstall

```bash
bash uninstall.sh
```

## Customizing

Edit `set-hot-corners.sh` to change which corners do what. Action codes:

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

- [Setting Mac hot corners in the terminal](https://dev.to/darrinndeal/setting-mac-hot-corners-in-the-terminal-3de)
- [Apple: CGDisplayRegisterReconfigurationCallback](https://developer.apple.com/documentation/coregraphics/1455336-cgdisplayregisterreconfiguration)
- [Display reconfigurations on macOS](https://nonstrict.eu/blog/2023/display-reconfigurations-on-macos/)
- [Apple Community: Hot Corners regularly stop working](https://discussions.apple.com/thread/253855846)
- [MacRumors: Hot corners not working after unplugging external monitor](https://forums.macrumors.com/threads/expose-hot-corners-not-working-after-unplugging-external-monitor.672825/)

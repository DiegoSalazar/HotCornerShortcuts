# HotCornerShortcuts

Workaround for the long-standing macOS bug where hot corner settings reset when
docking/undocking external monitors.

Apple has not fixed this across Sierra through Tahoe (macOS 26). The only
reliable fix is to re-apply the settings automatically.

## What it does

A shell script + LaunchAgent that enforces your hot corner config:

| Corner | Action |
|--------|--------|
| Top left | Disable Screen Saver |
| Top right | (none) |
| Bottom left | (none) |
| Bottom right | Start Screen Saver |

The script checks current values before writing, so the Dock only restarts when
settings have actually drifted. It runs on login and every 5 minutes.

## Install

```bash
bash install.sh
```

This copies the LaunchAgent to `~/Library/LaunchAgents/` and loads it.

To apply settings immediately without waiting:

```bash
bash set-hot-corners.sh
```

## Uninstall

```bash
bash uninstall.sh
```

## Customizing

Edit the `DESIRED` map in `set-hot-corners.sh`. Action codes:

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

Output goes to `/tmp/hotcorners.log`.

## References

- [Setting Mac hot corners in the terminal](https://dev.to/darrinndeal/setting-mac-hot-corners-in-the-terminal-3de)
- [Apple Community: Hot Corners regularly stop working](https://discussions.apple.com/thread/253855846)
- [MacRumors: Hot corners not working after unplugging external monitor](https://forums.macrumors.com/threads/expose-hot-corners-not-working-after-unplugging-external-monitor.672825/)

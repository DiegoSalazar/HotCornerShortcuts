# Security Policy

## What this project does

This project runs two shell commands against your local macOS preferences:

1. `defaults write com.apple.dock` to set hot corner values
2. `killall Dock` to restart the Dock process

The Swift daemon (`display-monitor.swift`) registers a display change callback
and calls the shell script above. It makes no network connections and accesses
no user data.

## Reviewing the code

The entire project is ~50 lines of bash and ~30 lines of Swift. You can read
every line before installing:

- `set-hot-corners.sh`: the shell script that writes dock preferences
- `display-monitor.swift`: the background daemon
- `install.sh` / `uninstall.sh`: copy LaunchAgent plists to `~/Library/LaunchAgents/`

Nothing requires `sudo`. All files are installed in your user directory.

## Reporting a vulnerability

If you find a security issue, open an issue on this repository or email
the maintainer directly via GitHub.

import CoreGraphics
import Foundation

// Tiny daemon that watches for display configuration changes
// (monitor plug/unplug) and re-applies hot corner settings.

var lastApplied: Date = .distantPast

func applyHotCorners() {
    let home = FileManager.default.homeDirectoryForCurrentUser.path
    let script = home + "/code/HotCornerShortcuts/set-hot-corners.sh"
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/bin/bash")
    task.arguments = [script]
    try? task.run()
}

func displayChanged(
    _ display: CGDirectDisplayID,
    _ flags: CGDisplayChangeSummaryFlags,
    _ ctx: UnsafeMutableRawPointer?
) {
    // Only act after reconfiguration completes, not on "begin"
    guard !flags.contains(.beginConfigurationFlag) else { return }

    // Debounce: multiple displays fire multiple callbacks
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        guard Date().timeIntervalSince(lastApplied) > 2.0 else { return }
        lastApplied = Date()
        applyHotCorners()
    }
}

CGDisplayRegisterReconfigurationCallback(displayChanged, nil)

// Apply once on launch
applyHotCorners()

// Run forever
dispatchMain()

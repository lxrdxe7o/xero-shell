# Development Guide

## Quick Reference

### Testing Changes

Run from project directory:
```bash
quickshell -p .
```

Kill running instance:
```bash
pkill quickshell
```

Watch logs:
```bash
tail -f /run/user/1000/quickshell/by-id/*/log.qslog
```

### File Organization

- **Commons/**: Singletons accessible everywhere (Colors, Style)
- **Components/**: Reusable building blocks (BasePill, ScrollingText, Anim, ColorAnim)
- **Modules/**: Feature modules (Bar with its pills)

## Adding a New Pill Component

### 1. Create the pill file

Create `Modules/Bar/YourPill.qml`:

```qml
import Quickshell
import Quickshell.Widgets
import QtQuick
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    // Properties
    readonly property string myData: "Hello"

    // Dimensions
    implicitWidth: content.implicitWidth + Style.pillPaddingHorizontal * 2

    // Tooltip (shows on hover)
    tooltip: "Your tooltip here"

    // Interactions
    onClicked: {
        console.log("Clicked!")
    }

    onRightClicked: {
        // Secondary action
    }

    onWheel: function(event) {
        if (event.angleDelta.y > 0) {
            // Scroll up
        } else {
            // Scroll down
        }
    }

    // Content
    Row {
        id: content
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        Text {
            text: Style.iconWindow  // Use icon from Style
            color: Colors.pillIcon
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont
        }

        Text {
            text: root.myData
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
        }
    }

    // Feedback animation on data change
    onMyDataChanged: bounce()
}
```

### 2. Register in qmldir

Add to `qmldir`:
```
YourPill 1.0 Modules/Bar/YourPill.qml
```

### 3. Add to Bar.qml

```qml
YourPill {
    anchors.verticalCenter: parent.verticalCenter
}
```

## BasePill Component

The `BasePill` component provides:

| Property | Type | Description |
|----------|------|-------------|
| `pillColor` | color | Background color |
| `tooltip` | string | Hover tooltip text |
| `hovered` | bool | Read-only hover state |
| `interactive` | bool | Enable/disable interactions |

| Signal | Description |
|--------|-------------|
| `clicked(mouse)` | Left mouse button |
| `rightClicked(mouse)` | Right mouse button |
| `middleClicked(mouse)` | Middle mouse button |
| `wheel(wheel)` | Mouse wheel event |

| Method | Description |
|--------|-------------|
| `bounce()` | Scale up then down animation |
| `pulse()` | Scale down then up animation |

## ScrollingText Component

For long text that should scroll:

```qml
ScrollingText {
    text: "Very long text that needs to scroll"
    color: Colors.pillText
    maxWidth: Style.titleMaxWidth
    font.pixelSize: Style.fontSizeNormal
    font.family: Style.fontFamily
}
```

## Style.qml Reference

### Dimensions

```qml
Style.barHeight          // 40
Style.pillHeight         // 32
Style.pillPaddingHorizontal  // 12
Style.pillMinWidth       // 32
Style.pillMaxWidth       // 400
Style.titleMaxWidth      // 300
Style.mediaMaxWidth      // 250
Style.ssidMaxWidth       // 150
```

### Spacing

```qml
Style.spacingSmall   // 4
Style.spacingNormal  // 8
Style.spacingLarge   // 12
Style.spacingXLarge  // 16
```

### Animations

```qml
Style.animationFast   // 150ms
Style.animationNormal // 300ms
Style.animationSlow   // 450ms
```

### Icons (Nerd Fonts)

```qml
// Volume
Style.iconVolumeMuted, iconVolumeLow, iconVolumeMedium, iconVolumeHigh

// Battery
Style.iconBatteryCharging, iconBatteryLevels[0-9]

// Network
Style.iconEthernet, iconWifiOff, iconWifiLevels[0-4], iconVpn

// Media
Style.iconPlay, iconPause, iconNext, iconPrevious

// System
Style.iconCpu, iconMemory, iconBluetooth, iconMic, iconBrightness
```

### Helper Functions

```qml
Style.getWifiIcon(strength)      // Returns appropriate WiFi icon
Style.getBatteryIcon(percent, charging)
Style.getVolumeIcon(volume, muted)
Style.getBrightnessIcon(brightness)
```

## Colors.qml Reference

### Semantic Colors

```qml
Colors.primary           // Blue accent
Colors.secondary         // Mauve
Colors.error             // Red
Colors.warning           // Yellow
Colors.success           // Green
Colors.info              // Sapphire
```

### Pill Colors

```qml
Colors.pillBackground    // Surface0
Colors.pillBackgroundHover
Colors.pillText          // Text color
Colors.pillTextMuted     // Subtext0
Colors.pillIcon          // Icon color
Colors.pillIconMuted
```

### Status Colors

```qml
Colors.batteryNormal, batteryCharging, batteryLow, batteryCritical
Colors.networkConnected, networkDisconnected, networkWeak
Colors.mediaPlaying, mediaPaused
```

### Helper Functions

```qml
Colors.withAlpha(color, alpha)      // Add transparency
Colors.lighten(color, factor)       // Lighten color
Colors.darken(color, factor)        // Darken color
Colors.blend(color1, color2, ratio) // Mix colors
Colors.textOn(background)           // Get readable text color
```

## Polling with Process

For system commands:

```qml
Process {
    id: myProc
    running: true
    command: ["my-command", "arg1", "arg2"]

    stdout: SplitParser {
        onRead: line => {
            // Process each line of output
        }
    }

    onExited: (code, status) => {
        if (code !== 0) {
            // Handle error
        }
        restartTimer.start()
    }
}

Timer {
    id: restartTimer
    interval: Style.networkPollInterval
    onTriggered: myProc.running = true
}
```

## Hyprland Integration

```qml
import Quickshell.Hyprland

// Access workspaces
readonly property var workspaces: Hyprland.workspaces.values
readonly property int activeId: Hyprland.focusedWorkspace?.id ?? 1
readonly property var activeWindow: Hyprland.focusedWindow

// Switch workspace
Hyprland.dispatch("workspace 3")

// Close active window
Hyprland.dispatch("killactive")
```

## Service Integrations

### PipeWire (Audio)

```qml
import Quickshell.Services.Pipewire

readonly property var sink: Pipewire.defaultAudioSink
readonly property var source: Pipewire.defaultAudioSource

// Control
sink.audio.muted = true
sink.audio.volume = 0.5
```

### UPower (Battery)

```qml
import Quickshell.Services.UPower

readonly property var battery: UPower.displayDevice
readonly property bool charging: battery.state === UPowerDeviceState.Charging
readonly property int percent: Math.round(battery.percentage * 100)
```

### MPRIS (Media)

```qml
import Quickshell.Services.Mpris

readonly property var player: Mpris.players.values[0]
readonly property bool isPlaying: player.playbackState === MprisPlaybackState.Playing

// Control
player.togglePlaying()
player.next()
player.previous()
player.position = newPosition  // Seek
```

## Common Issues

**"Type X unavailable"**
- Add to `qmldir` if it's a custom component
- Check import paths are correct

**"Property X is not defined"**
- Check if component is loaded (`active: true` in Loader)
- Verify property exists in model data
- Use null-safe access: `obj?.prop ?? default`

**Colors not updating**
- Check `Behavior on color` is present
- Verify singleton is imported correctly

**Process not running**
- Check command exists and is executable
- Verify `running: true` is set
- Check exit code in `onExited`

## Performance Tips

1. Use `BasePill` instead of raw `ClippingRectangle`
2. Use `ScrollingText` for long text instead of manual animations
3. Lazy load with `Loader { active: condition }`
4. Use `Behavior on` instead of manual animations
5. Keep model filtering in `readonly property` for caching
6. Avoid polling too frequently (check `Style.*PollInterval`)

## Testing Checklist

- [ ] Pill renders correctly
- [ ] Tooltip shows on hover
- [ ] Click interactions work
- [ ] Scroll wheel works (if applicable)
- [ ] Animation feedback triggers
- [ ] Error states handled
- [ ] Null/undefined data handled
- [ ] Performance acceptable

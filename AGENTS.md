# Agent Guidelines for xero-shell

## Project Type
Quickshell configuration written in QML for Wayland compositors (Hyprland). Inspired by Caelestia's aesthetic without Python dependencies.

## Project Structure
```
xero-shell/
├── Commons/        # Singletons (Colors, Style)
├── Components/     # Reusable components (BasePill, ScrollingText, Anim, ColorAnim)
├── Modules/        # Major UI modules (Bar/)
├── qmldir          # Module definition
└── shell.qml       # Entry point
```

## Testing
- Run: `quickshell -p .` (from project directory)
- Kill: `pkill quickshell`
- Logs: `tail -f /run/user/1000/quickshell/by-id/*/log.qslog`
- Verify visually in Hyprland session

## Code Style

### Imports
```qml
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import "../../Commons"      # For singletons
import "../../Components"   # For reusable components
```
Order: Quickshell → Qt → Local (relative paths for non-singleton imports)

### Formatting
- Indentation: 4 spaces (no tabs)
- Properties before functions/signals
- Group related properties with blank lines
- Use `pragma Singleton` for singletons

### Naming Conventions
- Components: PascalCase (`Bar.qml`, `WorkspacesPill.qml`)
- Properties: camelCase (`isActive`, `pillBackground`, `activeWorkspaceId`)
- IDs: camelCase matching component (`root`, `workspacesPill`, `clockText`)
- Singletons: `readonly property` for all values

### Colors & Theming
- All colors in `Commons/Colors.qml` (Catppuccin Mocha palette)
- Use semantic colors (`Colors.primary`, `Colors.error`, `Colors.pillBackground`)
- For status colors: `Colors.batteryLow`, `Colors.networkConnected`
- Never hardcode hex values outside `Colors.qml`
- High contrast mode: `Colors.highContrast = true`

### Styling & Dimensions
- All dimensions in `Commons/Style.qml`
- All icons in `Style.icon*` properties
- All polling intervals in `Style.*PollInterval`
- Use helper functions: `Style.getVolumeIcon()`, `Style.getBatteryIcon()`
- Never hardcode dimensions or magic numbers

### Creating New Pills
- Always extend `BasePill` component
- Use `tooltip` property for hover info
- Use `pillColor` instead of `color`
- Handle interactions: `onClicked`, `onRightClicked`, `onWheel`
- Use `bounce()` and `pulse()` for feedback

```qml
BasePill {
    id: root

    implicitWidth: content.implicitWidth + Style.pillPaddingHorizontal * 2
    tooltip: "My tooltip"

    onClicked: doAction()

    Row {
        id: content
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        Text {
            text: Style.iconWindow
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont
            color: Colors.pillIcon
        }

        Text {
            text: "Label"
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
            color: Colors.pillText
        }
    }
}
```

### Scrolling Text
- Use `ScrollingText` component for text that may overflow
- Set `maxWidth` from Style: `Style.titleMaxWidth`, `Style.mediaMaxWidth`

### Animations
- Use `Anim {}` component for standard animations (uses Style.animationNormal)
- Use `ColorAnim {}` for color transitions (uses Style.animationFast)
- Always wrap animations in `Behavior on property { Anim {} }`
- Use `bounce()` and `pulse()` from BasePill for feedback

### Hyprland Integration
- Access workspaces: `Hyprland.workspaces.values`
- Active workspace: `Hyprland.focusedWorkspace?.id`
- Active window: `Hyprland.focusedWindow`
- Dispatch commands: `Hyprland.dispatch("workspace 1")`
- Use optional chaining (`?.`) and nullish coalescing (`??`) for null safety

### Service Integration
- PipeWire: `Pipewire.defaultAudioSink`, `Pipewire.defaultAudioSource`
- UPower: `UPower.displayDevice`
- MPRIS: `Mpris.players.values[0]`
- Always check for null before accessing properties

### Polling External Commands
- Use `Process` with `SplitParser` for stdout
- Handle errors in `onExited` with exit code check
- Use `Timer` for restart with interval from Style
- Reset state on error

```qml
Process {
    id: proc
    running: true
    command: ["my-command"]

    stdout: SplitParser {
        onRead: line => { /* parse line */ }
    }

    onExited: (code, status) => {
        if (code !== 0) { /* handle error */ }
        restartTimer.start()
    }
}

Timer {
    id: restartTimer
    interval: Style.myPollInterval
    onTriggered: proc.running = true
}
```

### Error Handling
- Use `console.log()` for debug output
- Always use null-safe operators: `obj?.prop ?? defaultValue`
- Handle process exit codes
- Provide visual feedback for error states
- Show error states in tooltips

### Testing Checklist
- [ ] Pill renders correctly
- [ ] Tooltip shows on hover
- [ ] Click interactions work
- [ ] Scroll wheel works (if applicable)
- [ ] Animation feedback triggers
- [ ] Error states handled gracefully
- [ ] Null/undefined data handled
- [ ] Performance acceptable

# xero-shell

A minimal, Caelestia-inspired Wayland shell for Hyprland/Sway built with Quickshell.

## Features

- **Pill-shaped components** inspired by Caelestia's design
- **Catppuccin Mocha** color scheme with high contrast mode
- **Workspace indicator** with active/occupied/urgent states
- **Clean architecture** with reusable BasePill component
- **Zero Python dependencies** - pure QML
- **Smooth animations** with Material-inspired easing curves
- **Interactive tooltips** on hover
- **Comprehensive system monitoring**

## Modules

| Pill | Description | Interactions |
|------|-------------|--------------|
| **WorkspacesPill** | Workspace indicators (1-5) | Click to switch |
| **WindowTitlePill** | Active window with app icons | Right-click to close |
| **ClockPill** | Time display | Click for date, right-click for seconds |
| **MediaPill** | MPRIS media controls | Click play/pause, scroll seek |
| **VolumePill** | PipeWire audio sink | Click mute, scroll adjust |
| **MicPill** | Microphone control | Click mute, scroll adjust |
| **NetworkPill** | WiFi/Ethernet/VPN status | Hover for details |
| **BluetoothPill** | Bluetooth status & devices | Click toggle power |
| **CpuPill** | CPU usage monitor | - |
| **MemoryPill** | RAM usage monitor | - |
| **BrightnessPill** | Display brightness | Click toggle, scroll adjust |
| **BatteryPill** | Battery with time remaining | Critical warning animation |

## Project Structure

```
xero-shell/
├── shell.qml                    # Main entry point
├── qmldir                       # Module exports
├── Commons/                     # Shared singletons
│   ├── Colors.qml              # Catppuccin Mocha + semantic colors
│   └── Style.qml               # All dimensions, icons, helpers
├── Components/                  # Reusable components
│   ├── Anim.qml                # Standard number animation
│   ├── ColorAnim.qml           # Color transition animation
│   ├── ScrollingText.qml       # Auto-scrolling text
│   └── BasePill.qml            # Base pill with hover/tooltip/feedback
└── Modules/Bar/                 # Bar module
    ├── Bar.qml                 # Main bar container
    ├── WorkspacesPill.qml      # Workspace indicator
    ├── WindowTitlePill.qml     # Active window title
    ├── ClockPill.qml           # Clock widget
    ├── MediaPill.qml           # Media player controls
    ├── VolumePill.qml          # Audio volume control
    ├── MicPill.qml             # Microphone control
    ├── NetworkPill.qml         # Network status
    ├── BluetoothPill.qml       # Bluetooth status
    ├── CpuPill.qml             # CPU usage
    ├── MemoryPill.qml          # Memory usage
    ├── BrightnessPill.qml      # Display brightness
    └── BatteryPill.qml         # Battery indicator
```

## Running

From the project directory:

```bash
quickshell -p .
```

Or install to `~/.config/quickshell/xero-shell` and run:

```bash
quickshell -c xero-shell
```

## Customization

### Colors

Edit `Commons/Colors.qml` to change the color scheme.

```qml
// Toggle high contrast mode
property bool highContrast: true

// Customize semantic colors
readonly property color primary: blue      // Accent color
readonly property color error: red         // Error states
readonly property color warning: yellow    // Warning states
```

### Dimensions & Behavior

Edit `Commons/Style.qml` to adjust all configuration:

```qml
// Bar dimensions
readonly property int barHeight: 40
readonly property int pillHeight: 32

// Workspace settings
readonly property int maxWorkspaces: 5

// Polling intervals (ms)
readonly property int networkPollInterval: 5000
readonly property int cpuPollInterval: 2000

// Volume step per scroll
readonly property real volumeStep: 0.05
```

### Bar Layout

The bar layout is defined in `Modules/Bar/Bar.qml`:

- **Left**: WorkspacesPill, WindowTitlePill
- **Center**: MediaPill, ClockPill
- **Right**: System indicators (CPU, Memory, Bluetooth, Network, Mic, Volume, Brightness, Battery)

## Dependencies

**Required:**
- Quickshell
- Hyprland or Sway (Wayland compositor)
- PipeWire (for audio controls)
- NetworkManager (for network status)
- UPower (for battery)

**Optional:**
- `brightnessctl` (for brightness control)
- `bluetoothctl` (for Bluetooth control)
- Nerd Fonts (for icons)

## Code Style

Follows the guidelines in `AGENTS.md`:

- 4 spaces indentation
- Imports ordered: Quickshell → Qt → local
- All magic numbers in Style.qml
- Colors via semantic mappings
- BasePill for consistent pill behavior

## Design Inspiration

- **Caelestia**: Pill shapes, vertical workspace layout, Material 3 colors
- **Noctalia**: Clean architecture, component organization, bar structure

## License

MIT

# xero-shell

A Golden Noir-themed Wayland shell for Hyprland built with Quickshell, inspired by Waybar.

## Features

- **Golden Noir theme** with gold and purple accents on true black
- **Horizontal workspace indicators** with animated transitions
- **OLED-optimized** colors and 125% scale factor
- **Pill-shaped components** with hover effects and tooltips
- **Album art display** in media player
- **System tray** with collapsible icons
- **Weather integration** via wttr.in
- **Notification center** via SwayNC
- **Zero Python dependencies** - pure QML
- **JetBrains Mono Nerd Font** for icons

## Modules

| Pill | Description | Interactions |
|------|-------------|--------------|
| **WorkspacesPill** | Horizontal workspace indicators (1-10) | Click to switch |
| **WindowTitlePill** | Active window with app icons | Right-click to close |
| **ClockPill** | Time display | Click for date, right-click for seconds |
| **MediaPill** | MPRIS media with album art | Click play/pause, scroll seek |
| **WeatherPill** | Weather from wttr.in | Hover for humidity/wind |
| **VolumePill** | PipeWire audio sink | Click mute, scroll adjust |
| **MicPill** | Microphone control | Click mute, scroll adjust |
| **NetworkPill** | WiFi/Ethernet/VPN status | Hover for details |
| **BluetoothPill** | Bluetooth status & devices | Click toggle power |
| **CpuPill** | CPU usage monitor | - |
| **MemoryPill** | RAM usage monitor | - |
| **BrightnessPill** | Display brightness | Click toggle, scroll adjust |
| **BatteryPill** | Battery with time remaining | Critical warning animation |
| **NotifyPill** | SwayNC notifications | Click toggle, right-click DND |
| **TrayPill** | System tray icons | Click to expand/collapse |

## Project Structure

```
xero-shell/
├── shell.qml                    # Main entry point
├── qmldir                       # Module exports
├── PLAN.md                      # Development roadmap
├── Commons/                     # Shared singletons
│   ├── Colors.qml              # Golden Noir + Catppuccin palette
│   └── Style.qml               # Dimensions, icons, scale factor
├── Components/                  # Reusable components
│   ├── Anim.qml                # Standard number animation
│   ├── ColorAnim.qml           # Color transition animation
│   ├── ScrollingText.qml       # Auto-scrolling text
│   └── BasePill.qml            # Base pill with hover/tooltip/feedback
└── Modules/Bar/                 # Bar module
    ├── Bar.qml                 # Main bar container
    ├── WorkspacesPill.qml      # Horizontal workspace indicator
    ├── WindowTitlePill.qml     # Active window title
    ├── ClockPill.qml           # Clock widget
    ├── MediaPill.qml           # Media player with album art
    ├── WeatherPill.qml         # Weather display
    ├── VolumePill.qml          # Audio volume control
    ├── MicPill.qml             # Microphone control
    ├── NetworkPill.qml         # Network status
    ├── BluetoothPill.qml       # Bluetooth status
    ├── CpuPill.qml             # CPU usage
    ├── MemoryPill.qml          # Memory usage
    ├── BrightnessPill.qml      # Display brightness
    ├── BatteryPill.qml         # Battery indicator
    ├── NotifyPill.qml          # Notification center
    └── TrayPill.qml            # System tray
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
// Golden Noir accent colors
readonly property color gold: "#ffd700"
readonly property color purple: "#cba6f7"

// Workspace colors
readonly property color activeWorkspace: gold
readonly property color occupiedWorkspace: purple
```

### Scale & Dimensions

Edit `Commons/Style.qml` to adjust scaling:

```qml
// Scale factor for 1080p OLED (1.25x)
readonly property real scaleFactor: 1.25

// Bar dimensions
readonly property int barHeight: Math.round(44 * scaleFactor)
readonly property int pillHeight: Math.round(32 * scaleFactor)

// Workspace settings
readonly property int maxWorkspaces: 10
```

### Bar Layout

The bar layout is defined in `Modules/Bar/Bar.qml`:

- **Left**: WorkspacesPill, WindowTitlePill
- **Center**: MediaPill, ClockPill, WeatherPill
- **Right**: CpuPill, MemoryPill, BluetoothPill, NetworkPill, MicPill, VolumePill, BrightnessPill, BatteryPill, NotifyPill, TrayPill

## Dependencies

**Required:**
- Quickshell
- Hyprland (Wayland compositor)
- PipeWire (for audio controls)
- NetworkManager (for network status)
- UPower (for battery)

**Optional:**
- `brightnessctl` (for brightness control)
- `bluetoothctl` (for Bluetooth control)
- `swaync` (for notification center)
- `curl` (for weather fetching)
- JetBrains Mono Nerd Font (for icons)

## Design

- **Theme**: Golden Noir with true black background (#040406)
- **Accents**: Gold (#ffd700) for active, Purple (#cba6f7) for occupied
- **Font**: JetBrains Mono Nerd Font
- **Inspiration**: Waybar dotfiles, Catppuccin Mocha palette

## License

MIT

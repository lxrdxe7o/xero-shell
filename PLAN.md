# xero-shell: Dotfiles Replication Plan

## Current Setup Analysis

Your dotfiles use **Waybar** as the primary bar with:
- Golden Noir / Wallust dynamic theming
- Extensive module groups (collapsible drawers)
- SwayNC for notifications
- Rofi for launching
- 40+ theme variations

## Target: 1:1 Quickshell Replication

---

## Phase 1: Bar Layout Matching

### Current Waybar Layout (TOP Default)
```
[LEFT]                    [CENTER]                         [RIGHT]
cava | playerctl | window | apps | notify | workspaces | clock | weather | idle | hint | tray | network | mobo | audio | status
```

### Required New Modules

| Module | Priority | Complexity | Description |
|--------|----------|------------|-------------|
| **WeatherPill** | High | Medium | Weather via wttr.in or OpenWeather API |
| **CavaPill** | Medium | High | Audio visualizer (cava integration) |
| **PlayerctlPill** | High | Low | Enhanced media with album art |
| **TrayPill** | High | High | System tray via Quickshell.SystemTray |
| **AppDrawerPill** | Medium | Medium | Collapsible app launcher group |
| **NotifyPill** | Medium | Low | SwayNC integration (click to toggle) |
| **IdleInhibitorPill** | Low | Low | Toggle idle/screen lock |
| **HintPill** | Low | Low | Show keybindings popup |
| **UpdaterPill** | Low | Medium | Check for system updates |

### Module Groups (Collapsible Drawers)

Your Waybar uses grouped modules that expand on hover/click:

1. **App Drawer Group**
   - Menu launcher
   - Light/Dark toggle
   - File manager
   - Terminal
   - Browser
   - Settings

2. **Mobo Drawer Group** (System Info)
   - CPU usage + temp
   - GPU usage + temp
   - Memory usage
   - Disk usage

3. **Audio Group**
   - Volume control
   - Microphone control

4. **Status Group**
   - Power menu
   - Lock screen
   - Keyboard layout/state

---

## Phase 2: Color System Overhaul

### Golden Noir Theme (Your Default)
```qml
// From waybar Golden_Noir.css
background: #040406          // True OLED black
primary: #cba6f7             // Purple (Catppuccin mauve)
accent: #ffd700              // Gold
secondary: #6E6A86           // Muted purple
text: #cdd6f4                // Light text
tooltip_bg: #1e1e2e          // Dark gray
```

### Wallust Dynamic Theme Support
- Add wallust color file parsing
- Hot-reload colors when wallpaper changes
- Color variables: color0-color15

### Theme Files to Create
```
Commons/themes/
├── GoldenNoir.qml
├── Catppuccin.qml
├── Wallust.qml (dynamic)
├── RosePine.qml
└── Aurora.qml
```

---

## Phase 3: Visual Matching

### Waybar Styling Features to Replicate

1. **Bar Background**
   - Semi-transparent black (#040406 @ 92%)
   - Optional blur effect
   - Subtle bottom border

2. **Pill Styling**
   - Rounded corners (border-radius: 10-15px)
   - Hover glow effect
   - Active state highlighting
   - Transition animations (200ms)

3. **Workspace Indicators**
   - Horizontal layout (not vertical like current)
   - Active: Gold/purple highlight
   - Occupied: Dim indicator
   - Empty: Very subtle
   - Urgent: Red pulsing

4. **Icon Styling**
   - Nerd Font icons
   - Consistent sizing
   - Color-coded by state

5. **Typography**
   - JetBrains Mono Nerd Font
   - Bold weight
   - 97% scale (~14px base)

---

## Phase 4: Feature Parity

### Missing Features to Add

| Feature | Source | Implementation |
|---------|--------|----------------|
| **Cava Visualizer** | waybar custom/cava_mviz | Process running cava, parse output |
| **Weather** | waybar custom/weather | Fetch wttr.in or OpenWeather |
| **System Tray** | waybar tray | Quickshell.SystemTray service |
| **Notification Count** | waybar custom/swaync | Read swaync-client output |
| **Package Updates** | waybar custom/updates | checkupdates command |
| **Idle Inhibitor** | waybar idle_inhibitor | Toggle hypridle via IPC |
| **Wallpaper Selector** | rofi script | Launch rofi with wallpaper script |
| **Theme Switcher** | rofi script | Swap Colors.qml themes |
| **Collapsible Groups** | waybar group/* | Animated expand/collapse |
| **Tooltips** | waybar tooltip | Already have BasePill tooltips |
| **Click Actions** | waybar on-click | Already have BasePill signals |

### Popups/Overlays to Add

1. **Calendar Popup** (on clock click)
2. **Audio Mixer Popup** (on volume right-click)
3. **Network List Popup** (on network click)
4. **Power Menu Popup** (on power click)
5. **Keybinds Popup** (on hint click)

---

## Phase 5: Layout Variations

### Layouts to Support

```
Modules/Bar/layouts/
├── TopDefault.qml       # Main horizontal top bar
├── TopMinimal.qml       # Fewer modules
├── BottomDefault.qml    # Bottom bar variant
├── LeftVertical.qml     # Vertical left bar
├── Dual.qml             # Top + bottom bars
└── Corner.qml           # Corner-positioned
```

### Layout Switching
- Store layout preference in config file
- Hot-swap layouts without restart
- Expose via settings or keybind

---

## Phase 6: Integration Points

### Hyprland IPC Commands
```qml
// Already using:
Hyprland.dispatch("workspace N")
Hyprland.dispatch("killactive")

// Need to add:
Hyprland.dispatch("exec rofi -show drun")
Hyprland.dispatch("exec wlogout")
Hyprland.dispatch("exec hyprlock")
Hyprland.dispatch("exec swaync-client -t")  // Toggle notification center
```

### External Tool Integration
- **rofi**: App launcher, theme selector, wallpaper picker
- **swaync-client**: Notification center toggle, DND, count
- **wlogout**: Power menu
- **hyprlock**: Lock screen
- **brightnessctl**: Already integrated
- **playerctl**: Media controls (enhance current)
- **cava**: Audio visualizer
- **wallust**: Dynamic theming

---

## Implementation Order

### Sprint 1: Core Layout (High Priority)
1. [ ] Horizontal workspaces (match Waybar style)
2. [ ] Enhanced PlayerctlPill with album art
3. [ ] WeatherPill
4. [ ] NotifyPill (swaync integration)
5. [ ] TrayPill (system tray)

### Sprint 2: Visual Polish
6. [ ] Golden Noir color scheme
7. [ ] Wallust dynamic theme support
8. [ ] Hover glow effects
9. [ ] Improved transitions/animations
10. [ ] JetBrains Mono font integration

### Sprint 3: Advanced Features
11. [ ] Collapsible group pills
12. [ ] CavaPill (audio visualizer)
13. [ ] Calendar popup
14. [ ] Power menu popup
15. [ ] App drawer group

### Sprint 4: Polish & Extras
16. [ ] Multiple layout support
17. [ ] Theme hot-switching
18. [ ] Keybinds popup
19. [ ] Update checker
20. [ ] Idle inhibitor

---

## File Structure (Target)

```
xero-shell/
├── shell.qml
├── qmldir
├── Commons/
│   ├── Colors.qml           # Active theme
│   ├── Style.qml            # Dimensions, icons
│   └── themes/              # Theme variants
│       ├── GoldenNoir.qml
│       ├── Catppuccin.qml
│       └── Wallust.qml
├── Components/
│   ├── BasePill.qml
│   ├── ScrollingText.qml
│   ├── CollapsibleGroup.qml  # NEW
│   ├── PopupPanel.qml        # NEW
│   ├── Anim.qml
│   └── ColorAnim.qml
├── Modules/
│   └── Bar/
│       ├── Bar.qml
│       ├── layouts/          # NEW
│       │   ├── TopDefault.qml
│       │   └── ...
│       ├── pills/
│       │   ├── WorkspacesPill.qml
│       │   ├── WindowTitlePill.qml
│       │   ├── ClockPill.qml
│       │   ├── MediaPill.qml
│       │   ├── VolumePill.qml
│       │   ├── MicPill.qml
│       │   ├── NetworkPill.qml
│       │   ├── BluetoothPill.qml
│       │   ├── CpuPill.qml
│       │   ├── MemoryPill.qml
│       │   ├── BatteryPill.qml
│       │   ├── BrightnessPill.qml
│       │   ├── WeatherPill.qml      # NEW
│       │   ├── TrayPill.qml         # NEW
│       │   ├── NotifyPill.qml       # NEW
│       │   ├── CavaPill.qml         # NEW
│       │   ├── IdlePill.qml         # NEW
│       │   └── UpdaterPill.qml      # NEW
│       └── popups/           # NEW
│           ├── CalendarPopup.qml
│           ├── AudioPopup.qml
│           ├── PowerPopup.qml
│           └── KeybindsPopup.qml
└── scripts/                  # NEW
    ├── weather.sh
    ├── updates.sh
    └── wallust-colors.sh
```

---

## Summary

To fully replicate your Waybar setup in Quickshell:

| Category | Current | Target | Gap |
|----------|---------|--------|-----|
| **Pills** | 12 | 18+ | +6 new modules |
| **Themes** | 1 (OLED) | 5+ | +4 theme files |
| **Layouts** | 1 | 6 | +5 layout variants |
| **Popups** | 0 | 4+ | +4 popup panels |
| **Groups** | 0 | 4 | +4 collapsible groups |

**Estimated Effort**: 4 sprints / major updates

---

## Quick Wins (Can Do Now)

1. **Horizontal workspaces** - Simple layout change
2. **Golden Noir colors** - Update Colors.qml
3. **JetBrains Mono font** - Update Style.qml
4. **WeatherPill** - wttr.in fetch
5. **NotifyPill** - swaync-client integration

Would you like me to start implementing any of these?

# xero-shell

A minimal, Caelestia-inspired Wayland shell for Hyprland/Sway built with Quickshell.

## Features

- **Pill-shaped components** inspired by Caelestia's design
- **Catppuccin Mocha** color scheme
- **Workspace indicator** with active/occupied states
- **Clean architecture** following Noctalia's structure
- **Zero Python dependencies** - pure QML
- **Smooth animations** with Material-inspired easing curves

## Project Structure

```
xero-shell/
├── shell.qml              # Main entry point
├── Commons/               # Shared singletons
│   ├── Colors.qml        # Catppuccin Mocha palette
│   └── Style.qml         # Spacing, animations, dimensions
├── Components/            # Reusable animation components
│   ├── Anim.qml
│   └── ColorAnim.qml
└── Modules/Bar/           # Bar module
    ├── Bar.qml           # Main bar component
    ├── WorkspacesPill.qml # Workspace indicator
    └── ClockPill.qml     # Clock widget
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

Edit `Commons/Colors.qml` to change the color scheme. The current palette uses Catppuccin Mocha.

### Dimensions

Edit `Commons/Style.qml` to adjust:

- Bar height (`barHeight: 40`)
- Pill padding (`pillPaddingHorizontal: 12`)
- Spacing values
- Animation durations

### Components

The bar layout is defined in `Modules/Bar/Bar.qml` using a `RowLayout`:

- Left: WorkspacesPill
- Center: ClockPill
- Right: System indicators (placeholder)

## Code Style

Follows the guidelines in `AGENTS.md`:

- 4 spaces indentation
- Imports ordered: Quickshell → Qt → local
- Properties before functions
- Catppuccin color references via `Colors.propertyName`
- Animations via `Behavior on` blocks

## Implementation Details

### Pill Shape

Pills use `ClippingRectangle` with:

```qml
radius: Style.radiusFull  // 500 (effectively height/2)
```

### Workspace Integration

Uses `Quickshell.Hyprland` module for workspace management:

- Filters workspaces by monitor
- Shows 5 workspaces per bar
- Active state from `Hyprland.focusedWorkspace`
- Click to switch: `Hyprland.dispatch("workspace N")`

### Animations

Standard animations use Material Design curves:

- `Anim.qml`: 300ms OutCubic for size changes
- `ColorAnim.qml`: 200ms InOutQuad for color transitions

## Design Inspiration

- **Caelestia**: Pill shapes, vertical workspace layout, Material 3 colors
- **Noctalia**: Clean architecture, component organization, bar structure

## License

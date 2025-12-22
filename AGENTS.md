# Agent Guidelines for xero-shell

## Project Type
Quickshell configuration written in QML for Wayland compositors (Hyprland). Inspired by Caelestia's aesthetic without Python dependencies.

## Project Structure
```
xero-shell/
├── Commons/        # Singletons (Colors, Style)
├── Components/     # Reusable components (Anim, ColorAnim)
├── Modules/        # Major UI modules (Bar/)
├── qmldir          # Module definition
└── shell.qml       # Entry point
```

## Testing
- Run: `quickshell` (from project directory)
- Test component: `quickshell -c Modules/Bar/Bar.qml`
- Verify visually in Hyprland session

## Code Style

### Imports
```qml
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
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
- Reference: `Colors.blue`, `Colors.surface0`, `Colors.activeWorkspace`
- Semantic colors preferred (`Colors.primary` over `Colors.blue`)
- Never hardcode hex values outside `Colors.qml`

### Styling & Dimensions
- All spacing/sizing in `Commons/Style.qml`
- Reference: `Style.paddingSmall`, `Style.radiusFull`, `Style.animationNormal`
- Pills use `radius: Style.radiusFull` (500px, effectively height/2)
- Never hardcode dimensions outside `Style.qml`

### Animations
- Use `Anim {}` component for standard animations (300ms, OutCubic)
- Use `ColorAnim {}` for color transitions (150ms, OutCubic)
- Always wrap animations in `Behavior on property { Anim {} }`
- Example:
```qml
Behavior on color { ColorAnim {} }
Behavior on width { Anim {} }
```

### Hyprland Integration
- Access workspaces: `Hyprland.workspaces.values`
- Active workspace: `Hyprland.focusedWorkspace?.id`
- Dispatch commands: `Hyprland.dispatch("workspace 1")`
- Use optional chaining (`?.`) for null safety

### Component Patterns
- Use `ClippingRectangle` for pills (from Quickshell.Widgets)
- Use `WlrLayershell` for shell surfaces (not WaylandWindowpane)
- Required properties: `required property var screen`
- Readonly computed properties: `readonly property int activeWorkspaceId: ...`

### Error Handling
- Use `console.log()` for debug output
- Mark integration TODOs: `// TODO: Connect to volume service`
- Always use null-safe operators: `ws?.lastWindow`, `id ?? defaultValue`

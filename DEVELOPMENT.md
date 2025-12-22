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

### File Organization

- **Commons/**: Singletons accessible everywhere (Colors, Style)
- **Components/**: Reusable building blocks (Anim, ColorAnim)
- **Modules/**: Feature modules (Bar with its pills)

### Adding a New Pill Component

1. Create file in `Modules/Bar/YourPill.qml`:

```qml
import Quickshell
import Quickshell.Widgets
import QtQuick
import "../../Commons"
import "../../Components"

ClippingRectangle {
    id: root

    implicitWidth: content.implicitWidth + Style.pillPaddingHorizontal * 2
    implicitHeight: Style.pillHeight

    color: Colors.pillBackground
    radius: Style.radiusFull

    Behavior on color { ColorAnim {} }

    Text {
        id: content
        anchors.centerIn: parent
        text: "Your Content"
        color: Colors.pillText
        font.pixelSize: Style.fontSizeNormal
    }
}
```

2. Add to `qmldir`:
```
YourPill 1.0 Modules/Bar/YourPill.qml
```

3. Use in `Modules/Bar/Bar.qml`:
```qml
YourPill {
    Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter
}
```

### Color Scheme

All colors from `Commons/Colors.qml`. Key ones:

- `Colors.blue` - Primary accent (active workspace)
- `Colors.surface0` - Pill backgrounds
- `Colors.text` - Primary text
- `Colors.barBackground` - Bar background (mantle)

### Animation Pattern

Use `Behavior on` for smooth transitions:

```qml
Rectangle {
    color: isActive ? Colors.blue : Colors.surface0
    
    Behavior on color {
        ColorAnim {}  // 200ms InOutQuad
    }
}
```

For size changes:
```qml
Rectangle {
    width: isExpanded ? 200 : 50
    
    Behavior on width {
        Anim {}  // 300ms OutCubic
    }
}
```

### Hyprland Integration

Access workspaces:
```qml
readonly property var workspaces: Hyprland.workspaces.values
readonly property int activeId: Hyprland.focusedWorkspace?.id ?? 1
```

Switch workspace:
```qml
MouseArea {
    onClicked: Hyprland.dispatch("workspace " + workspaceId)
}
```

### Debugging

Check quickshell logs:
```bash
tail -f /run/user/1000/quickshell/by-id/*/log.qslog
```

Enable debug output in QML:
```qml
Component.onCompleted: {
    console.log("Component loaded:", root)
}
```

### Common Issues

**"Type X unavailable"**
- Add to `qmldir` if it's a custom component
- Check import paths are correct

**"Property X is not defined"**
- Check if component is loaded (`active: true` in Loader)
- Verify property exists in model data

**Colors not updating**
- Check `Behavior on color` is present
- Verify singleton is imported correctly

### Performance Tips

1. Use `ClippingRectangle` instead of `Rectangle` + `clip: true`
2. Lazy load with `Loader { active: condition }`
3. Use `Behavior on` instead of manual animations
4. Keep model filtering in `readonly property` for caching

### Next Steps

Ideas for expansion:
- System tray integration (Quickshell.Services.SystemTray)
- Audio widget (Quickshell.Services.Pipewire)
- Battery indicator (Quickshell.Services.UPower)
- Network status
- Notification center
- App launcher

See Caelestia and Noctalia references in `/home/xero/codespace/rice-lab/` for implementation examples.

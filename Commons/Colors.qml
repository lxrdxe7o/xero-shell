pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // ========================================
    // Theme Mode
    // ========================================
    property bool highContrast: false
    property bool oledMode: true  // Optimized for OLED displays

    // ========================================
    // Catppuccin Mocha Palette (OLED Optimized)
    // ========================================
    readonly property color rosewater: "#f5e0dc"
    readonly property color flamingo: "#f2cdcd"
    readonly property color pink: "#f5c2e7"
    readonly property color mauve: "#cba6f7"
    readonly property color red: "#f38ba8"
    readonly property color maroon: "#eba0ac"
    readonly property color peach: "#fab387"
    readonly property color yellow: "#f9e2af"
    readonly property color green: "#a6e3a1"
    readonly property color teal: "#94e2d5"
    readonly property color sky: "#89dceb"
    readonly property color sapphire: "#74c7ec"
    readonly property color blue: "#89b4fa"
    readonly property color lavender: "#b4befe"

    // Text colors - slightly dimmed for OLED
    readonly property color text: highContrast ? "#ffffff" : (oledMode ? "#c8d0e8" : "#cdd6f4")
    readonly property color subtext1: highContrast ? "#e0e0e0" : (oledMode ? "#a8b0c8" : "#bac2de")
    readonly property color subtext0: highContrast ? "#c0c0c0" : (oledMode ? "#909ab0" : "#a6adc8")
    readonly property color overlay2: oledMode ? "#7a8098" : "#9399b2"
    readonly property color overlay1: oledMode ? "#686e84" : "#7f849c"
    readonly property color overlay0: oledMode ? "#565c70" : "#6c7086"

    // Surface colors - true blacks for OLED
    readonly property color surface2: oledMode ? "#3a3d4d" : "#585b70"
    readonly property color surface1: oledMode ? "#252836" : "#45475a"
    readonly property color surface0: oledMode ? "#181a24" : "#313244"
    readonly property color base: oledMode ? "#0a0c12" : "#1e1e2e"
    readonly property color mantle: oledMode ? "#050608" : "#181825"
    readonly property color crust: oledMode ? "#000000" : "#11111b"  // True black for OLED

    // ========================================
    // Semantic Color Mappings (Material 3 inspired)
    // ========================================
    readonly property color primary: blue
    readonly property color onPrimary: base
    readonly property color primaryContainer: Qt.alpha(blue, 0.25)  // Slightly less opacity for OLED
    readonly property color onPrimaryContainer: blue

    readonly property color secondary: mauve
    readonly property color onSecondary: base
    readonly property color secondaryContainer: Qt.alpha(mauve, 0.25)
    readonly property color onSecondaryContainer: mauve

    readonly property color tertiary: teal
    readonly property color onTertiary: base

    readonly property color surface: surface0
    readonly property color onSurface: text
    readonly property color surfaceVariant: surface1
    readonly property color onSurfaceVariant: subtext0
    readonly property color surfaceDim: mantle

    readonly property color outline: overlay0
    readonly property color outlineVariant: surface2

    readonly property color error: red
    readonly property color onError: base
    readonly property color errorContainer: Qt.alpha(red, 0.25)

    readonly property color warning: yellow
    readonly property color onWarning: base
    readonly property color warningContainer: Qt.alpha(yellow, 0.25)

    readonly property color success: green
    readonly property color onSuccess: base
    readonly property color successContainer: Qt.alpha(green, 0.25)

    readonly property color info: sapphire
    readonly property color onInfo: base

    // ========================================
    // Bar-Specific Colors (OLED Optimized)
    // ========================================
    readonly property color barBackground: oledMode ? "#000000" : mantle  // True black for OLED
    readonly property color pillBackground: oledMode ? "#0f1118" : surface0  // Very dark for OLED
    readonly property color pillBackgroundHover: oledMode ? "#1a1d28" : surface1
    readonly property color pillText: text
    readonly property color pillTextMuted: subtext0
    readonly property color pillIcon: oledMode ? "#a0a8c0" : text  // Slightly dimmed icons
    readonly property color pillIconMuted: overlay0

    // ========================================
    // Workspace Colors (OLED Optimized)
    // ========================================
    readonly property color activeWorkspace: blue
    readonly property color occupiedWorkspace: oledMode ? "#3a3d4d" : surface2
    readonly property color emptyWorkspace: Qt.alpha(surface1, oledMode ? 0.4 : 0.5)
    readonly property color urgentWorkspace: red

    // ========================================
    // Status Colors (Slightly dimmed for OLED)
    // ========================================
    readonly property color statusOnline: oledMode ? "#8cd694" : green
    readonly property color statusOffline: overlay0
    readonly property color statusBusy: oledMode ? "#e5d49a" : yellow
    readonly property color statusError: oledMode ? "#e07888" : red

    readonly property color batteryNormal: text
    readonly property color batteryCharging: oledMode ? "#7aa8e8" : blue
    readonly property color batteryLow: oledMode ? "#e5d49a" : yellow
    readonly property color batteryCritical: oledMode ? "#e07888" : red

    readonly property color networkConnected: text
    readonly property color networkDisconnected: overlay0
    readonly property color networkWeak: oledMode ? "#e5d49a" : yellow

    readonly property color mediaPlaying: oledMode ? "#7aa8e8" : blue
    readonly property color mediaPaused: overlay0

    // ========================================
    // Interactive States
    // ========================================
    readonly property color hover: Qt.alpha(text, 0.08)  // Less bright hover for OLED
    readonly property color pressed: Qt.alpha(text, 0.15)
    readonly property color focused: Qt.alpha(primary, 0.25)
    readonly property color disabled: Qt.alpha(text, 0.35)

    // ========================================
    // Special Colors
    // ========================================
    readonly property color transparent: "transparent"
    readonly property color scrim: Qt.alpha(crust, 0.85)

    // ========================================
    // Helper Functions
    // ========================================

    function withAlpha(baseColor: color, alpha: real): color {
        return Qt.alpha(baseColor, alpha)
    }

    function lighten(baseColor: color, factor: real): color {
        return Qt.lighter(baseColor, 1 + factor)
    }

    function darken(baseColor: color, factor: real): color {
        return Qt.darker(baseColor, 1 + factor)
    }

    function blend(color1: color, color2: color, ratio: real): color {
        return Qt.rgba(
            color1.r * (1 - ratio) + color2.r * ratio,
            color1.g * (1 - ratio) + color2.g * ratio,
            color1.b * (1 - ratio) + color2.b * ratio,
            color1.a * (1 - ratio) + color2.a * ratio
        )
    }

    // Get appropriate text color for a background
    function textOn(background: color): color {
        const luminance = 0.299 * background.r + 0.587 * background.g + 0.114 * background.b
        return luminance > 0.5 ? base : text
    }

    // Dim a color for OLED (reduces brightness while preserving hue)
    function dimForOled(baseColor: color, factor: real): color {
        if (!oledMode) return baseColor
        return Qt.darker(baseColor, 1 + factor)
    }
}

pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // ========================================
    // Theme: Golden Noir (from Waybar)
    // ========================================

    // Base Colors
    readonly property color background: "#040406"
    readonly property color backgroundAlt: "#0a0a0f"
    readonly property color foreground: "#cdd6f4"
    readonly property color foregroundAlt: "#6E6A86"

    // Accent Colors (Golden Noir)
    readonly property color gold: "#ffd700"
    readonly property color purple: "#cba6f7"
    readonly property color mauve: "#cba6f7"

    // Catppuccin Mocha Palette
    readonly property color rosewater: "#f5e0dc"
    readonly property color flamingo: "#f2cdcd"
    readonly property color pink: "#f5c2e7"
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

    readonly property color text: "#cdd6f4"
    readonly property color subtext1: "#bac2de"
    readonly property color subtext0: "#a6adc8"
    readonly property color overlay2: "#9399b2"
    readonly property color overlay1: "#7f849c"
    readonly property color overlay0: "#6c7086"
    readonly property color surface2: "#585b70"
    readonly property color surface1: "#45475a"
    readonly property color surface0: "#313244"
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"

    // ========================================
    // Semantic Colors
    // ========================================
    readonly property color primary: gold
    readonly property color onPrimary: background
    readonly property color primaryContainer: Qt.alpha(gold, 0.2)
    readonly property color onPrimaryContainer: gold

    readonly property color secondary: purple
    readonly property color onSecondary: background
    readonly property color secondaryContainer: Qt.alpha(purple, 0.2)
    readonly property color onSecondaryContainer: purple

    readonly property color error: red
    readonly property color onError: background
    readonly property color errorContainer: Qt.alpha(red, 0.2)

    readonly property color warning: yellow
    readonly property color onWarning: background
    readonly property color warningContainer: Qt.alpha(yellow, 0.2)

    readonly property color success: green
    readonly property color onSuccess: background
    readonly property color successContainer: Qt.alpha(green, 0.2)

    readonly property color info: sapphire
    readonly property color onInfo: background

    // ========================================
    // Bar Colors
    // ========================================
    readonly property color barBackground: background
    readonly property color pillBackground: "#0f0f14"
    readonly property color pillBackgroundHover: "#1a1a22"
    readonly property color pillText: foreground
    readonly property color pillTextMuted: foregroundAlt
    readonly property color pillIcon: purple
    readonly property color pillIconMuted: foregroundAlt

    // ========================================
    // Workspace Colors
    // ========================================
    readonly property color activeWorkspace: gold
    readonly property color occupiedWorkspace: purple
    readonly property color emptyWorkspace: Qt.alpha(surface1, 0.4)
    readonly property color urgentWorkspace: red

    // ========================================
    // Status Colors
    // ========================================
    readonly property color batteryNormal: foreground
    readonly property color batteryCharging: green
    readonly property color batteryLow: yellow
    readonly property color batteryCritical: red

    readonly property color networkConnected: green
    readonly property color networkDisconnected: foregroundAlt
    readonly property color networkWeak: yellow

    readonly property color mediaPlaying: gold
    readonly property color mediaPaused: foregroundAlt

    readonly property color notifyActive: purple
    readonly property color notifyDnd: red
    readonly property color notifyNone: foregroundAlt

    // ========================================
    // Interactive States
    // ========================================
    readonly property color hover: Qt.alpha(gold, 0.1)
    readonly property color pressed: Qt.alpha(gold, 0.2)
    readonly property color focused: Qt.alpha(gold, 0.15)
    readonly property color disabled: Qt.alpha(foreground, 0.3)

    // ========================================
    // Special Colors
    // ========================================
    readonly property color transparent: "transparent"
    readonly property color scrim: Qt.alpha(background, 0.9)

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
}

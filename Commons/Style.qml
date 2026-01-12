pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // ========================================
    // Display Configuration
    // ========================================
    // Scale factor for 1080p OLED (125%)
    readonly property real scaleFactor: 1.25

    // ========================================
    // Font Configuration (Scaled for 1080p)
    // ========================================
    readonly property string fontFamily: "monospace"
    readonly property string iconFont: "monospace"  // Nerd Fonts compatible

    // Font sizes - scaled up for 1080p readability
    readonly property int fontSizeSmall: Math.round(12 * scaleFactor)   // 15
    readonly property int fontSizeNormal: Math.round(14 * scaleFactor)  // 18
    readonly property int fontSizeLarge: Math.round(16 * scaleFactor)   // 20
    readonly property int fontSizeXLarge: Math.round(20 * scaleFactor)  // 25

    // ========================================
    // Spacing Values (Scaled)
    // ========================================
    readonly property int spacingSmall: Math.round(4 * scaleFactor)    // 5
    readonly property int spacingNormal: Math.round(8 * scaleFactor)   // 10
    readonly property int spacingLarge: Math.round(12 * scaleFactor)   // 15
    readonly property int spacingXLarge: Math.round(16 * scaleFactor)  // 20

    // ========================================
    // Padding Values (Scaled)
    // ========================================
    readonly property int paddingSmall: Math.round(6 * scaleFactor)    // 8
    readonly property int paddingNormal: Math.round(10 * scaleFactor)  // 13
    readonly property int paddingLarge: Math.round(16 * scaleFactor)   // 20

    // ========================================
    // Border Radius Values (Scaled)
    // ========================================
    readonly property int radiusSmall: Math.round(8 * scaleFactor)     // 10
    readonly property int radiusNormal: Math.round(12 * scaleFactor)   // 15
    readonly property int radiusLarge: Math.round(16 * scaleFactor)    // 20
    readonly property int radiusFull: 500  // For pill shapes (effectively height/2)

    // ========================================
    // Animation Configuration
    // ========================================
    readonly property int animationFast: 150
    readonly property int animationNormal: 300
    readonly property int animationSlow: 450

    // Easing curves (Material Design inspired)
    readonly property var easingStandard: [0.2, 0, 0, 1]
    readonly property var easingEmphasized: [0.05, 0.7, 0.1, 1]

    // ========================================
    // Bar Configuration (Scaled for 1080p)
    // ========================================
    readonly property int barHeight: Math.round(44 * scaleFactor)      // 55
    readonly property int barPadding: Math.round(8 * scaleFactor)      // 10
    readonly property real barOpacity: 0.92  // Slightly more transparent for OLED

    // ========================================
    // Pill Configuration (Scaled for 1080p)
    // ========================================
    readonly property int pillHeight: Math.round(36 * scaleFactor)     // 45
    readonly property int pillPaddingHorizontal: Math.round(14 * scaleFactor)  // 18
    readonly property int pillMinWidth: Math.round(36 * scaleFactor)   // 45

    // Pill max widths (scaled)
    readonly property int pillMaxWidth: Math.round(400 * scaleFactor)  // 500
    readonly property int titleMaxWidth: Math.round(300 * scaleFactor) // 375
    readonly property int mediaMaxWidth: Math.round(250 * scaleFactor) // 313
    readonly property int ssidMaxWidth: Math.round(150 * scaleFactor)  // 188

    // ========================================
    // Workspace Configuration (Scaled)
    // ========================================
    readonly property int maxWorkspaces: 5
    readonly property real workspaceInactiveScale: 0.7

    // ========================================
    // Scrolling Text Configuration
    // ========================================
    readonly property int scrollPauseDuration: 2000
    readonly property int scrollSpeed: 15  // ms per pixel

    // ========================================
    // Polling Intervals (ms)
    // ========================================
    readonly property int networkPollInterval: 5000
    readonly property int cpuPollInterval: 2000
    readonly property int memoryPollInterval: 3000
    readonly property int bluetoothPollInterval: 10000
    readonly property int brightnessPollInterval: 1000
    readonly property int clockUpdateInterval: 1000

    // ========================================
    // Volume Configuration
    // ========================================
    readonly property real volumeStep: 0.05  // 5% per scroll
    readonly property int wheelThreshold: 120

    // ========================================
    // Battery Configuration
    // ========================================
    readonly property int batteryLowThreshold: 20
    readonly property int batteryCriticalThreshold: 10

    // ========================================
    // Media Player Configuration
    // ========================================
    readonly property int seekAmount: 5000000  // 5 seconds in microseconds

    // ========================================
    // Opacity Levels
    // ========================================
    readonly property real opacityDisabled: 0.5
    readonly property real opacityHidden: 0.0
    readonly property real opacityFull: 1.0
    readonly property real opacityHover: 0.8

    // ========================================
    // Feedback Animation Scale Values
    // ========================================
    readonly property real feedbackScaleUp: 1.08
    readonly property real feedbackScaleDown: 0.95

    // ========================================
    // Icon Mappings (Nerd Fonts)
    // ========================================

    // Volume icons
    readonly property string iconVolumeMuted: "󰝟"
    readonly property string iconVolumeOff: "󰝟"
    readonly property string iconVolumeLow: "󰕿"
    readonly property string iconVolumeMedium: "󰖀"
    readonly property string iconVolumeHigh: "󰕾"

    // Battery icons
    readonly property string iconBatteryUnknown: "󰂎"
    readonly property string iconBatteryCharging: "󰂄"
    readonly property var iconBatteryLevels: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

    // Network icons
    readonly property string iconEthernet: "󰈀"
    readonly property string iconWifiOff: "󰖪"
    readonly property var iconWifiLevels: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]
    readonly property string iconVpn: "󰦝"

    // Media icons
    readonly property string iconPlay: "󰐊"
    readonly property string iconPause: "󰏤"
    readonly property string iconNext: "󰒭"
    readonly property string iconPrevious: "󰒮"

    // System icons
    readonly property string iconCpu: "󰻠"
    readonly property string iconMemory: "󰍛"
    readonly property string iconBluetooth: "󰂯"
    readonly property string iconBluetoothOff: "󰂲"
    readonly property string iconBluetoothConnected: "󰂱"
    readonly property string iconMic: "󰍬"
    readonly property string iconMicMuted: "󰍭"
    readonly property string iconBrightness: "󰃟"
    readonly property string iconBrightnessLow: "󰃞"
    readonly property string iconBrightnessHigh: "󰃠"
    readonly property string iconClock: "󰥔"
    readonly property string iconCalendar: "󰃭"

    // Window icons
    readonly property string iconWindow: "󰖲"
    readonly property string iconBrowser: "󰈹"
    readonly property string iconCode: "󰨞"
    readonly property string iconTerminal: "󰆍"
    readonly property string iconDiscord: "󰙯"
    readonly property string iconMusic: "󰓇"
    readonly property string iconFiles: "󰉋"

    // ========================================
    // Helper Functions
    // ========================================

    function getWifiIcon(strength: int): string {
        if (strength >= 80) return iconWifiLevels[4]
        if (strength >= 60) return iconWifiLevels[3]
        if (strength >= 40) return iconWifiLevels[2]
        if (strength >= 20) return iconWifiLevels[1]
        return iconWifiLevels[0]
    }

    function getBatteryIcon(percent: int, charging: bool): string {
        if (charging) return iconBatteryCharging
        const index = Math.min(9, Math.floor(percent / 10))
        return iconBatteryLevels[index]
    }

    function getVolumeIcon(volume: real, muted: bool): string {
        if (muted) return iconVolumeMuted
        if (volume >= 0.67) return iconVolumeHigh
        if (volume >= 0.33) return iconVolumeMedium
        if (volume > 0) return iconVolumeLow
        return iconVolumeOff
    }

    function getBrightnessIcon(brightness: real): string {
        if (brightness >= 0.67) return iconBrightnessHigh
        if (brightness >= 0.33) return iconBrightness
        return iconBrightnessLow
    }
}

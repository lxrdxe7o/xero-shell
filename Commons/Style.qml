pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // ========================================
    // Display Configuration
    // ========================================
    readonly property real scaleFactor: 1.25

    // ========================================
    // Font Configuration
    // ========================================
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string iconFont: "JetBrainsMono Nerd Font"

    readonly property int fontSizeSmall: Math.round(11 * scaleFactor)
    readonly property int fontSizeNormal: Math.round(13 * scaleFactor)
    readonly property int fontSizeLarge: Math.round(15 * scaleFactor)
    readonly property int fontSizeXLarge: Math.round(18 * scaleFactor)

    // ========================================
    // Spacing Values
    // ========================================
    readonly property int spacingSmall: Math.round(4 * scaleFactor)
    readonly property int spacingNormal: Math.round(8 * scaleFactor)
    readonly property int spacingLarge: Math.round(12 * scaleFactor)
    readonly property int spacingXLarge: Math.round(16 * scaleFactor)

    // ========================================
    // Padding Values
    // ========================================
    readonly property int paddingSmall: Math.round(6 * scaleFactor)
    readonly property int paddingNormal: Math.round(10 * scaleFactor)
    readonly property int paddingLarge: Math.round(16 * scaleFactor)

    // ========================================
    // Border Radius Values
    // ========================================
    readonly property int radiusSmall: Math.round(6 * scaleFactor)
    readonly property int radiusNormal: Math.round(10 * scaleFactor)
    readonly property int radiusLarge: Math.round(14 * scaleFactor)
    readonly property int radiusFull: 500

    // ========================================
    // Animation Configuration
    // ========================================
    readonly property int animationFast: 150
    readonly property int animationNormal: 250
    readonly property int animationSlow: 400

    readonly property var easingStandard: [0.2, 0, 0, 1]
    readonly property var easingEmphasized: [0.05, 0.7, 0.1, 1]

    // ========================================
    // Bar Configuration
    // ========================================
    readonly property int barHeight: Math.round(40 * scaleFactor)
    readonly property int barPadding: Math.round(6 * scaleFactor)
    readonly property real barOpacity: 0.95

    // ========================================
    // Pill Configuration
    // ========================================
    readonly property int pillHeight: Math.round(32 * scaleFactor)
    readonly property int pillPaddingHorizontal: Math.round(12 * scaleFactor)
    readonly property int pillMinWidth: Math.round(32 * scaleFactor)

    readonly property int pillMaxWidth: Math.round(350 * scaleFactor)
    readonly property int titleMaxWidth: Math.round(250 * scaleFactor)
    readonly property int mediaMaxWidth: Math.round(200 * scaleFactor)
    readonly property int ssidMaxWidth: Math.round(120 * scaleFactor)

    // ========================================
    // Workspace Configuration (Horizontal)
    // ========================================
    readonly property int maxWorkspaces: 10
    readonly property int workspaceActiveWidth: Math.round(24 * scaleFactor)
    readonly property int workspaceActiveHeight: Math.round(24 * scaleFactor)
    readonly property int workspaceInactiveWidth: Math.round(8 * scaleFactor)
    readonly property int workspaceInactiveHeight: Math.round(8 * scaleFactor)

    // ========================================
    // Scrolling Text Configuration
    // ========================================
    readonly property int scrollPauseDuration: 2000
    readonly property int scrollSpeed: 15

    // ========================================
    // Polling Intervals (ms)
    // ========================================
    readonly property int networkPollInterval: 5000
    readonly property int cpuPollInterval: 2000
    readonly property int memoryPollInterval: 3000
    readonly property int bluetoothPollInterval: 10000
    readonly property int brightnessPollInterval: 1000
    readonly property int clockUpdateInterval: 1000
    readonly property int weatherPollInterval: 600000  // 10 minutes
    readonly property int notifyPollInterval: 2000
    readonly property int updatesPollInterval: 3600000  // 1 hour

    // ========================================
    // Volume Configuration
    // ========================================
    readonly property real volumeStep: 0.05
    readonly property int wheelThreshold: 120

    // ========================================
    // Battery Configuration
    // ========================================
    readonly property int batteryLowThreshold: 20
    readonly property int batteryCriticalThreshold: 10

    // ========================================
    // Media Player Configuration
    // ========================================
    readonly property int seekAmount: 5000000

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
    readonly property real feedbackScaleUp: 1.06
    readonly property real feedbackScaleDown: 0.96

    // ========================================
    // Icon Mappings (Nerd Fonts)
    // ========================================

    // Volume
    readonly property string iconVolumeMuted: "󰝟"
    readonly property string iconVolumeOff: "󰝟"
    readonly property string iconVolumeLow: "󰕿"
    readonly property string iconVolumeMedium: "󰖀"
    readonly property string iconVolumeHigh: "󰕾"

    // Battery
    readonly property string iconBatteryUnknown: "󰂎"
    readonly property string iconBatteryCharging: "󰂄"
    readonly property var iconBatteryLevels: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

    // Network
    readonly property string iconEthernet: "󰈀"
    readonly property string iconWifiOff: "󰖪"
    readonly property var iconWifiLevels: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]
    readonly property string iconVpn: "󰦝"

    // Media
    readonly property string iconPlay: "󰐊"
    readonly property string iconPause: "󰏤"
    readonly property string iconNext: "󰒭"
    readonly property string iconPrevious: "󰒮"
    readonly property string iconMusic: "󰎈"

    // System
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

    // Window
    readonly property string iconWindow: "󰖲"
    readonly property string iconBrowser: "󰈹"
    readonly property string iconCode: "󰨞"
    readonly property string iconTerminal: "󰆍"
    readonly property string iconDiscord: "󰙯"
    readonly property string iconFiles: "󰉋"

    // Weather
    readonly property string iconWeatherSunny: "󰖙"
    readonly property string iconWeatherCloudy: "󰖐"
    readonly property string iconWeatherRainy: "󰖗"
    readonly property string iconWeatherSnowy: "󰖘"
    readonly property string iconWeatherStormy: "󰖓"
    readonly property string iconWeatherFoggy: "󰖑"
    readonly property string iconWeatherWindy: "󰖝"
    readonly property string iconWeatherNight: "󰖔"

    // Notifications
    readonly property string iconNotification: "󰂚"
    readonly property string iconNotificationNone: "󰂜"
    readonly property string iconNotificationDnd: "󰂛"

    // Power
    readonly property string iconPower: "󰐥"
    readonly property string iconLock: "󰌾"
    readonly property string iconLogout: "󰍃"
    readonly property string iconReboot: "󰜉"
    readonly property string iconSleep: "󰤄"

    // Updates
    readonly property string iconUpdates: "󰚰"
    readonly property string iconUpdatesNone: "󰗠"

    // Tray
    readonly property string iconTray: "󰏘"

    // Idle
    readonly property string iconIdle: "󰛐"
    readonly property string iconIdleOff: "󰛑"

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

    function getWeatherIcon(code: string): string {
        // WMO Weather codes
        if (code === "0") return iconWeatherSunny
        if (["1", "2", "3"].includes(code)) return iconWeatherCloudy
        if (["45", "48"].includes(code)) return iconWeatherFoggy
        if (["51", "53", "55", "61", "63", "65", "80", "81", "82"].includes(code)) return iconWeatherRainy
        if (["71", "73", "75", "77", "85", "86"].includes(code)) return iconWeatherSnowy
        if (["95", "96", "99"].includes(code)) return iconWeatherStormy
        return iconWeatherCloudy
    }
}

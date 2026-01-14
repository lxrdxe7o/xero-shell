import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    readonly property var activeWindow: Hyprland.focusedWindow
    readonly property string windowTitle: activeWindow?.title ?? "Desktop"
    readonly property string windowClass: activeWindow?.class ?? ""
    readonly property bool hasWindow: activeWindow !== null

    implicitWidth: Math.min(titleRow.implicitWidth + Style.pillPaddingHorizontal * 2, Style.pillMaxWidth)
    pillColor: hasWindow ? Colors.pillBackground : Qt.alpha(Colors.pillBackground, Style.opacityDisabled)
    tooltip: hasWindow ? windowTitle : "No active window"

    onClicked: {
        if (hasWindow) {
            // Could open window switcher or action menu
        }
    }

    onRightClicked: {
        if (hasWindow) {
            Hyprland.dispatch("killactive")
        }
    }

    Row {
        id: titleRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // App icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: getWindowIcon(root.windowClass)
            color: root.hasWindow ? Colors.primary : Colors.pillIconMuted
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont
            visible: root.hasWindow

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Window title with scrolling
        ScrollingText {
            anchors.verticalCenter: parent.verticalCenter
            text: root.windowTitle
            color: root.hasWindow ? Colors.pillText : Colors.pillTextMuted
            maxWidth: Style.titleMaxWidth
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
        }
    }

    // Window change animation
    onWindowTitleChanged: pulse()
    onWindowClassChanged: pulse()

    // Icon mapping function
    function getWindowIcon(windowClass: string): string {
        const cls = windowClass.toLowerCase()

        // Browsers
        if (cls.includes("firefox") || cls.includes("librewolf"))
            return Style.iconBrowser
        if (cls.includes("chrome") || cls.includes("chromium") || cls.includes("brave"))
            return Style.iconBrowser

        // Development
        if (cls.includes("code") || cls.includes("codium") || cls.includes("vscodium"))
            return Style.iconCode
        if (cls.includes("nvim") || cls.includes("vim") || cls.includes("neovide"))
            return Style.iconCode
        if (cls.includes("jetbrains") || cls.includes("idea") || cls.includes("webstorm"))
            return Style.iconCode

        // Terminals
        if (cls.includes("terminal") || cls.includes("kitty") || cls.includes("alacritty"))
            return Style.iconTerminal
        if (cls.includes("wezterm") || cls.includes("foot") || cls.includes("konsole"))
            return Style.iconTerminal

        // Communication
        if (cls.includes("discord"))
            return Style.iconDiscord
        if (cls.includes("telegram") || cls.includes("signal") || cls.includes("slack"))
            return "󰍡"
        if (cls.includes("thunderbird") || cls.includes("mail"))
            return "󰇮"

        // Media
        if (cls.includes("spotify") || cls.includes("music") || cls.includes("rhythmbox"))
            return Style.iconMusic
        if (cls.includes("mpv") || cls.includes("vlc") || cls.includes("video"))
            return "󰕧"

        // File managers
        if (cls.includes("thunar") || cls.includes("nautilus") || cls.includes("dolphin"))
            return Style.iconFiles
        if (cls.includes("file") || cls.includes("nemo") || cls.includes("pcmanfm"))
            return Style.iconFiles

        // Graphics
        if (cls.includes("gimp") || cls.includes("inkscape") || cls.includes("krita"))
            return "󰃣"
        if (cls.includes("blender"))
            return "󰂫"

        // Games
        if (cls.includes("steam") || cls.includes("lutris"))
            return "󰓓"

        // System
        if (cls.includes("settings") || cls.includes("control"))
            return "󰒓"

        return Style.iconWindow
    }
}

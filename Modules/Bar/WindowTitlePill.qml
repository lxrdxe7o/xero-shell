import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

ClippingRectangle {
    id: root

    readonly property var activeWindow: Hyprland.focusedWindow
    readonly property string windowTitle: activeWindow?.title ?? "Desktop"
    readonly property string windowClass: activeWindow?.class ?? ""
    readonly property bool hasWindow: activeWindow !== null

    implicitWidth: Math.min(titleRow.implicitWidth + Style.pillPaddingHorizontal * 2, 400)
    implicitHeight: Style.pillHeight

    color: hasWindow ? Colors.pillBackground : Qt.alpha(Colors.pillBackground, 0.5)
    radius: Style.radiusFull

    Behavior on color {
        ColorAnim {}
    }

    Behavior on implicitWidth {
        Anim {}
    }

    Row {
        id: titleRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // App icon (simplified - just showing a window icon)
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                // Map common app classes to icons
                const cls = windowClass.toLowerCase()
                if (cls.includes("firefox") || cls.includes("chrome") || cls.includes("browser"))
                    return "󰈹"  // Browser
                if (cls.includes("code") || cls.includes("editor"))
                    return "󰨞"  // Code
                if (cls.includes("terminal") || cls.includes("kitty") || cls.includes("alacritty"))
                    return "󰆍"  // Terminal
                if (cls.includes("discord"))
                    return "󰙯"  // Discord
                if (cls.includes("spotify"))
                    return "󰓇"  // Music
                if (cls.includes("file") || cls.includes("thunar") || cls.includes("nautilus"))
                    return "󰉋"  // Files
                return "󰖲"  // Generic window
            }
            color: hasWindow ? Colors.blue : Colors.overlay0
            font.pixelSize: Style.fontSizeLarge
            font.family: "monospace"
            visible: hasWindow

            Behavior on color {
                ColorAnim {}
            }
        }

        // Window title with scrolling for long titles
        Item {
            anchors.verticalCenter: parent.verticalCenter
            width: Math.min(titleText.implicitWidth, 300)
            height: titleText.implicitHeight
            clip: true

            Text {
                id: titleText
                text: windowTitle
                color: hasWindow ? Colors.text : Colors.overlay0
                font.pixelSize: Style.fontSizeNormal
                font.family: "monospace"

                Behavior on color {
                    ColorAnim {}
                }

                // Scroll animation for long titles
                property bool needsScroll: implicitWidth > 300

                SequentialAnimation on x {
                    running: titleText.needsScroll && hasWindow
                    loops: Animation.Infinite

                    // Wait before starting scroll
                    PauseAnimation { duration: 2000 }

                    // Scroll left
                    NumberAnimation {
                        from: 0
                        to: -(titleText.implicitWidth - 300)
                        duration: Math.max(3000, (titleText.implicitWidth - 300) * 10)
                        easing.type: Easing.Linear
                    }

                    // Wait at end
                    PauseAnimation { duration: 1000 }

                    // Scroll back
                    NumberAnimation {
                        from: -(titleText.implicitWidth - 300)
                        to: 0
                        duration: Math.max(3000, (titleText.implicitWidth - 300) * 10)
                        easing.type: Easing.Linear
                    }

                    // Wait before looping
                    PauseAnimation { duration: 2000 }
                }

                // Reset scroll position when title changes
                onTextChanged: {
                    x = 0
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton && hasWindow) {
                // Could trigger window menu or action
                console.log("Window:", windowTitle, "Class:", windowClass)
            } else if (mouse.button === Qt.RightButton && hasWindow) {
                // Could close window
                Hyprland.dispatch("killactive")
            }
        }
    }

    // Window change animation
    Connections {
        target: Hyprland

        function onFocusedWindowChanged() {
            windowChangeFeedback.restart()
        }
    }

    SequentialAnimation {
        id: windowChangeFeedback

        NumberAnimation {
            target: root
            property: "scale"
            from: 1.0
            to: 0.95
            duration: Style.animationFast
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: root
            property: "scale"
            from: 0.95
            to: 1.0
            duration: Style.animationFast
            easing.type: Easing.InCubic
        }
    }
}

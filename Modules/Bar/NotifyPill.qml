import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    property int notifyCount: 0
    property bool dndEnabled: false

    readonly property bool hasNotifications: notifyCount > 0

    implicitWidth: notifyRow.implicitWidth + Style.pillPaddingHorizontal * 2
    pillColor: dndEnabled ? Colors.errorContainer : (hasNotifications ? Colors.secondaryContainer : Colors.pillBackground)
    tooltip: {
        if (dndEnabled) return "Do Not Disturb enabled"
        if (hasNotifications) return notifyCount + " notification" + (notifyCount > 1 ? "s" : "")
        return "No notifications"
    }

    onClicked: {
        // Toggle notification center
        toggleProc.running = true
    }

    onRightClicked: {
        // Toggle DND
        dndProc.running = true
    }

    // Get notification count
    Process {
        id: countProc
        running: true
        command: ["swaync-client", "-c"]

        stdout: SplitParser {
            onRead: line => {
                const count = parseInt(line.trim())
                if (!isNaN(count)) {
                    notifyCount = count
                }
            }
        }

        onExited: (code, status) => {
            restartTimer.start()
        }
    }

    // Get DND status
    Process {
        id: dndCheckProc
        running: true
        command: ["swaync-client", "-D"]

        stdout: SplitParser {
            onRead: line => {
                dndEnabled = line.trim() === "true"
            }
        }

        onExited: (code, status) => {
            dndRestartTimer.start()
        }
    }

    // Toggle notification center
    Process {
        id: toggleProc
        command: ["swaync-client", "-t"]
    }

    // Toggle DND
    Process {
        id: dndProc
        command: ["swaync-client", "-d"]

        onExited: {
            dndCheckProc.running = true
        }
    }

    Timer {
        id: restartTimer
        interval: Style.notifyPollInterval
        onTriggered: countProc.running = true
    }

    Timer {
        id: dndRestartTimer
        interval: Style.notifyPollInterval
        onTriggered: dndCheckProc.running = true
    }

    Row {
        id: notifyRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Notification icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (root.dndEnabled) return Style.iconNotificationDnd
                if (root.hasNotifications) return Style.iconNotification
                return Style.iconNotificationNone
            }
            color: {
                if (root.dndEnabled) return Colors.notifyDnd
                if (root.hasNotifications) return Colors.notifyActive
                return Colors.notifyNone
            }
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont

            Behavior on color {
                ColorAnimation { duration: Style.animationFast }
            }

            // Pulse animation when has notifications
            SequentialAnimation on scale {
                running: root.hasNotifications && !root.dndEnabled
                loops: Animation.Infinite

                NumberAnimation {
                    from: 1.0
                    to: 1.15
                    duration: 800
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    from: 1.15
                    to: 1.0
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Count badge
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.notifyCount.toString()
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
            visible: root.hasNotifications
        }
    }

    // Notification change feedback
    onNotifyCountChanged: {
        if (notifyCount > 0) {
            bounce()
        }
    }
}

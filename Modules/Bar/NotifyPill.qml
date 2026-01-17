import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    // Reference to the panel (set by parent)
    property var notificationPanel: null

    // Use NotificationManager
    readonly property int notifyCount: NotificationManager.count
    readonly property bool dndEnabled: NotificationManager.dnd
    readonly property bool hasNotifications: notifyCount > 0

    implicitWidth: notifyRow.implicitWidth + Style.pillPaddingHorizontal * 2
    pillColor: dndEnabled ? Colors.errorContainer : (hasNotifications ? Colors.secondaryContainer : Colors.pillBackground)
    tooltip: {
        if (dndEnabled) return "Do Not Disturb enabled"
        if (hasNotifications) return notifyCount + " notification" + (notifyCount > 1 ? "s" : "")
        return "No notifications"
    }

    onClicked: {
        // Toggle notification panel
        if (notificationPanel) {
            notificationPanel.toggle()
        }
        bounce()
    }

    onRightClicked: {
        // Toggle DND
        NotificationManager.toggleDnd()
        pulse()
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

    // Close panel when DND toggled
    onDndEnabledChanged: {
        pulse()
    }
}

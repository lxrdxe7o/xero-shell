import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../Commons"
import "../../Components"

PanelWindow {
    id: root

    // Screen binding
    property var screen: null

    // Panel state
    property bool panelVisible: false
    property var notifications: NotificationManager.notifications
    property bool dnd: NotificationManager.dnd

    // Positioning
    property int panelWidth: Math.round(380 * Style.scaleFactor)
    property int panelMaxHeight: Math.round(500 * Style.scaleFactor)

    // Layershell config
    WlrLayershell.namespace: "xero-shell-notifications"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    anchors {
        top: true
        right: true
    }

    margins {
        top: Style.barHeight + Style.spacingNormal
        right: Style.spacingNormal
    }

    visible: panelVisible
    width: panelWidth
    implicitHeight: Math.min(contentColumn.implicitHeight, panelMaxHeight)
    color: Colors.transparent

    // Close when clicking outside
    Component.onCompleted: {
        if (panelVisible) {
            forceActiveFocus()
        }
    }

    onPanelVisibleChanged: {
        if (panelVisible) {
            forceActiveFocus()
        }
    }

    // Main container
    ClippingRectangle {
        id: container
        anchors.fill: parent
        color: Colors.background
        radius: Style.radiusLarge

        // Border
        Rectangle {
            anchors.fill: parent
            color: Colors.transparent
            radius: Style.radiusLarge
            border.width: 1
            border.color: Colors.surface1
        }

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: Style.paddingNormal
            spacing: Style.spacingNormal

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: Style.spacingNormal

                Text {
                    text: Style.iconNotification
                    color: Colors.primary
                    font.pixelSize: Style.fontSizeLarge
                    font.family: Style.iconFont
                }

                Text {
                    text: "Notifications"
                    color: Colors.text
                    font.pixelSize: Style.fontSizeLarge
                    font.family: Style.fontFamily
                    font.bold: true
                    Layout.fillWidth: true
                }

                // DND toggle
                Rectangle {
                    width: Style.pillHeight
                    height: Style.pillHeight
                    radius: Style.radiusSmall
                    color: root.dnd ? Colors.errorContainer : Colors.surface0

                    Text {
                        anchors.centerIn: parent
                        text: root.dnd ? Style.iconNotificationDnd : Style.iconNotification
                        color: root.dnd ? Colors.error : Colors.subtext0
                        font.pixelSize: Style.fontSizeNormal
                        font.family: Style.iconFont
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: NotificationManager.toggleDnd()
                    }

                    Behavior on color {
                        ColorAnimation { duration: Style.animationFast }
                    }
                }

                // Clear all button
                Rectangle {
                    width: Style.pillHeight
                    height: Style.pillHeight
                    radius: Style.radiusSmall
                    color: clearAllMouse.containsMouse ? Colors.errorContainer : Colors.surface0
                    visible: root.notifications.length > 0

                    Text {
                        anchors.centerIn: parent
                        text: Style.iconClose
                        color: clearAllMouse.containsMouse ? Colors.error : Colors.subtext0
                        font.pixelSize: Style.fontSizeNormal
                        font.family: Style.iconFont
                    }

                    MouseArea {
                        id: clearAllMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: NotificationManager.clearAll()
                    }

                    Behavior on color {
                        ColorAnimation { duration: Style.animationFast }
                    }
                }
            }

            // Separator
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Colors.surface1
            }

            // Notifications list or empty state
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: Math.round(100 * Style.scaleFactor)

                // Empty state
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.spacingNormal
                    visible: root.notifications.length === 0

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Style.iconNotificationNone
                        color: Colors.surface2
                        font.pixelSize: Math.round(48 * Style.scaleFactor)
                        font.family: Style.iconFont
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "No notifications"
                        color: Colors.subtext0
                        font.pixelSize: Style.fontSizeNormal
                        font.family: Style.fontFamily
                    }
                }

                // Notification list
                ListView {
                    id: notificationList
                    anchors.fill: parent
                    model: root.notifications
                    spacing: Style.spacingSmall
                    clip: true
                    visible: root.notifications.length > 0

                    delegate: NotificationItem {
                        width: notificationList.width
                        notification: modelData
                    }

                    // Scroll indicator
                    ScrollBar.vertical: ScrollBar {
                        active: true
                        policy: ScrollBar.AsNeeded
                    }
                }
            }
        }

        // Panel animations
        opacity: root.panelVisible ? 1 : 0
        scale: root.panelVisible ? 1 : 0.95
        transformOrigin: Item.TopRight

        Behavior on opacity {
            NumberAnimation {
                duration: Style.animationFast
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: Style.animationFast
                easing.type: Easing.OutCubic
            }
        }
    }

    // Toggle function
    function toggle() {
        panelVisible = !panelVisible
    }

    function show() {
        panelVisible = true
    }

    function hide() {
        panelVisible = false
    }
}

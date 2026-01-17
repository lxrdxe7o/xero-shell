import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

ClippingRectangle {
    id: root

    required property var notification

    readonly property string appName: notification?.appName ?? "Unknown"
    readonly property string summary: notification?.summary ?? ""
    readonly property string body: notification?.body ?? ""
    readonly property string appIcon: notification?.appIcon ?? ""
    readonly property int urgency: notification?.urgency ?? NotificationUrgency.Normal
    readonly property var actions: notification?.actions ?? []
    readonly property bool hasImage: notification?.image !== "" && notification?.image !== undefined

    implicitHeight: contentLayout.implicitHeight + Style.paddingNormal * 2
    color: itemMouse.containsMouse ? Colors.surface1 : Colors.surface0
    radius: Style.radiusNormal

    Behavior on color {
        ColorAnimation { duration: Style.animationFast }
    }

    // Urgency indicator
    Rectangle {
        id: urgencyBar
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        radius: Style.radiusNormal
        color: {
            switch (root.urgency) {
                case NotificationUrgency.Critical:
                    return Colors.error
                case NotificationUrgency.Low:
                    return Colors.subtext0
                default:
                    return Colors.primary
            }
        }
    }

    MouseArea {
        id: itemMouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton) {
                // Dismiss on right click
                root.notification?.dismiss()
            } else if (root.actions.length > 0) {
                // Invoke default action on left click
                root.actions[0].invoke()
            }
        }
    }

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.leftMargin: Style.paddingNormal + urgencyBar.width
        anchors.rightMargin: Style.paddingNormal
        anchors.topMargin: Style.paddingSmall
        anchors.bottomMargin: Style.paddingSmall
        spacing: Style.spacingSmall

        // Header row: app name + close button
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.spacingSmall

            // App icon (if available)
            Text {
                text: Style.iconWindow
                color: Colors.subtext0
                font.pixelSize: Style.fontSizeSmall
                font.family: Style.iconFont
                visible: !root.hasImage
            }

            // App name
            Text {
                text: root.appName
                color: Colors.subtext0
                font.pixelSize: Style.fontSizeSmall
                font.family: Style.fontFamily
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Time ago (placeholder - would need timestamp)
            Text {
                text: "now"
                color: Colors.overlay0
                font.pixelSize: Style.fontSizeSmall
                font.family: Style.fontFamily
            }

            // Close button
            Rectangle {
                width: Math.round(20 * Style.scaleFactor)
                height: Math.round(20 * Style.scaleFactor)
                radius: Style.radiusSmall
                color: closeMouse.containsMouse ? Colors.errorContainer : Colors.transparent
                visible: itemMouse.containsMouse

                Text {
                    anchors.centerIn: parent
                    text: Style.iconClose
                    color: closeMouse.containsMouse ? Colors.error : Colors.subtext0
                    font.pixelSize: Style.fontSizeSmall
                    font.family: Style.iconFont
                }

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.notification?.dismiss()
                }

                Behavior on color {
                    ColorAnimation { duration: Style.animationFast }
                }
            }
        }

        // Summary (title)
        Text {
            text: root.summary
            color: Colors.text
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
            font.bold: true
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            maximumLineCount: 2
            Layout.fillWidth: true
            visible: root.summary !== ""
        }

        // Body
        Text {
            text: root.body
            color: Colors.subtext1
            font.pixelSize: Style.fontSizeSmall
            font.family: Style.fontFamily
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            maximumLineCount: 3
            Layout.fillWidth: true
            visible: root.body !== ""
        }

        // Actions row
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.spacingSmall
            visible: root.actions.length > 1

            Repeater {
                model: root.actions.slice(1)  // Skip first (default) action

                Rectangle {
                    Layout.fillWidth: true
                    height: Math.round(28 * Style.scaleFactor)
                    radius: Style.radiusSmall
                    color: actionMouse.containsMouse ? Colors.primaryContainer : Colors.surface1

                    Text {
                        anchors.centerIn: parent
                        text: modelData.text
                        color: actionMouse.containsMouse ? Colors.primary : Colors.text
                        font.pixelSize: Style.fontSizeSmall
                        font.family: Style.fontFamily
                    }

                    MouseArea {
                        id: actionMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: modelData.invoke()
                    }

                    Behavior on color {
                        ColorAnimation { duration: Style.animationFast }
                    }
                }
            }
        }
    }

    // Entry animation
    Component.onCompleted: {
        entryAnim.start()
    }

    NumberAnimation {
        id: entryAnim
        target: root
        property: "opacity"
        from: 0
        to: 1
        duration: Style.animationNormal
        easing.type: Easing.OutCubic
    }
}

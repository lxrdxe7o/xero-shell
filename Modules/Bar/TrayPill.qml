import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    readonly property var trayItems: SystemTray.items
    readonly property int itemCount: trayItems?.length ?? 0
    readonly property bool hasItems: itemCount > 0

    property bool expanded: false

    implicitWidth: expanded ? expandedRow.implicitWidth + Style.pillPaddingHorizontal * 2
                           : collapsedRow.implicitWidth + Style.pillPaddingHorizontal * 2
    tooltip: expanded ? "Click to collapse tray" : itemCount + " tray item" + (itemCount !== 1 ? "s" : "")

    onClicked: {
        expanded = !expanded
    }

    // Collapsed view - just show icon and count
    Row {
        id: collapsedRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal
        visible: !root.expanded

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Style.iconTray
            color: Colors.pillIcon
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.itemCount.toString()
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
            visible: root.hasItems
        }
    }

    // Expanded view - show all tray icons
    Row {
        id: expandedRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal
        visible: root.expanded

        // Collapse icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Style.iconTray
            color: Colors.pillIcon
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont
            opacity: 0.6
        }

        // Separator
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 1
            height: Style.fontSizeLarge
            color: Colors.surface1
            opacity: 0.5
        }

        // Tray items
        Repeater {
            model: root.trayItems

            Item {
                id: trayItem
                width: Style.fontSizeLarge + Style.spacingSmall
                height: Style.fontSizeLarge + Style.spacingSmall
                anchors.verticalCenter: parent.verticalCenter

                required property var modelData

                Image {
                    id: trayIcon
                    anchors.centerIn: parent
                    width: Style.fontSizeLarge
                    height: Style.fontSizeLarge
                    source: trayItem.modelData.icon
                    sourceSize: Qt.size(width, height)
                    smooth: true
                    antialiasing: true

                    // Hover effect
                    scale: iconMouse.containsMouse ? 1.15 : 1.0

                    Behavior on scale {
                        NumberAnimation {
                            duration: Style.animationFast
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                MouseArea {
                    id: iconMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    cursorShape: Qt.PointingHandCursor

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            trayItem.modelData.activate()
                        } else if (mouse.button === Qt.RightButton) {
                            trayItem.modelData.secondaryActivate()
                        } else if (mouse.button === Qt.MiddleButton) {
                            trayItem.modelData.secondaryActivate()
                        }
                    }

                    onWheel: wheel => {
                        const delta = wheel.angleDelta.y > 0 ? 1 : -1
                        trayItem.modelData.scroll(delta, false)
                    }
                }

                ToolTip {
                    visible: iconMouse.containsMouse
                    text: trayItem.modelData.tooltip || trayItem.modelData.title || "Unknown"
                    delay: 500
                }
            }
        }
    }

    // Expand/collapse animation
    Behavior on implicitWidth {
        NumberAnimation {
            duration: Style.animationNormal
            easing.type: Easing.OutCubic
        }
    }

    // State change feedback
    onExpandedChanged: {
        bounce()
    }
}

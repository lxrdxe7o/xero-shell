import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    required property var screen

    readonly property var workspaces: {
        const all = Hyprland.workspaces.values
        return all.filter(ws => ws.monitor?.name === screen.name).slice(0, Style.maxWorkspaces)
    }

    readonly property int activeWorkspaceId: Hyprland.focusedWorkspace?.id ?? 1

    implicitWidth: layout.implicitWidth + Style.pillPaddingHorizontal * 2
    implicitHeight: Style.pillHeight
    tooltip: "Workspaces"

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: Style.spacingSmall

        Repeater {
            model: Style.maxWorkspaces

            Item {
                id: workspaceItem

                Layout.preferredWidth: indicator.width
                Layout.preferredHeight: Style.pillHeight - Style.spacingNormal

                property int workspaceId: index + 1
                property bool isActive: root.activeWorkspaceId === workspaceId
                property bool isOccupied: {
                    const ws = root.workspaces.find(w => w.id === workspaceId)
                    return ws ? (ws.lastWindow !== null) : false
                }
                property bool isUrgent: {
                    const ws = root.workspaces.find(w => w.id === workspaceId)
                    return ws?.urgent ?? false
                }

                Rectangle {
                    id: indicator
                    anchors.centerIn: parent
                    width: workspaceItem.isActive ? Style.workspaceActiveWidth : Style.workspaceInactiveWidth
                    height: workspaceItem.isActive ? Style.workspaceActiveHeight : Style.workspaceInactiveHeight
                    radius: Style.radiusSmall

                    color: {
                        if (workspaceItem.isUrgent) return Colors.urgentWorkspace
                        if (workspaceItem.isActive) return Colors.activeWorkspace
                        if (workspaceItem.isOccupied) return Colors.occupiedWorkspace
                        return Colors.emptyWorkspace
                    }

                    // Glow effect for active workspace
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: "transparent"
                        border.width: workspaceItem.isActive ? 1 : 0
                        border.color: Colors.activeWorkspace
                        opacity: 0.5
                        visible: workspaceItem.isActive

                        Behavior on opacity {
                            NumberAnimation { duration: Style.animationFast }
                        }
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: Style.animationNormal
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on height {
                        NumberAnimation {
                            duration: Style.animationNormal
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Style.animationFast
                            easing.type: Easing.InOutQuad
                        }
                    }

                    // Workspace number (only show on active or hover)
                    Text {
                        anchors.centerIn: parent
                        text: workspaceItem.workspaceId
                        color: workspaceItem.isActive ? Colors.onPrimary : Colors.pillText
                        font.pixelSize: Style.fontSizeSmall
                        font.bold: workspaceItem.isActive
                        font.family: Style.fontFamily
                        opacity: workspaceItem.isActive || workspaceItem.isOccupied ? 1.0 : 0.0
                        visible: opacity > 0

                        Behavior on opacity {
                            NumberAnimation { duration: Style.animationFast }
                        }

                        Behavior on color {
                            ColorAnimation { duration: Style.animationFast }
                        }
                    }

                    // Urgent animation
                    SequentialAnimation {
                        running: workspaceItem.isUrgent
                        loops: Animation.Infinite

                        NumberAnimation {
                            target: indicator
                            property: "opacity"
                            from: 1.0
                            to: 0.5
                            duration: 400
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: indicator
                            property: "opacity"
                            from: 0.5
                            to: 1.0
                            duration: 400
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Hyprland.dispatch("workspace " + workspaceItem.workspaceId)
                    }
                }
            }
        }
    }

    // Workspace change feedback
    Connections {
        target: Hyprland

        function onFocusedWorkspaceChanged() {
            root.bounce()
        }
    }
}

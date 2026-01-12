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

    implicitWidth: Style.pillMinWidth + Style.pillPaddingHorizontal * 2
    tooltip: "Workspaces"

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        spacing: Style.spacingSmall

        Repeater {
            model: Style.maxWorkspaces

            Item {
                id: workspaceItem

                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: Style.pillMinWidth
                Layout.preferredHeight: Style.pillMinWidth

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
                    width: workspaceItem.isActive ? Style.pillMinWidth : Style.pillMinWidth * Style.workspaceInactiveScale
                    height: width
                    radius: Style.radiusFull

                    color: {
                        if (workspaceItem.isUrgent) return Colors.urgentWorkspace
                        if (workspaceItem.isActive) return Colors.activeWorkspace
                        if (workspaceItem.isOccupied) return Colors.occupiedWorkspace
                        return Colors.emptyWorkspace
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

                    Text {
                        anchors.centerIn: parent
                        text: workspaceItem.workspaceId
                        color: workspaceItem.isActive ? Colors.onPrimary : Colors.pillText
                        font.pixelSize: workspaceItem.isActive ? Style.fontSizeLarge : Style.fontSizeNormal
                        font.bold: workspaceItem.isActive
                        font.family: Style.fontFamily

                        Behavior on color {
                            ColorAnimation {
                                duration: Style.animationFast
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on font.pixelSize {
                            NumberAnimation {
                                duration: Style.animationFast
                            }
                        }
                    }

                    // Urgent animation
                    SequentialAnimation {
                        running: workspaceItem.isUrgent
                        loops: Animation.Infinite

                        NumberAnimation {
                            target: indicator
                            property: "scale"
                            from: 1.0
                            to: 1.15
                            duration: 400
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: indicator
                            property: "scale"
                            from: 1.15
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

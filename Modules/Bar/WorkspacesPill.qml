import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

ClippingRectangle {
    id: root

    required property var screen

    // Get workspaces for this monitor
    readonly property var workspaces: {
        const all = Hyprland.workspaces.values
        // Filter to this monitor's workspaces
        return all.filter(ws => ws.monitor?.name === screen.name).slice(0, 5)
    }

    readonly property int activeWorkspaceId: Hyprland.focusedWorkspace?.id ?? 1

    implicitWidth: Style.pillMinWidth + Style.pillPaddingHorizontal * 2
    implicitHeight: layout.implicitHeight + Style.paddingSmall * 2

    color: Colors.pillBackground
    radius: Style.radiusFull

    Behavior on color {
        ColorAnim {}
    }

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Style.spacingSmall

        Repeater {
            model: 5  // Show 5 workspaces

            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: Style.pillMinWidth
                Layout.preferredHeight: Style.pillMinWidth

                property int workspaceId: index + 1
                property bool isActive: root.activeWorkspaceId === workspaceId
                property bool isOccupied: {
                    // Check if workspace has windows
                    const ws = root.workspaces.find(w => w.id === workspaceId)
                    return ws ? (ws.lastWindow !== null) : false
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.isActive ? Style.pillMinWidth : Style.pillMinWidth * 0.7
                    height: width
                    radius: Style.radiusFull

                    color: {
                        if (parent.isActive) return Colors.activeWorkspace
                        if (parent.isOccupied) return Colors.occupiedWorkspace
                        return Colors.emptyWorkspace
                    }

                    Behavior on width {
                        Anim {}
                    }

                    Behavior on height {
                        Anim {}
                    }

                    Behavior on color {
                        ColorAnim {}
                    }

                    Text {
                        anchors.centerIn: parent
                        text: parent.parent.workspaceId
                        color: parent.parent.isActive ? Colors.onPrimary : Colors.pillText
                        font.pixelSize: parent.parent.isActive ? Style.fontSizeLarge : Style.fontSizeNormal
                        font.bold: parent.parent.isActive
                        font.family: "monospace"

                        Behavior on color {
                            ColorAnim {}
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Hyprland.dispatch("workspace " + parent.workspaceId)
                    }
                }
            }
        }
    }
}

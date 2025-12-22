import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../../Commons"

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: bar

        required property var modelData
        property var screen: modelData

        // Wayland layer shell configuration
        WlrLayershell.namespace: "xero-shell-bar"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.exclusiveZone: height

        anchors {
            top: true
            left: true
            right: true
        }

        // Bar dimensions
        height: Style.barHeight

        color: Colors.transparent

        Rectangle {
            id: barBackground
            anchors.fill: parent
            color: Colors.barBackground
            opacity: 0.95

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.barPadding
                spacing: Style.spacingLarge

                // Left section - Workspaces
                WorkspacesPill {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    screen: bar.screen
                }

                // Left-center section - Window Title
                WindowTitlePill {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.fillWidth: false
                }

                // Spacer
                Item {
                    Layout.fillWidth: true
                }

                // Center section - Media Player (when active)
                MediaPill {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                // Center section - Clock (when no media)
                ClockPill {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                // Spacer
                Item {
                    Layout.fillWidth: true
                }

                // Right section - System indicators
                Row {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    spacing: Style.spacingNormal

                    NetworkPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    VolumePill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    BatteryPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}

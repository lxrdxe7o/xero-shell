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

        height: Style.barHeight
        color: Colors.transparent

        Rectangle {
            id: barBackground
            anchors.fill: parent
            color: Colors.barBackground
            opacity: Style.barOpacity

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.barPadding
                spacing: Style.spacingLarge

                // ========================================
                // Left Section - Workspaces & Window Title
                // ========================================
                WorkspacesPill {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    screen: bar.screen
                }

                WindowTitlePill {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.fillWidth: false
                }

                // Left spacer
                Item {
                    Layout.fillWidth: true
                }

                // ========================================
                // Center Section - Media & Clock
                // ========================================
                MediaPill {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                ClockPill {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                // Right spacer
                Item {
                    Layout.fillWidth: true
                }

                // ========================================
                // Right Section - System Indicators
                // ========================================
                Row {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    spacing: Style.spacingNormal

                    // System resources (optional - can be hidden)
                    CpuPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    MemoryPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Connectivity
                    BluetoothPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    NetworkPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Audio
                    MicPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    VolumePill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Display & Power
                    BrightnessPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    BatteryPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        // Bar hover animation
        Rectangle {
            id: hoverIndicator
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: hoverArea.containsMouse ? parent.width : 0
            height: 2
            color: Colors.primary
            opacity: hoverArea.containsMouse ? 1 : 0

            Behavior on width {
                NumberAnimation {
                    duration: Style.animationNormal
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Style.animationFast
                }
            }
        }

        MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
        }
    }
}

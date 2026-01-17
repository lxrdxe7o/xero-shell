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

        // Notification panel instance
        NotificationPanel {
            id: notificationPanel
            screen: bar.screen
        }

        WlrLayershell.namespace: "xero-shell-bar"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.exclusiveZone: height

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: Style.barHeight
        color: Colors.transparent

        Rectangle {
            id: barBackground
            anchors.fill: parent
            color: Colors.barBackground
            opacity: Style.barOpacity

            // Subtle bottom border
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Colors.surface1
                opacity: 0.3
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.barPadding
                anchors.rightMargin: Style.barPadding
                anchors.topMargin: Style.barPadding / 2
                anchors.bottomMargin: Style.barPadding / 2
                spacing: Style.spacingNormal

                // ========================================
                // LEFT SECTION
                // ========================================
                Row {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    spacing: Style.spacingNormal

                    WorkspacesPill {
                        anchors.verticalCenter: parent.verticalCenter
                        screen: bar.screen
                    }

                    WindowTitlePill {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Left spacer
                Item { Layout.fillWidth: true }

                // ========================================
                // CENTER SECTION
                // ========================================
                Row {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    spacing: Style.spacingNormal

                    MediaPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    ClockPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    WeatherPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Right spacer
                Item { Layout.fillWidth: true }

                // ========================================
                // RIGHT SECTION
                // ========================================
                Row {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    spacing: Style.spacingNormal

                    // System resources
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

                    // Notifications
                    NotifyPill {
                        anchors.verticalCenter: parent.verticalCenter
                        notificationPanel: notificationPanel
                    }

                    // System Tray
                    TrayPill {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}

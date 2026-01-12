import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    property var btInfo: ({
        powered: false,
        connected: false,
        deviceName: "",
        devices: []
    })

    readonly property bool isPowered: btInfo.powered
    readonly property bool isConnected: btInfo.connected

    implicitWidth: btRow.implicitWidth + Style.pillPaddingHorizontal * 2
    pillColor: isConnected ? Colors.primaryContainer : Colors.pillBackground
    tooltip: {
        if (!isPowered) return "Bluetooth off"
        if (isConnected) return "Connected: " + btInfo.deviceName
        return "Bluetooth on (no devices)"
    }

    onClicked: {
        // Toggle bluetooth power
        btToggleProc.running = true
    }

    onRightClicked: {
        // Could open bluetooth settings
    }

    // Poll bluetooth status
    Process {
        id: btProc
        running: true
        command: ["bluetoothctl", "show"]

        property bool powered: false

        stdout: SplitParser {
            onRead: line => {
                const trimmed = line.trim()
                if (trimmed.startsWith("Powered:")) {
                    btProc.powered = trimmed.includes("yes")
                }
            }
        }

        onExited: (code, status) => {
            if (code === 0) {
                btInfo.powered = powered
                if (powered) {
                    // Check for connected devices
                    btDevicesProc.running = true
                } else {
                    btInfo = {
                        powered: false,
                        connected: false,
                        deviceName: "",
                        devices: []
                    }
                    restartTimer.start()
                }
            } else {
                restartTimer.start()
            }
        }
    }

    // Get connected devices
    Process {
        id: btDevicesProc
        command: ["bluetoothctl", "devices", "Connected"]

        property var connectedDevices: []

        stdout: SplitParser {
            onRead: line => {
                const parts = line.split(" ")
                if (parts.length >= 3 && parts[0] === "Device") {
                    btDevicesProc.connectedDevices.push(parts.slice(2).join(" "))
                }
            }
        }

        onExited: (code, status) => {
            btInfo = {
                powered: true,
                connected: connectedDevices.length > 0,
                deviceName: connectedDevices.length > 0 ? connectedDevices[0] : "",
                devices: connectedDevices
            }
            connectedDevices = []
            restartTimer.start()
        }
    }

    // Toggle bluetooth power
    Process {
        id: btToggleProc
        command: ["bluetoothctl", "power", root.isPowered ? "off" : "on"]

        onExited: (code, status) => {
            // Refresh status
            btProc.running = true
        }
    }

    Timer {
        id: restartTimer
        interval: Style.bluetoothPollInterval
        onTriggered: {
            btProc.running = true
        }
    }

    Row {
        id: btRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Bluetooth icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (!root.isPowered) return Style.iconBluetoothOff
                if (root.isConnected) return Style.iconBluetoothConnected
                return Style.iconBluetooth
            }
            color: {
                if (!root.isPowered) return Colors.pillIconMuted
                if (root.isConnected) return Colors.primary
                return Colors.pillIcon
            }
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Device name or status (optional, shows when connected)
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.isConnected ? root.btInfo.deviceName : ""
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
            visible: root.isConnected && text.length > 0
            elide: Text.ElideRight
            maximumLineCount: 1
            width: Math.min(implicitWidth, Style.ssidMaxWidth)
        }
    }

    // Connection state change feedback
    Connections {
        target: root

        function onIsConnectedChanged() {
            root.bounce()
        }

        function onIsPoweredChanged() {
            root.pulse()
        }
    }
}

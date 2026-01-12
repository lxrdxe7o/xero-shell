import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    // Network state
    property var networkInfo: ({
        connected: false,
        ssid: "",
        strength: 0,
        type: "none",  // none, wifi, ethernet, vpn
        error: false
    })

    readonly property bool isConnected: networkInfo.connected
    readonly property bool isWifi: networkInfo.type === "wifi"
    readonly property bool isEthernet: networkInfo.type === "ethernet"
    readonly property bool isVpn: networkInfo.type === "vpn"
    readonly property bool isWeak: isWifi && networkInfo.strength < 40

    implicitWidth: networkRow.implicitWidth + Style.pillPaddingHorizontal * 2
    pillColor: networkInfo.error ? Colors.errorContainer : Colors.pillBackground
    tooltip: {
        if (networkInfo.error) return "Network error"
        if (!isConnected) return "Disconnected"
        if (isWifi) return networkInfo.ssid + " (" + networkInfo.strength + "%)"
        if (isEthernet) return "Ethernet: " + networkInfo.ssid
        if (isVpn) return "VPN: " + networkInfo.ssid
        return "Connected"
    }

    onClicked: {
        // Could open network settings
    }

    // Network status polling
    Process {
        id: networkProc
        running: true
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION,SIGNAL", "device", "status"]

        property bool foundConnection: false

        stdout: SplitParser {
            onRead: line => {
                const parts = line.split(":")
                if (parts.length < 3) return

                const type = parts[0]
                const state = parts[1]
                const connection = parts[2]
                const signal = parts[3] ? parseInt(parts[3]) : 0

                if (state === "connected") {
                    networkProc.foundConnection = true

                    if (type === "ethernet") {
                        networkInfo = {
                            connected: true,
                            ssid: connection,
                            strength: 100,
                            type: "ethernet",
                            error: false
                        }
                    } else if (type === "wifi") {
                        networkInfo = {
                            connected: true,
                            ssid: connection,
                            strength: signal,
                            type: "wifi",
                            error: false
                        }
                    } else if (type === "tun" || type === "wireguard") {
                        networkInfo = {
                            connected: true,
                            ssid: connection,
                            strength: 100,
                            type: "vpn",
                            error: false
                        }
                    }
                }
            }
        }

        onExited: (code, status) => {
            if (code !== 0) {
                networkInfo = {
                    connected: false,
                    ssid: "",
                    strength: 0,
                    type: "none",
                    error: true
                }
            } else if (!foundConnection) {
                networkInfo = {
                    connected: false,
                    ssid: "",
                    strength: 0,
                    type: "none",
                    error: false
                }
            }
            foundConnection = false
            restartTimer.start()
        }
    }

    Timer {
        id: restartTimer
        interval: Style.networkPollInterval
        onTriggered: {
            networkProc.running = true
        }
    }

    Row {
        id: networkRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Network icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (root.networkInfo.error) return "󰤮"  // Error
                if (root.isVpn) return Style.iconVpn
                if (root.isEthernet) return Style.iconEthernet
                if (!root.isConnected) return Style.iconWifiOff
                return Style.getWifiIcon(root.networkInfo.strength)
            }
            color: {
                if (root.networkInfo.error) return Colors.error
                if (root.isConnected) return root.isWeak ? Colors.networkWeak : Colors.networkConnected
                return Colors.networkDisconnected
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

        // Connection name
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.isConnected ? root.networkInfo.ssid : "Disconnected"
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
            elide: Text.ElideRight
            maximumLineCount: 1
            width: Math.min(implicitWidth, Style.ssidMaxWidth)
        }
    }

    // Connection state change feedback
    Connections {
        target: root

        function onIsConnectedChanged() {
            if (isConnected) {
                root.bounce()
            }
        }
    }
}

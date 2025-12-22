import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

ClippingRectangle {
    id: root

    property var networkInfo: ({
        connected: false,
        ssid: "",
        strength: 0,
        ethernet: false
    })

    implicitWidth: networkRow.implicitWidth + Style.pillPaddingHorizontal * 2
    implicitHeight: Style.pillHeight

    color: Colors.pillBackground
    radius: Style.radiusFull

    Behavior on color {
        ColorAnim {}
    }

    // Poll network status using nmcli
    Process {
        id: networkProc
        running: true
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION,SIGNAL", "device", "status"]

        stdout: SplitParser {
            onRead: line => {
                // Parse nmcli output: TYPE:STATE:CONNECTION:SIGNAL
                const parts = line.split(":")
                if (parts.length < 3) return

                const type = parts[0]
                const state = parts[1]
                const connection = parts[2]
                const signal = parts[3] ? parseInt(parts[3]) : 0

                if (state === "connected") {
                    if (type === "ethernet") {
                        networkInfo = {
                            connected: true,
                            ssid: connection,
                            strength: 100,
                            ethernet: true
                        }
                    } else if (type === "wifi") {
                        networkInfo = {
                            connected: true,
                            ssid: connection,
                            strength: signal,
                            ethernet: false
                        }
                    }
                }
            }
        }

        onExited: (code, status) => {
            // Restart polling after 5 seconds
            restartTimer.start()
        }
    }

    Timer {
        id: restartTimer
        interval: 5000
        onTriggered: {
            networkProc.running = true
        }
    }

    Row {
        id: networkRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (networkInfo.ethernet) {
                    return "󰈀"  // Ethernet icon
                }
                
                if (!networkInfo.connected) {
                    return "󰖪"  // WiFi off
                }
                
                // WiFi signal strength icons
                const strength = networkInfo.strength
                if (strength >= 80) return "󰤨"  // Full
                if (strength >= 60) return "󰤥"  // Good
                if (strength >= 40) return "󰤢"  // OK
                if (strength >= 20) return "󰤟"  // Weak
                return "󰤯"  // Very weak
            }
            color: networkInfo.connected ? Colors.text : Colors.overlay0
            font.pixelSize: Style.fontSizeLarge
            font.family: "monospace"

            Behavior on color {
                ColorAnim {}
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: networkInfo.connected ? networkInfo.ssid : "Disconnected"
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: "monospace"
            elide: Text.ElideRight
            
            // Limit width to prevent overly long SSIDs
            maximumLineCount: 1
            width: Math.min(implicitWidth, 150)
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            // Could open network manager UI
            console.log("Network clicked - Connected:", networkInfo.connected, 
                       "SSID:", networkInfo.ssid, "Strength:", networkInfo.strength)
        }
    }

    // Connection state change feedback
    Connections {
        target: root

        function onNetworkInfoChanged() {
            if (networkInfo.connected) {
                connectFeedback.restart()
            }
        }
    }

    SequentialAnimation {
        id: connectFeedback

        NumberAnimation {
            target: root
            property: "scale"
            from: 1.0
            to: 1.05
            duration: Style.animationFast
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: root
            property: "scale"
            from: 1.05
            to: 1.0
            duration: Style.animationFast
            easing.type: Easing.InCubic
        }
    }
}

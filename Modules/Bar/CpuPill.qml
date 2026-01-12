import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    property real cpuUsage: 0
    property var prevStats: null

    readonly property bool isHigh: cpuUsage > 80
    readonly property bool isMedium: cpuUsage > 50

    implicitWidth: cpuRow.implicitWidth + Style.pillPaddingHorizontal * 2
    pillColor: isHigh ? Colors.errorContainer : Colors.pillBackground
    tooltip: "CPU Usage: " + Math.round(cpuUsage) + "%"

    onClicked: {
        // Could open system monitor
    }

    // Poll CPU usage from /proc/stat
    Process {
        id: cpuProc
        running: true
        command: ["cat", "/proc/stat"]

        stdout: SplitParser {
            onRead: line => {
                if (!line.startsWith("cpu ")) return

                const parts = line.split(/\s+/).slice(1).map(n => parseInt(n))
                if (parts.length < 4) return

                const idle = parts[3]
                const total = parts.reduce((a, b) => a + b, 0)

                if (prevStats !== null) {
                    const idleDelta = idle - prevStats.idle
                    const totalDelta = total - prevStats.total
                    if (totalDelta > 0) {
                        cpuUsage = 100 * (1 - idleDelta / totalDelta)
                    }
                }

                prevStats = { idle: idle, total: total }
            }
        }

        onExited: (code, status) => {
            restartTimer.start()
        }
    }

    Timer {
        id: restartTimer
        interval: Style.cpuPollInterval
        onTriggered: {
            cpuProc.running = true
        }
    }

    Row {
        id: cpuRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // CPU icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Style.iconCpu
            color: root.isHigh ? Colors.error : (root.isMedium ? Colors.warning : Colors.pillIcon)
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }

            // Spin animation when high usage
            SequentialAnimation on rotation {
                running: root.isHigh
                loops: Animation.Infinite

                NumberAnimation {
                    from: 0
                    to: 360
                    duration: 2000
                    easing.type: Easing.Linear
                }
            }
        }

        // CPU percentage
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(root.cpuUsage) + "%"
            color: root.isHigh ? Colors.error : Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    // High usage alert feedback
    Connections {
        target: root

        function onIsHighChanged() {
            if (isHigh) {
                root.bounce()
            }
        }
    }
}

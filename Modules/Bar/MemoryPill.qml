import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    property real memUsage: 0
    property real memTotal: 0
    property real memUsed: 0

    readonly property bool isHigh: memUsage > 80
    readonly property bool isMedium: memUsage > 60

    readonly property string memUsedStr: formatBytes(memUsed * 1024)
    readonly property string memTotalStr: formatBytes(memTotal * 1024)

    implicitWidth: memRow.implicitWidth + Style.pillPaddingHorizontal * 2
    pillColor: isHigh ? Colors.errorContainer : Colors.pillBackground
    tooltip: "Memory: " + memUsedStr + " / " + memTotalStr + " (" + Math.round(memUsage) + "%)"

    onClicked: {
        // Could open system monitor
    }

    // Poll memory usage from /proc/meminfo
    Process {
        id: memProc
        running: true
        command: ["cat", "/proc/meminfo"]

        property real total: 0
        property real available: 0

        stdout: SplitParser {
            onRead: line => {
                const parts = line.split(/\s+/)
                if (parts.length < 2) return

                const key = parts[0]
                const value = parseInt(parts[1])

                if (key === "MemTotal:") {
                    memProc.total = value
                } else if (key === "MemAvailable:") {
                    memProc.available = value
                }
            }
        }

        onExited: (code, status) => {
            if (code === 0 && total > 0) {
                memTotal = total
                memUsed = total - available
                memUsage = 100 * (memUsed / total)
            }
            restartTimer.start()
        }
    }

    Timer {
        id: restartTimer
        interval: Style.memoryPollInterval
        onTriggered: {
            memProc.running = true
        }
    }

    Row {
        id: memRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Memory icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Style.iconMemory
            color: root.isHigh ? Colors.error : (root.isMedium ? Colors.warning : Colors.pillIcon)
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Memory percentage
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(root.memUsage) + "%"
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

    // Format bytes to human readable string
    function formatBytes(kb: real): string {
        if (kb >= 1048576) return (kb / 1048576).toFixed(1) + " GB"
        if (kb >= 1024) return (kb / 1024).toFixed(0) + " MB"
        return kb.toFixed(0) + " KB"
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

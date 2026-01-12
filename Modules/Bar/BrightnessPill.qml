import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    property int wheelAccumulator: 0
    property real brightness: 1.0
    property real maxBrightness: 1.0
    property string backlightPath: ""

    readonly property int brightnessPercent: Math.round((brightness / maxBrightness) * 100)
    readonly property bool hasBrightness: backlightPath.length > 0

    visible: hasBrightness
    implicitWidth: visible ? (brightnessRow.implicitWidth + Style.pillPaddingHorizontal * 2) : 0
    tooltip: "Brightness: " + brightnessPercent + "%"

    onWheel: function(event) {
        wheelAccumulator += event.angleDelta.y

        if (wheelAccumulator >= Style.wheelThreshold) {
            wheelAccumulator = 0
            adjustBrightness(0.05)
        } else if (wheelAccumulator <= -Style.wheelThreshold) {
            wheelAccumulator = 0
            adjustBrightness(-0.05)
        }
    }

    onClicked: {
        // Toggle between min and max brightness
        if (brightnessPercent > 50) {
            setBrightness(0.1)
        } else {
            setBrightness(1.0)
        }
    }

    // Find backlight device
    Process {
        id: findBacklightProc
        running: true
        command: ["sh", "-c", "ls -1 /sys/class/backlight/ | head -1"]

        stdout: SplitParser {
            onRead: line => {
                if (line.trim()) {
                    backlightPath = "/sys/class/backlight/" + line.trim()
                    readMaxBrightness.running = true
                }
            }
        }
    }

    // Read max brightness
    Process {
        id: readMaxBrightness
        command: ["cat", backlightPath + "/max_brightness"]

        stdout: SplitParser {
            onRead: line => {
                const val = parseInt(line.trim())
                if (val > 0) {
                    maxBrightness = val
                    readBrightness.running = true
                }
            }
        }
    }

    // Read current brightness
    Process {
        id: readBrightness
        command: ["cat", backlightPath + "/brightness"]

        stdout: SplitParser {
            onRead: line => {
                const val = parseInt(line.trim())
                if (val >= 0) {
                    brightness = val
                }
            }
        }

        onExited: (code, status) => {
            restartTimer.start()
        }
    }

    // Set brightness
    Process {
        id: setBrightnessProc
        property int targetBrightness: 0
        command: ["brightnessctl", "set", targetBrightness.toString()]

        onExited: (code, status) => {
            readBrightness.running = true
        }
    }

    Timer {
        id: restartTimer
        interval: Style.brightnessPollInterval
        onTriggered: {
            if (backlightPath) {
                readBrightness.running = true
            }
        }
    }

    Row {
        id: brightnessRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Brightness icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Style.getBrightnessIcon(root.brightness / root.maxBrightness)
            color: Colors.pillIcon
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Brightness percentage
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.brightnessPercent + "%"
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
        }
    }

    function adjustBrightness(delta: real) {
        const currentPercent = brightness / maxBrightness
        const newPercent = Math.max(0.05, Math.min(1.0, currentPercent + delta))
        setBrightness(newPercent)
    }

    function setBrightness(percent: real) {
        const target = Math.round(percent * maxBrightness)
        setBrightnessProc.targetBrightness = target
        setBrightnessProc.running = true
        root.bounce()
    }
}

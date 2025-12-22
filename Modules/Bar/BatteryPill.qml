import Quickshell
import Quickshell.Services.UPower
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

ClippingRectangle {
    id: root

    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: battery?.isLaptopBattery ?? false
    readonly property bool isReady: hasBattery && (battery?.percentage !== undefined)
    readonly property int percent: isReady ? Math.round(battery.percentage * 100) : 0
    readonly property bool charging: isReady ? (battery.state === UPowerDeviceState.Charging || 
                                                  battery.state === UPowerDeviceState.FullyCharged ||
                                                  battery.state === UPowerDeviceState.PendingCharge) : false
    readonly property bool isLow: percent < 20 && !charging
    readonly property bool isCritical: percent < 10 && !charging

    // Don't show if no battery
    visible: hasBattery
    implicitWidth: visible ? (batteryRow.implicitWidth + Style.pillPaddingHorizontal * 2) : 0
    implicitHeight: Style.pillHeight

    color: {
        if (isCritical) return Colors.red
        if (isLow) return Colors.yellow
        if (charging) return Qt.alpha(Colors.blue, 0.3)
        return Colors.pillBackground
    }
    radius: Style.radiusFull

    Behavior on color {
        ColorAnim {}
    }

    Row {
        id: batteryRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (!isReady) return "󰂎"  // Unknown
                
                if (charging) {
                    return "󰂄"  // Charging
                }
                
                // Battery level icons (10 levels)
                if (percent >= 90) return "󰁹"
                if (percent >= 80) return "󰂂"
                if (percent >= 70) return "󰂁"
                if (percent >= 60) return "󰂀"
                if (percent >= 50) return "󰁿"
                if (percent >= 40) return "󰁾"
                if (percent >= 30) return "󰁽"
                if (percent >= 20) return "󰁼"
                if (percent >= 10) return "󰁻"
                return "󰁺"  // Very low
            }
            color: {
                if (isCritical) return Colors.base
                if (isLow) return Colors.base
                if (charging) return Colors.blue
                return Colors.text
            }
            font.pixelSize: Style.fontSizeLarge
            font.family: "monospace"

            Behavior on color {
                ColorAnim {}
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: percent + "%"
            color: (isCritical || isLow) ? Colors.base : Colors.pillText
            font.pixelSize: Style.fontSizeNormal
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
            // Could open power settings or battery details
            console.log("Battery clicked - State:", battery.state, "Time to empty:", battery.timeToEmpty)
        }
    }

    // Critical battery warning animation
    SequentialAnimation {
        running: isCritical
        loops: Animation.Infinite

        NumberAnimation {
            target: root
            property: "opacity"
            from: 1.0
            to: 0.5
            duration: 500
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: root
            property: "opacity"
            from: 0.5
            to: 1.0
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }
}

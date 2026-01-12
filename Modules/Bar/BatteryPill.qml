import Quickshell
import Quickshell.Services.UPower
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: battery?.isLaptopBattery ?? false
    readonly property bool isReady: hasBattery && (battery?.percentage !== undefined)
    readonly property int percent: isReady ? Math.round(battery.percentage * 100) : 0
    readonly property bool charging: isReady ? (battery.state === UPowerDeviceState.Charging ||
                                                  battery.state === UPowerDeviceState.FullyCharged ||
                                                  battery.state === UPowerDeviceState.PendingCharge) : false
    readonly property bool isLow: percent < Style.batteryLowThreshold && !charging
    readonly property bool isCritical: percent < Style.batteryCriticalThreshold && !charging

    readonly property string timeRemaining: {
        if (!isReady) return ""
        const seconds = charging ? battery.timeToFull : battery.timeToEmpty
        if (seconds <= 0) return ""
        const hours = Math.floor(seconds / 3600)
        const minutes = Math.floor((seconds % 3600) / 60)
        if (hours > 0) return hours + "h " + minutes + "m"
        return minutes + "m"
    }

    visible: hasBattery
    implicitWidth: visible ? (batteryRow.implicitWidth + Style.pillPaddingHorizontal * 2) : 0

    pillColor: {
        if (isCritical) return Colors.batteryCritical
        if (isLow) return Colors.warningContainer
        if (charging) return Colors.primaryContainer
        return Colors.pillBackground
    }

    tooltip: {
        if (!isReady) return "Battery unavailable"
        let tip = percent + "%"
        if (charging) tip += " (Charging)"
        if (timeRemaining) tip += " - " + timeRemaining + " remaining"
        return tip
    }

    onClicked: {
        // Could open power settings
    }

    Row {
        id: batteryRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Battery icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Style.getBatteryIcon(root.percent, root.charging)
            color: {
                if (root.isCritical) return Colors.onError
                if (root.isLow) return Colors.onWarning
                if (root.charging) return Colors.batteryCharging
                return Colors.batteryNormal
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

        // Battery percentage
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.percent + "%"
            color: (root.isCritical || root.isLow) ? Colors.onWarning : Colors.pillText
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

    // Critical battery warning animation
    SequentialAnimation {
        running: root.isCritical
        loops: Animation.Infinite

        NumberAnimation {
            target: root
            property: "opacity"
            from: Style.opacityFull
            to: Style.opacityDisabled
            duration: 500
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: root
            property: "opacity"
            from: Style.opacityDisabled
            to: Style.opacityFull
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }

    // State change feedback
    Connections {
        target: battery

        function onStateChanged() {
            root.bounce()
        }
    }
}

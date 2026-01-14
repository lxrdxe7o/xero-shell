import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    property int wheelAccumulator: 0

    readonly property var source: Pipewire.defaultAudioSource
    readonly property bool hasSource: source?.audio !== undefined
    readonly property bool muted: source?.audio?.muted ?? true
    readonly property real volume: source?.audio?.volume ?? 0
    readonly property int volumePercent: Math.round(volume * 100)

    implicitWidth: micRow.implicitWidth + Style.pillPaddingHorizontal * 2
    pillColor: muted ? Colors.errorContainer : Colors.pillBackground
    tooltip: muted ? "Microphone muted" : "Microphone: " + volumePercent + "%"

    onClicked: {
        if (hasSource) {
            source.audio.muted = !source.audio.muted
        }
    }

    onWheel: function(event) {
        wheelAccumulator += event.angleDelta.y

        if (wheelAccumulator >= Style.wheelThreshold) {
            wheelAccumulator = 0
            if (hasSource) {
                source.audio.muted = false
                source.audio.volume = Math.min(1.0, volume + Style.volumeStep)
            }
        } else if (wheelAccumulator <= -Style.wheelThreshold) {
            wheelAccumulator = 0
            if (hasSource) {
                source.audio.volume = Math.max(0, volume - Style.volumeStep)
            }
        }
    }

    Row {
        id: micRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Microphone icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.muted ? Style.iconMicMuted : Style.iconMic
            color: root.muted ? Colors.error : Colors.pillIcon
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }

            // Pulse animation when unmuted (recording indicator)
            SequentialAnimation on scale {
                running: !root.muted
                loops: Animation.Infinite

                NumberAnimation {
                    from: 1.0
                    to: 1.1
                    duration: 600
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    from: 1.1
                    to: 1.0
                    duration: 600
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Volume percentage (only when not muted)
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.volumePercent + "%"
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
            visible: !root.muted
        }
    }

    // Visual feedback on changes
    onVolumeChanged: bounce()
    onMutedChanged: pulse()
}

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

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool hasSink: sink?.audio !== undefined
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property int volumePercent: Math.round(volume * 100)

    implicitWidth: volumeRow.implicitWidth + Style.pillPaddingHorizontal * 2
    pillColor: muted ? Colors.surfaceVariant : Colors.pillBackground
    tooltip: muted ? "Muted" : "Volume: " + volumePercent + "%"

    onClicked: {
        if (hasSink) {
            sink.audio.muted = !sink.audio.muted
        }
    }

    onWheel: function(event) {
        wheelAccumulator += event.angleDelta.y

        if (wheelAccumulator >= Style.wheelThreshold) {
            wheelAccumulator = 0
            if (hasSink) {
                sink.audio.muted = false
                sink.audio.volume = Math.min(1.0, volume + Style.volumeStep)
            }
        } else if (wheelAccumulator <= -Style.wheelThreshold) {
            wheelAccumulator = 0
            if (hasSink) {
                sink.audio.volume = Math.max(0, volume - Style.volumeStep)
            }
        }
    }

    Row {
        id: volumeRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Volume icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Style.getVolumeIcon(root.volume, root.muted)
            color: root.muted ? Colors.pillIconMuted : Colors.pillIcon
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Volume percentage
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.volumePercent + "%"
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
        }
    }

    // Visual feedback on volume changes
    onVolumeChanged: bounce()
    onMutedChanged: pulse()
}

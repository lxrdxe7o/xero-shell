import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

ClippingRectangle {
    id: root

    property int wheelAccumulator: 0

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property int volumePercent: Math.round(volume * 100)

    implicitWidth: volumeRow.implicitWidth + Style.pillPaddingHorizontal * 2
    implicitHeight: Style.pillHeight

    color: Colors.pillBackground
    radius: Style.radiusFull

    Behavior on color {
        ColorAnim {}
    }

    Row {
        id: volumeRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (muted) return "󰝟"  // Muted
                if (volume >= 0.67) return "󰕾"  // High
                if (volume >= 0.33) return "󰖀"  // Medium
                if (volume > 0) return "󰕿"  // Low
                return "󰝟"  // Zero
            }
            color: muted ? Colors.overlay0 : Colors.text
            font.pixelSize: Style.fontSizeLarge
            font.family: "monospace"

            Behavior on color {
                ColorAnim {}
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: volumePercent + "%"
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: "monospace"
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                // Toggle mute
                if (sink?.audio) {
                    sink.audio.muted = !sink.audio.muted
                }
            }
        }

        onWheel: function(wheel) {
            wheelAccumulator += wheel.angleDelta.y

            if (wheelAccumulator >= 120) {
                wheelAccumulator = 0
                // Increase volume by 5%
                if (sink?.audio) {
                    sink.audio.muted = false
                    sink.audio.volume = Math.min(1.0, volume + 0.05)
                }
            } else if (wheelAccumulator <= -120) {
                wheelAccumulator = 0
                // Decrease volume by 5%
                if (sink?.audio) {
                    sink.audio.volume = Math.max(0, volume - 0.05)
                }
            }
        }
    }

    // Visual feedback on volume changes
    Connections {
        target: sink?.audio

        function onVolumeChanged() {
            feedbackAnim.restart()
        }

        function onMutedChanged() {
            feedbackAnim.restart()
        }
    }

    SequentialAnimation {
        id: feedbackAnim

        NumberAnimation {
            target: root
            property: "scale"
            from: 1.0
            to: 1.1
            duration: Style.animationFast
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: root
            property: "scale"
            from: 1.1
            to: 1.0
            duration: Style.animationFast
            easing.type: Easing.InCubic
        }
    }
}

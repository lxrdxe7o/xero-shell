import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    readonly property var player: Mpris.players.values[0] ?? null
    readonly property bool hasPlayer: player !== null
    readonly property bool isPlaying: hasPlayer && (player.playbackState === MprisPlaybackState.Playing)
    readonly property string trackTitle: player?.trackTitle ?? ""
    readonly property string trackArtist: player?.trackArtist ?? ""
    readonly property string playerName: player?.identity ?? "Media"

    readonly property string displayText: {
        if (!hasPlayer) return "No media"
        if (trackArtist && trackTitle) return trackArtist + " - " + trackTitle
        if (trackTitle) return trackTitle
        return "Unknown"
    }

    visible: hasPlayer
    implicitWidth: visible ? Math.min(mediaRow.implicitWidth + Style.pillPaddingHorizontal * 2, Style.pillMaxWidth) : 0
    pillColor: isPlaying ? Colors.primaryContainer : Colors.pillBackground
    tooltip: hasPlayer ? playerName + ": " + displayText : "No media player"

    onClicked: {
        if (hasPlayer && player.canTogglePlaying) {
            player.togglePlaying()
        }
    }

    onRightClicked: {
        if (hasPlayer && player.canGoNext) {
            player.next()
        }
    }

    onMiddleClicked: {
        if (hasPlayer && player.canGoPrevious) {
            player.previous()
        }
    }

    onWheel: function(event) {
        if (!hasPlayer || !player.canSeek) return

        if (event.angleDelta.y > 0) {
            player.position = Math.min(player.length, player.position + Style.seekAmount)
        } else {
            player.position = Math.max(0, player.position - Style.seekAmount)
        }
    }

    Row {
        id: mediaRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Play/pause icon with animation
        Text {
            id: playIcon
            anchors.verticalCenter: parent.verticalCenter
            text: root.isPlaying ? Style.iconPause : Style.iconPlay
            color: root.isPlaying ? Colors.mediaPlaying : Colors.pillText
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }

            // Pulsing animation when playing
            SequentialAnimation on scale {
                running: root.isPlaying
                loops: Animation.Infinite

                NumberAnimation {
                    from: 1.0
                    to: 1.15
                    duration: 800
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    from: 1.15
                    to: 1.0
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Track info with scrolling
        ScrollingText {
            anchors.verticalCenter: parent.verticalCenter
            text: root.displayText
            color: Colors.pillText
            maxWidth: Style.mediaMaxWidth
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
        }
    }

    // Track change animation
    Connections {
        target: player

        function onTrackTitleChanged() {
            root.bounce()
        }

        function onPlaybackStateChanged() {
            root.pulse()
        }
    }
}

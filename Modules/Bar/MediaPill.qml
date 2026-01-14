import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    readonly property var player: Mpris.players.values[0] ?? null
    readonly property bool hasPlayer: player !== null
    readonly property bool isPlaying: hasPlayer && (player.playbackState === MprisPlaybackState.Playing)
    readonly property string trackTitle: player?.trackTitle ?? ""
    readonly property string trackArtist: player?.trackArtist ?? ""
    readonly property string trackAlbum: player?.trackAlbum ?? ""
    readonly property string playerName: player?.identity ?? "Media"
    readonly property url albumArt: player?.trackArtUrl ?? ""
    readonly property bool hasAlbumArt: albumArt.toString() !== ""

    readonly property string displayText: {
        if (!hasPlayer) return "No media"
        if (trackArtist && trackTitle) return trackArtist + " - " + trackTitle
        if (trackTitle) return trackTitle
        return "Unknown"
    }

    visible: hasPlayer
    implicitWidth: visible ? Math.min(mediaRow.implicitWidth + Style.pillPaddingHorizontal * 2, Style.pillMaxWidth) : 0
    pillColor: isPlaying ? Colors.primaryContainer : Colors.pillBackground
    tooltip: {
        if (!hasPlayer) return "No media player"
        let tip = playerName + "\n" + displayText
        if (trackAlbum) tip += "\nAlbum: " + trackAlbum
        return tip
    }

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

        // Album art thumbnail
        Item {
            id: albumArtContainer
            width: Style.pillHeight - Style.spacingNormal
            height: width
            anchors.verticalCenter: parent.verticalCenter
            visible: root.hasAlbumArt

            Rectangle {
                id: albumArtMask
                anchors.fill: parent
                radius: Style.radiusSmall
                color: Colors.surface0
                visible: false
            }

            Image {
                id: albumArtImage
                anchors.fill: parent
                source: root.albumArt
                sourceSize: Qt.size(width * 2, height * 2)
                fillMode: Image.PreserveAspectCrop
                smooth: true
                antialiasing: true
                asynchronous: true
                visible: false
            }

            // Rounded album art using ShaderEffectSource
            ShaderEffectSource {
                anchors.fill: parent
                sourceItem: albumArtImage
                visible: albumArtImage.status === Image.Ready

                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: albumArtMask
                }
            }

            // Fallback if no album art or loading
            Rectangle {
                anchors.fill: parent
                radius: Style.radiusSmall
                color: Colors.surface0
                visible: !albumArtImage.status === Image.Ready || !root.hasAlbumArt

                Text {
                    anchors.centerIn: parent
                    text: Style.iconMusic
                    color: Colors.pillIcon
                    font.pixelSize: Style.fontSizeNormal
                    font.family: Style.iconFont
                }
            }

            // Playing indicator overlay
            Rectangle {
                anchors.fill: parent
                radius: Style.radiusSmall
                color: Colors.scrim
                opacity: root.isPlaying ? 0.3 : 0.6
                visible: albumArtImage.status === Image.Ready

                Behavior on opacity {
                    NumberAnimation { duration: Style.animationFast }
                }
            }
        }

        // Play/pause icon (shown when no album art, or as overlay indicator)
        Text {
            id: playIcon
            anchors.verticalCenter: parent.verticalCenter
            text: root.isPlaying ? Style.iconPause : Style.iconPlay
            color: root.isPlaying ? Colors.mediaPlaying : Colors.pillText
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont
            visible: !root.hasAlbumArt

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }

            // Pulsing animation when playing
            SequentialAnimation on scale {
                running: root.isPlaying && !root.hasAlbumArt
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

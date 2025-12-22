import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

ClippingRectangle {
    id: root

    readonly property var player: Mpris.players.values[0] ?? null
    readonly property bool hasPlayer: player !== null
    readonly property bool isPlaying: hasPlayer && (player.playbackState === MprisPlaybackState.Playing)
    readonly property string trackTitle: player?.trackTitle ?? ""
    readonly property string trackArtist: player?.trackArtist ?? ""
    readonly property string displayText: {
        if (!hasPlayer) return "No media"
        if (trackArtist && trackTitle) return trackArtist + " - " + trackTitle
        if (trackTitle) return trackTitle
        return "Unknown"
    }

    // Hide when no player
    visible: hasPlayer
    implicitWidth: visible ? Math.min(mediaRow.implicitWidth + Style.pillPaddingHorizontal * 2, 350) : 0
    implicitHeight: Style.pillHeight

    color: isPlaying ? Qt.alpha(Colors.blue, 0.3) : Colors.pillBackground
    radius: Style.radiusFull

    Behavior on color {
        ColorAnim {}
    }

    Behavior on implicitWidth {
        Anim {}
    }

    Row {
        id: mediaRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Play/pause icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: isPlaying ? "󰏤" : "󰐊"  // Pause / Play
            color: isPlaying ? Colors.blue : Colors.text
            font.pixelSize: Style.fontSizeLarge
            font.family: "monospace"

            Behavior on color {
                ColorAnim {}
            }

            // Animate when playing
            SequentialAnimation on scale {
                running: isPlaying
                loops: Animation.Infinite

                NumberAnimation {
                    from: 1.0
                    to: 1.1
                    duration: 800
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    from: 1.1
                    to: 1.0
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Track info with scrolling
        Item {
            anchors.verticalCenter: parent.verticalCenter
            width: Math.min(trackText.implicitWidth, 250)
            height: trackText.implicitHeight
            clip: true

            Text {
                id: trackText
                text: displayText
                color: Colors.text
                font.pixelSize: Style.fontSizeNormal
                font.family: "monospace"

                Behavior on color {
                    ColorAnim {}
                }

                property bool needsScroll: implicitWidth > 250

                // Seamless scrolling for long track names
                SequentialAnimation on x {
                    running: trackText.needsScroll && hasPlayer
                    loops: Animation.Infinite

                    PauseAnimation { duration: 2000 }

                    NumberAnimation {
                        from: 0
                        to: -(trackText.implicitWidth - 250)
                        duration: Math.max(4000, (trackText.implicitWidth - 250) * 15)
                        easing.type: Easing.Linear
                    }

                    PauseAnimation { duration: 1000 }

                    NumberAnimation {
                        from: -(trackText.implicitWidth - 250)
                        to: 0
                        duration: Math.max(4000, (trackText.implicitWidth - 250) * 15)
                        easing.type: Easing.Linear
                    }

                    PauseAnimation { duration: 2000 }
                }

                onTextChanged: {
                    x = 0
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        
        onClicked: function(mouse) {
            if (!hasPlayer) return

            if (mouse.button === Qt.LeftButton) {
                // Toggle play/pause
                if (player.canTogglePlaying) {
                    player.togglePlaying()
                }
            } else if (mouse.button === Qt.RightButton) {
                // Next track
                if (player.canGoNext) {
                    player.next()
                }
            } else if (mouse.button === Qt.MiddleButton) {
                // Previous track
                if (player.canGoPrevious) {
                    player.previous()
                }
            }
        }

        onWheel: function(wheel) {
            if (!hasPlayer || !player.canSeek) return

            // Seek forward/backward
            const seekAmount = 5000000  // 5 seconds in microseconds
            if (wheel.angleDelta.y > 0) {
                player.position = Math.min(player.length, player.position + seekAmount)
            } else {
                player.position = Math.max(0, player.position - seekAmount)
            }
        }
    }

    // Track change animation
    Connections {
        target: player

        function onTrackTitleChanged() {
            trackChangeFeedback.restart()
        }
    }

    SequentialAnimation {
        id: trackChangeFeedback

        NumberAnimation {
            target: root
            property: "scale"
            from: 1.0
            to: 1.05
            duration: Style.animationFast
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: root
            property: "scale"
            from: 1.05
            to: 1.0
            duration: Style.animationFast
            easing.type: Easing.InCubic
        }
    }

    // Update position for seek bar (if we add one later)
    Timer {
        running: isPlaying
        interval: 1000
        repeat: true
        onTriggered: {
            if (player?.positionSupported) {
                // Force position update
                player.positionChanged()
            }
        }
    }
}

import QtQuick
import "../Commons"

Item {
    id: root

    property alias text: label.text
    property alias color: label.color
    property alias font: label.font
    property int maxWidth: Style.textMaxWidth
    property int scrollPauseDuration: Style.scrollPauseDuration
    property int scrollSpeed: Style.scrollSpeed

    readonly property bool needsScroll: label.implicitWidth > maxWidth

    width: Math.min(label.implicitWidth, maxWidth)
    height: label.implicitHeight
    clip: true

    Text {
        id: label
        color: Colors.text
        font.pixelSize: Style.fontSizeNormal
        font.family: Style.fontFamily

        Behavior on color {
            ColorAnimation {
                duration: Style.animationFast
                easing.type: Easing.InOutQuad
            }
        }

        SequentialAnimation on x {
            id: scrollAnimation
            running: root.needsScroll
            loops: Animation.Infinite

            PauseAnimation { duration: root.scrollPauseDuration }

            NumberAnimation {
                from: 0
                to: -(label.implicitWidth - root.maxWidth)
                duration: Math.max(Style.animationSlow * 2, (label.implicitWidth - root.maxWidth) * root.scrollSpeed)
                easing.type: Easing.Linear
            }

            PauseAnimation { duration: root.scrollPauseDuration / 2 }

            NumberAnimation {
                from: -(label.implicitWidth - root.maxWidth)
                to: 0
                duration: Math.max(Style.animationSlow * 2, (label.implicitWidth - root.maxWidth) * root.scrollSpeed)
                easing.type: Easing.Linear
            }

            PauseAnimation { duration: root.scrollPauseDuration }
        }

        onTextChanged: {
            x = 0
            if (scrollAnimation.running) {
                scrollAnimation.restart()
            }
        }
    }

    function resetScroll() {
        label.x = 0
        scrollAnimation.restart()
    }
}

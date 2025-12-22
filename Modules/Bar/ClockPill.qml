import Quickshell
import Quickshell.Widgets
import QtQuick
import "../../Commons"
import "../../Components"

ClippingRectangle {
    id: root

    implicitWidth: clockText.implicitWidth + Style.pillPaddingHorizontal * 2
    implicitHeight: Style.pillHeight

    color: Colors.pillBackground
    radius: Style.radiusFull

    Behavior on color {
        ColorAnim {}
    }

    Text {
        id: clockText
        anchors.centerIn: parent
        text: Qt.formatTime(new Date(), "hh:mm")
        color: Colors.pillText
        font.pixelSize: Style.fontSizeNormal
        font.family: "monospace"

        Behavior on color {
            ColorAnim {}
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clockText.text = Qt.formatTime(new Date(), "hh:mm")
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            // Show date on click
            clockText.text = Qt.formatDateTime(new Date(), "MMM dd hh:mm")
        }
    }
}

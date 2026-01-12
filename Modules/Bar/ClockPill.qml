import Quickshell
import Quickshell.Widgets
import QtQuick
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    property bool showDate: false
    property bool showSeconds: false

    readonly property string timeFormat: showSeconds ? "hh:mm:ss" : "hh:mm"
    readonly property string dateFormat: "ddd, MMM d"
    readonly property string fullFormat: dateFormat + " " + timeFormat

    property date currentTime: new Date()
    readonly property string displayText: showDate ? Qt.formatDateTime(currentTime, fullFormat) : Qt.formatTime(currentTime, timeFormat)

    implicitWidth: clockRow.implicitWidth + Style.pillPaddingHorizontal * 2
    tooltip: Qt.formatDateTime(currentTime, "dddd, MMMM d, yyyy")

    onClicked: {
        showDate = !showDate
    }

    onRightClicked: {
        showSeconds = !showSeconds
    }

    Timer {
        interval: root.showSeconds ? 1000 : Style.clockUpdateInterval
        running: true
        repeat: true
        onTriggered: {
            root.currentTime = new Date()
        }
    }

    Row {
        id: clockRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Clock icon (optional, shows on hover)
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.showDate ? Style.iconCalendar : Style.iconClock
            color: Colors.primary
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont
            visible: root.hovered

            Behavior on opacity {
                NumberAnimation {
                    duration: Style.animationFast
                }
            }
        }

        // Time/date display
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.displayText
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
            font.bold: root.showDate

            Behavior on color {
                ColorAnimation {
                    duration: Style.animationFast
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    // Mode change feedback
    onShowDateChanged: bounce()
    onShowSecondsChanged: pulse()
}

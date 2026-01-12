import QtQuick
import Quickshell.Widgets
import "../Commons"

ClippingRectangle {
    id: root

    // Content properties
    property alias contentItem: contentLoader.sourceComponent
    property alias contentData: contentContainer.data

    // Appearance
    property color pillColor: Colors.pillBackground
    property bool hovered: mouseArea.containsMouse

    // Tooltip
    property string tooltip: ""
    property bool showTooltip: tooltip.length > 0 && hovered

    // Interaction
    property bool interactive: true
    signal clicked(var mouse)
    signal rightClicked(var mouse)
    signal middleClicked(var mouse)
    signal wheel(var wheel)

    implicitHeight: Style.pillHeight
    color: pillColor
    radius: Style.radiusFull

    Behavior on color {
        ColorAnimation {
            duration: Style.animationFast
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Style.animationNormal
            easing.type: Easing.OutCubic
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: Style.animationFast
            easing.type: Easing.OutCubic
        }
    }

    // Content container
    Item {
        id: contentContainer
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height

        Loader {
            id: contentLoader
            active: sourceComponent !== null
        }
    }

    // Mouse interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.interactive
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                root.clicked(mouse)
            } else if (mouse.button === Qt.RightButton) {
                root.rightClicked(mouse)
            } else if (mouse.button === Qt.MiddleButton) {
                root.middleClicked(mouse)
            }
        }

        onWheel: function(event) {
            root.wheel(event)
        }
    }

    // Tooltip
    Rectangle {
        id: tooltipRect
        visible: root.showTooltip
        x: (parent.width - width) / 2
        y: parent.height + Style.spacingSmall

        width: tooltipText.implicitWidth + Style.paddingNormal * 2
        height: tooltipText.implicitHeight + Style.paddingSmall * 2
        radius: Style.radiusSmall
        color: Colors.surface1

        Text {
            id: tooltipText
            anchors.centerIn: parent
            text: root.tooltip
            color: Colors.text
            font.pixelSize: Style.fontSizeSmall
            font.family: Style.fontFamily
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Style.animationFast
            }
        }
    }

    // Feedback animation
    function bounce() {
        feedbackAnim.restart()
    }

    function pulse() {
        pulseAnim.restart()
    }

    SequentialAnimation {
        id: feedbackAnim

        NumberAnimation {
            target: root
            property: "scale"
            from: 1.0
            to: 1.08
            duration: Style.animationFast
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: root
            property: "scale"
            from: 1.08
            to: 1.0
            duration: Style.animationFast
            easing.type: Easing.InCubic
        }
    }

    SequentialAnimation {
        id: pulseAnim

        NumberAnimation {
            target: root
            property: "scale"
            from: 1.0
            to: 0.95
            duration: Style.animationFast
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: root
            property: "scale"
            from: 0.95
            to: 1.0
            duration: Style.animationFast
            easing.type: Easing.InCubic
        }
    }

    // Hover effect
    states: State {
        name: "hovered"
        when: hovered && interactive
        PropertyChanges {
            target: root
            color: Qt.lighter(pillColor, 1.1)
        }
    }
}

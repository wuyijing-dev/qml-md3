import QtQuick
import Md3

Item {
    id: root

    property string text: ""
    property string actionText: ""
    property bool dualLine: false
    property bool open: false
    property int durationMs: 4000

    signal actionClicked()
    signal closed()

    // Prefer anchoring from the caller to a viewport overlay (not Flickable contentItem).
    height: dualLine ? 68 : 48
    visible: open || opacity > 0.01
    opacity: open ? 1 : 0
    z: 1200

    function show(message) {
        if (message !== undefined)
            text = message
        open = true
        hideTimer.restart()
    }

    function dismiss() {
        open = false
        closed()
    }

    Timer {
        id: hideTimer
        interval: root.durationMs
        onTriggered: root.dismiss()
    }

    Behavior on opacity {
        NumberAnimation {
                    duration: Md3Motion.overlayDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
    }

    // Slide up from below the anchored bottom edge
    property real slideY: open ? 0 : height + 8
    transform: Translate {
        y: root.slideY
        Behavior on y {
            NumberAnimation {
                    duration: Md3Motion.spatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Md3Theme.shape.extraSmall
        color: Md3Theme.colorScheme.inverseSurface

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 8
            spacing: 8

            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - (root.actionText.length > 0 ? 96 : 0)
                text: root.text
                color: Md3Theme.colorScheme.colorOnInverseSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyMedium.size
                wrapMode: root.dualLine ? Text.Wrap : Text.NoWrap
                elide: Text.ElideRight
                maximumLineCount: root.dualLine ? 2 : 1
            }

            Md3Button {
                visible: root.actionText.length > 0
                text: root.actionText
                variant: Md3Button.Text
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    root.actionClicked()
                    root.dismiss()
                }
            }
        }
    }
}

import QtQuick
import Md3

Item {
    id: root

    property string text: ""
    property string actionText: ""
    property bool dualLine: false
    property bool open: false
    property int durationMs: 4000
    /// Extra dwell when an action is present (Undo / View).
    property int actionDurationMs: 6500
    /// When true, snackbar is not an assertive live region (avoids stealing AT focus).
    property bool politeAnnouncements: true
    property real _dragX: 0
    readonly property real _dragFade: Math.max(0.35, 1 - Math.min(1, Math.abs(_dragX) / Math.max(48, width * 0.45)))

    signal actionClicked()
    signal closed()

    // Prefer anchoring from the caller to a viewport overlay (not Flickable contentItem).
    height: dualLine ? 68 : 48
    visible: open || opacity > 0.01
    opacity: open ? _dragFade : 0
    z: 1200

    Accessible.role: Accessible.Status
    Accessible.name: text.length ? text : qsTr("Snackbar")
    // Do not grab keyboard focus while other controls are focused.
    activeFocusOnTab: false
    focus: false

    readonly property int _effectiveDuration: actionText.length > 0
            ? Math.max(durationMs, actionDurationMs)
            : durationMs

    function show(message) {
        if (message !== undefined)
            text = message
        open = true
        _dragX = 0
        hideTimer.interval = _effectiveDuration
        hideTimer.restart()
        if (politeAnnouncements && typeof Md3Accessibility !== "undefined" && Md3Accessibility.announce)
            Md3Accessibility.announce(text)
    }

    function dismiss() {
        open = false
        _dragX = 0
        hideTimer.stop()
        closed()
    }

    Timer {
        id: hideTimer
        interval: root._effectiveDuration
        onTriggered: root.dismiss()
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Md3Motion.overlayDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }

    function _snapDragBack() {
        if (Md3Theme.reduceMotion || Math.abs(_dragX) < 0.5) {
            _dragX = 0
            return
        }
        snapDragAnim.stop()
        snapDragAnim.from = _dragX
        snapDragAnim.to = 0
        snapDragAnim.start()
    }

    NumberAnimation {
        id: snapDragAnim
        target: root
        property: "_dragX"
        duration: Md3Motion.short3
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Md3Motion.emphasized
    }

    // Slide up from below the anchored bottom edge
    property real slideY: open ? 0 : height + 8
    transform: [
        Translate {
            y: root.slideY
            Behavior on y {
                NumberAnimation {
                    duration: Md3Motion.spatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }
        },
        Translate {
            x: root._dragX
        }
    ]

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

        MouseArea {
            anchors.fill: parent
            // Action button keeps its own hit target above when present.
            enabled: root.actionText.length === 0
            property real _sx: 0
            onPressed: function (mouse) {
                snapDragAnim.stop()
                _sx = mouse.x
                hideTimer.stop()
            }
            onPositionChanged: function (mouse) {
                root._dragX = mouse.x - _sx
            }
            onReleased: function (mouse) {
                if (Math.abs(root._dragX) > Math.min(96, root.width * 0.28))
                    root.dismiss()
                else {
                    root._snapDragBack()
                    if (root.open)
                        hideTimer.restart()
                }
            }
            onCanceled: {
                root._snapDragBack()
                if (root.open)
                    hideTimer.restart()
            }
        }

        // When an action exists, swipe from the text area only (left side).
        MouseArea {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width - 96
            visible: root.actionText.length > 0
            property real _sx: 0
            onPressed: function (mouse) {
                snapDragAnim.stop()
                _sx = mouse.x
                hideTimer.stop()
            }
            onPositionChanged: function (mouse) {
                root._dragX = mouse.x - _sx
            }
            onReleased: function (mouse) {
                if (Math.abs(root._dragX) > Math.min(96, root.width * 0.28))
                    root.dismiss()
                else {
                    root._snapDragBack()
                    if (root.open)
                        hideTimer.restart()
                }
            }
            onCanceled: {
                root._snapDragBack()
                if (root.open)
                    hideTimer.restart()
            }
        }
    }
}

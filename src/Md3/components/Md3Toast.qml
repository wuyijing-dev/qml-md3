import QtQuick
import Md3

/// Short-lived toast chip. Prefer Md3ToastHost / Md3Notify.toast for stacking & position.
Item {
    id: root

    enum Severity { Default, Success, Warning, Error }

    property string text: ""
    property int severity: Md3Toast.Default
    property int durationMs: 2200
    property bool open: false
    property real maxWidth: 420
    property real _dragX: 0
    property bool pauseOnHover: true
    property bool _hovering: false

    signal closed()

    width: Math.min(maxWidth, box.implicitWidth)
    height: box.implicitHeight
    visible: open || opacity > 0.01 || scale > 0.92
    opacity: open ? 1 : 0
    scale: open ? 1 : 0.94
    transformOrigin: Item.Center
    activeFocusOnTab: false
    focus: false

    Accessible.role: Accessible.Status
    Accessible.name: text.length ? text : qsTr("Toast")

    readonly property color bg: {
        switch (severity) {
        case Md3Toast.Success: return Md3Theme.colorScheme.primaryContainer
        case Md3Toast.Warning: return Md3Theme.colorScheme.tertiaryContainer
        case Md3Toast.Error: return Md3Theme.colorScheme.errorContainer
        default: return Md3Theme.colorScheme.inverseSurface
        }
    }
    readonly property color fg: {
        switch (severity) {
        case Md3Toast.Success: return Md3Theme.colorScheme.colorOnPrimaryContainer
        case Md3Toast.Warning: return Md3Theme.colorScheme.colorOnTertiaryContainer
        case Md3Toast.Error: return Md3Theme.colorScheme.colorOnErrorContainer
        default: return Md3Theme.colorScheme.colorOnInverseSurface
        }
    }

    function show(message, options) {
        const opts = options || {}
        if (message !== undefined)
            text = String(message)
        if (opts.severity !== undefined)
            severity = Number(opts.severity)
        if (opts.durationMs !== undefined)
            durationMs = Number(opts.durationMs)
        if (opts.pauseOnHover !== undefined)
            pauseOnHover = !!opts.pauseOnHover
        open = true
        _dragX = 0
        _hovering = false
        hideTimer.restart()
        if (typeof Md3Accessibility !== "undefined" && Md3Accessibility.announce)
            Md3Accessibility.announce(text)
    }

    function dismiss() {
        if (!open)
            return
        open = false
        _dragX = 0
        hideTimer.stop()
        closed()
    }

    Timer {
        id: hideTimer
        interval: root.durationMs
        onTriggered: root.dismiss()
    }

    HoverHandler {
        enabled: root.pauseOnHover && root.open
        onHoveredChanged: {
            root._hovering = hovered
            if (hovered)
                hideTimer.stop()
            else if (root.open)
                hideTimer.restart()
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Md3Motion.overlayDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: Md3Motion.spatialDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }

    transform: Translate { x: root._dragX }

    Rectangle {
        id: box
        anchors.fill: parent
        radius: Md3Theme.shape.full
        color: root.bg
        implicitWidth: Math.min(root.maxWidth, label.implicitWidth + 40)
        implicitHeight: label.implicitHeight + 20

        Text {
            id: label
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            text: root.text
            color: root.fg
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            maximumLineCount: 2
            elide: Text.ElideRight
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodyMedium.size
        }

        MouseArea {
            anchors.fill: parent
            property real _sx: 0
            onPressed: function (mouse) {
                _sx = mouse.x
                hideTimer.stop()
            }
            onPositionChanged: function (mouse) {
                root._dragX = mouse.x - _sx
            }
            onReleased: function (mouse) {
                if (Math.abs(root._dragX) > Math.min(72, root.width * 0.32))
                    root.dismiss()
                else {
                    root._dragX = 0
                    if (root.open)
                        hideTimer.restart()
                }
            }
            onCanceled: {
                root._dragX = 0
                if (root.open)
                    hideTimer.restart()
            }
        }
    }
}

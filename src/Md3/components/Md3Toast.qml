import QtQuick

/// Short-lived toast — top-center, non-blocking. Prefer Snackbar for actions / bottom queue,
/// InfoBar for persistent in-page status.
Item {
    id: root

    enum Severity { Default, Success, Warning, Error }

    property string text: ""
    property int severity: Md3Toast.Default
    property int durationMs: 2200
    property bool open: false
    property real maxWidth: 420

    signal closed()

    width: Math.min(maxWidth, (parent ? parent.width : maxWidth) - 48)
    height: box.implicitHeight
    visible: open || opacity > 0.01
    opacity: open ? 1 : 0
    z: 1300
    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
    anchors.top: parent ? parent.top : undefined
    anchors.topMargin: 16 + (open ? 0 : -8)

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
        open = true
        hideTimer.restart()
    }

    function dismiss() {
        if (!open)
            return
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
    Behavior on anchors.topMargin {
        NumberAnimation {
            duration: Md3Motion.spatialDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }

    Rectangle {
        id: box
        anchors.fill: parent
        radius: Md3Theme.shape.full
        color: root.bg
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
    }
}

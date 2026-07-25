import QtQuick
import QtQuick.Window

/*
  Material 3 Loading indicator — indeterminate (or determinate) circular spinner
  with optional caption. Built on the same paint path as circular progress.
*/
Item {
    id: root

    enum Size { Small, Medium, Large }

    property int sizePreset: Md3LoadingIndicator.Medium
    property real value: 0
    property bool indeterminate: true
    property string label: ""
    property color indicatorColor: Md3Theme.colorScheme.primary
    property color trackColor: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.2)
    property real strokeWidth: {
        switch (sizePreset) {
        case Md3LoadingIndicator.Small: return 3
        case Md3LoadingIndicator.Large: return 5
        default: return 4
        }
    }
    property real indicatorSize: {
        switch (sizePreset) {
        case Md3LoadingIndicator.Small: return 24
        case Md3LoadingIndicator.Large: return 48
        default: return 36
        }
    }

    readonly property bool sceneActive: enabled && visible && opacity > 0.01
                                        && (!Window.window || Window.window.visibility !== Window.Hidden)
    readonly property real radius: indicatorSize / 2 - strokeWidth

    property real rotation: -Math.PI / 2
    property real sweep: Math.PI * 0.65
    property real sweepDir: 1
    property real spinSpeed: Math.PI * 2 / (Md3Motion.progressSpin / 1000)

    implicitWidth: Math.max(indicatorSize, labelItem.visible ? labelItem.implicitWidth : 0)
    implicitHeight: indicatorSize + (labelItem.visible ? labelItem.implicitHeight + 8 : 0)
    width: implicitWidth
    height: implicitHeight

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8

        Item {
            width: root.indicatorSize
            height: root.indicatorSize
            anchors.horizontalCenter: parent.horizontalCenter

            Canvas {
                id: canvas
                anchors.fill: parent
                antialiasing: true
                smooth: true
                renderStrategy: Canvas.Cooperative

                onPaint: {
                    const ctx = getContext("2d")
                    ctx.reset()
                    ctx.clearRect(0, 0, width, height)
                    const cx = width / 2
                    const cy = height / 2
                    const r = root.radius
                    ctx.lineWidth = root.strokeWidth
                    ctx.lineCap = "round"

                    // Track ring
                    ctx.beginPath()
                    ctx.strokeStyle = root.trackColor
                    ctx.arc(cx, cy, r, 0, Math.PI * 2)
                    ctx.stroke()

                    // Active arc
                    let start = root.rotation
                    let sweep = root.indeterminate ? root.sweep
                                                   : Math.max(0.001, Math.min(1, root.value)) * Math.PI * 2
                    ctx.beginPath()
                    ctx.strokeStyle = root.indicatorColor
                    ctx.arc(cx, cy, r, start, start + sweep)
                    ctx.stroke()
                }
            }
        }

        Text {
            id: labelItem
            visible: root.label.length > 0
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
            horizontalAlignment: Text.AlignHCenter
        }
    }

    FrameAnimation {
        running: root.sceneActive && root.indeterminate
        onTriggered: {
            const dt = frameTime
            root.rotation += root.spinSpeed * dt
            root.sweep += root.sweepDir * Math.PI * 1.1 * dt
            if (root.sweep > Math.PI * 1.2) {
                root.sweep = Math.PI * 1.2
                root.sweepDir = -1
            } else if (root.sweep < Math.PI * 0.3) {
                root.sweep = Math.PI * 0.3
                root.sweepDir = 1
            }
            canvas.requestPaint()
        }
    }

    onValueChanged: if (!indeterminate) canvas.requestPaint()
    onIndeterminateChanged: canvas.requestPaint()
    onIndicatorColorChanged: canvas.requestPaint()
    onVisibleChanged: if (visible) canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()
}

import QtQuick

/// Shared zoom/pan + inertia + probe tooltip for Md3Chart children.
/// Host chart must implement `_updateProbeAtPixel(px)` (and optional `_updateProbeAtPos(x,y)`).
Item {
    id: root

    anchors.fill: parent
    z: 50

    property var chart: parent
    property string probeTitle: chart && chart.probeTitle !== undefined
                                ? chart.probeTitle : qsTr("Point")
    property bool showCrosshair: true
    /// When false, only hover probe (pie / etc.).
    property bool enableZoomPan: true
    property bool usePlotMargins: true

    readonly property real _left: usePlotMargins && chart ? chart.plotLeft : 0
    readonly property real _right: usePlotMargins && chart ? chart.contentPadding : 0
    readonly property real _top: usePlotMargins && chart ? chart.plotTop : 0
    readonly property real _bottom: usePlotMargins && chart
                                    ? (chart.height - chart.plotBottom) : 0

    // Crosshair
    Rectangle {
        visible: root.showCrosshair && chart && chart.probeActive && chart.showProbe
        x: chart.probePixelX - 0.5
        y: chart.plotTop
        width: 1
        height: chart.plotHeight
        color: Md3Theme.colorScheme.outline
        opacity: 0.7
        z: 20
    }

    Rectangle {
        id: tip
        visible: chart && chart.probeActive && chart.showProbe && chart.probeSeries.length > 0
        z: 40
        width: tipCol.implicitWidth + 16
        height: tipCol.implicitHeight + 12
        radius: Md3Theme.shape.small
        color: Md3Theme.colorScheme.surfaceContainerHigh
        border.width: 1
        border.color: Md3Theme.colorScheme.outlineVariant
        x: Math.min(root.width - width - 4,
                    Math.max(4, chart.probePixelX + 12))
        y: Math.max(4, Math.min(root.height - height - 4,
                                (chart.probePixelY > 0 ? chart.probePixelY - height - 8
                                                       : chart.plotTop + 4)))

        Column {
            id: tipCol
            anchors.centerIn: parent
            spacing: 2
            Text {
                text: {
                    if (!chart)
                        return ""
                    const cat = chart.categoryLabel ? chart.categoryLabel(chart.probeIndex)
                                                    : ("#" + chart.probeIndex)
                    return root.probeTitle + "  " + cat
                }
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: 11
                font.family: Md3Theme.typography.fontFamily
            }
            Repeater {
                model: chart ? chart.probeSeries : []
                delegate: Text {
                    required property var modelData
                    text: modelData.label + ": "
                          + Number(modelData.value).toFixed(chart.valueDecimals)
                          + chart.yUnit
                    color: modelData.color
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    font.family: Md3Theme.typography.fontFamily
                }
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        anchors.leftMargin: root._left
        anchors.rightMargin: root._right
        anchors.topMargin: root._top
        anchors.bottomMargin: root._bottom
        hoverEnabled: chart && (chart.showProbe || (root.enableZoomPan && chart.interactive))
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.LeftButton
        preventStealing: root.enableZoomPan && chart && chart.interactive
                         && (pressed || dragging)
        property bool dragging: false
        property real lastX: 0
        property real lastTs: 0
        property real velEma: 0

        function globalX(mx) { return mx + root._left }
        function globalY(my) { return my + root._top }

        function probeAt(mx, my) {
            if (!chart || !chart.showProbe)
                return
            if (typeof chart._updateProbeAtPos === "function")
                chart._updateProbeAtPos(globalX(mx), globalY(my))
            else if (typeof chart._updateProbeAtPixel === "function")
                chart._updateProbeAtPixel(globalX(mx))
        }

        onPositionChanged: function (mouse) {
            if (chart && chart.showProbe && (!pressed || !(root.enableZoomPan && chart.interactive)))
                probeAt(mouse.x, mouse.y)
            if (dragging && root.enableZoomPan && chart && chart.interactive) {
                const dx = mouse.x - lastX
                lastX = mouse.x
                const now = Date.now()
                const dt = Math.max(1, now - lastTs)
                lastTs = now
                const frac = -dx / Math.max(1, width)
                const delta = frac * chart.viewSpan
                // EMA velocity in view-space per ~16ms frame
                const instant = delta * (16 / dt)
                velEma = velEma * 0.65 + instant * 0.35
                chart.panByFrac(delta, true)
                chart._panVelocity = velEma
                probeAt(mouse.x, mouse.y)
            }
        }
        onEntered: probeAt(mouseX, mouseY)
        onExited: {
            if (!pressed && chart)
                chart.clearProbe()
        }
        onPressed: function (mouse) {
            if (!(root.enableZoomPan && chart && chart.interactive))
                return
            dragging = true
            lastX = mouse.x
            lastTs = Date.now()
            velEma = 0
            chart.beginGesture()
            preventStealing = true
        }
        onReleased: {
            if (!dragging)
                return
            dragging = false
            if (chart) {
                chart._panVelocity = velEma
                chart.endGesture()
            }
        }
        onCanceled: {
            dragging = false
            if (chart)
                chart.endGesture()
        }
        onDoubleClicked: {
            if (root.enableZoomPan && chart && chart.interactive)
                chart.resetView()
        }
        onWheel: function (wheel) {
            if (!(root.enableZoomPan && chart && chart.interactive)) {
                wheel.accepted = false
                return
            }
            if (!chart.gestureActive)
                chart.beginGesture()
            const frac = Math.min(1, Math.max(0, wheel.x / Math.max(1, width)))
            // Softer zoom steps for smoother feel
            const factor = wheel.angleDelta.y > 0 ? 0.88 : 1.14
            chart.zoomAt(frac, factor)
            probeAt(wheel.x, wheel.y)
            wheel.accepted = true
            wheelEnd.restart()
        }
    }

    Timer {
        id: wheelEnd
        interval: 120
        onTriggered: {
            if (chart && !mouse.dragging)
                chart.endGesture()
        }
    }
}

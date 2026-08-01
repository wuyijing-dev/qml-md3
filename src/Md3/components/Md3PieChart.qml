import QtQuick
import Md3

/// Pie / donut chart with hover probe (slice value + percent).
/// Slices drawn on one Canvas (no per-slice Shape Repeater).
Md3Chart {
    id: root

    showGrid: false
    showYLabels: false
    showArea: false
    showDots: false
    smooth: false
    interactive: false
    /// Inner radius ratio 0 = pie, 0.55 ≈ donut.
    property real innerRatio: 0
    property bool showPercentLabels: true
    property real startAngle: -90 // degrees, 0 = 3 o'clock

    readonly property real cx: width / 2
    readonly property real cy: height / 2
    readonly property real outerR: Math.max(8, Math.min(width, height) / 2 - contentPadding)
    readonly property real innerR: outerR * Math.min(0.92, Math.max(0, innerRatio))

    function rebuild() {
        const nums = seriesNums(values)
        let total = 0
        for (let i = 0; i < nums.length; ++i)
            total += Math.abs(nums[i])
        const slices = []
        let angle = startAngle
        if (total > 0) {
            for (let i = 0; i < nums.length; ++i) {
                const v = Math.abs(nums[i])
                const sweep = 360 * (v / total)
                const mid = angle + sweep / 2
                const rad = mid * Math.PI / 180
                const labelR = (outerR + innerR) * 0.5
                slices.push({
                    index: i,
                    value: nums[i],
                    percent: 100 * v / total,
                    start: angle,
                    sweep: sweep,
                    color: colorAt(i),
                    label: categoryLabel(i),
                    lx: cx + Math.cos(rad) * labelR,
                    ly: cy + Math.sin(rad) * labelR
                })
                angle += sweep
            }
        }
        renderedPointCount = slices.length
        geom.total = total
        geom.slices = slices
        rebuilt()
        if (canvasLoader.item)
            canvasLoader.item.requestPaint()
    }

    function _rad(deg) { return deg * Math.PI / 180 }

    function _updateProbeAtPos(px, py) {
        if (!showProbe || geom.slices.length < 1) {
            clearProbe()
            return
        }
        const dx = px - cx
        const dy = py - cy
        const dist = Math.sqrt(dx * dx + dy * dy)
        if (dist > outerR || dist < innerR * 0.85) {
            clearProbe()
            return
        }
        let deg = Math.atan2(dy, dx) * 180 / Math.PI
        let rel = deg - startAngle
        while (rel < 0) rel += 360
        while (rel >= 360) rel -= 360
        let acc = 0
        for (let i = 0; i < geom.slices.length; ++i) {
            const s = geom.slices[i]
            if (rel >= acc && rel < acc + s.sweep) {
                setProbe(s.index, s.lx, [{
                    label: s.label,
                    value: s.value,
                    color: s.color
                }, {
                    label: qsTr("%"),
                    value: s.percent,
                    color: s.color
                }], s.ly)
                (canvasLoader.item && canvasLoader.item.requestPaint())
                return
            }
            acc += s.sweep
        }
        clearProbe()
    }

    function _updateProbeAtPixel(px) {
        _updateProbeAtPos(px, height / 2)
    }

    function nudgeProbe(delta) {
        if (!showProbe || geom.slices.length < 1)
            return
        let idx = probeActive ? probeIndex : 0
        if (idx < 0)
            idx = 0
        idx = Math.min(geom.slices.length - 1, Math.max(0, idx + Math.round(delta)))
        const s = geom.slices[idx]
        if (!s)
            return
        setProbe(s.index, s.lx, [{
            label: s.label,
            value: s.value,
            color: s.color
        }, {
            label: qsTr("%"),
            value: s.percent,
            color: s.color
        }], s.ly)
        (canvasLoader.item && canvasLoader.item.requestPaint())
    }

    QtObject {
        id: geom
        property real total: 0
        property var slices: []
    }

    onInnerRatioChanged: requestRebuild()
    onStartAngleChanged: requestRebuild()
    onShowPercentLabelsChanged: requestRebuild()
    onLabelsChanged: requestRebuild()
    onProbeActiveChanged: (canvasLoader.item && canvasLoader.item.requestPaint())
    onProbeIndexChanged: (canvasLoader.item && canvasLoader.item.requestPaint())
    onCxChanged: (canvasLoader.item && canvasLoader.item.requestPaint())
    onCyChanged: (canvasLoader.item && canvasLoader.item.requestPaint())
    onOuterRChanged: (canvasLoader.item && canvasLoader.item.requestPaint())
    onInnerRChanged: (canvasLoader.item && canvasLoader.item.requestPaint())

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        radius: Md3Theme.shape.small
    }

        Loader {
        id: canvasLoader
        anchors.fill: parent
        active: root.chartActive
        sourceComponent: canvasComp
        onLoaded: if (item) item.requestPaint()
    }

    Component {
        id: canvasComp
    Canvas {
            id: canvas
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                const slices = geom.slices || []
                if (!slices.length)
                    return
                const cx = root.cx
                const cy = root.cy
                const outer = root.outerR
                const inner = root.innerR
                const probeOn = root.probeActive
                const probeIdx = root.probeIndex
                const donut = inner > 1

                for (let i = 0; i < slices.length; ++i) {
                    const s = slices[i]
                    if (!(s.sweep > 0) || !(outer > 0))
                        continue
                    const a0 = root._rad(s.start)
                    const a1 = root._rad(s.start + Math.max(0.01, s.sweep))
                    ctx.globalAlpha = probeOn && probeIdx !== s.index ? 0.45 : 1
                    ctx.fillStyle = s.color
                    ctx.strokeStyle = s.color
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    if (donut) {
                        ctx.arc(cx, cy, outer, a0, a1, false)
                        ctx.arc(cx, cy, inner, a1, a0, true)
                    } else {
                        ctx.moveTo(cx, cy)
                        ctx.arc(cx, cy, outer, a0, a1, false)
                    }
                    ctx.closePath()
                    ctx.fill()
                    ctx.stroke()
                }
                ctx.globalAlpha = 1
            }
        }    }


    // Donut hole (also covers canvas center for solid background when needed)
    Rectangle {
        visible: root.innerRatio > 0.02
        anchors.centerIn: parent
        width: root.innerR * 2
        height: width
        radius: width / 2
        color: root.backgroundColor.a > 0.01 ? root.backgroundColor
             : Md3Theme.colorScheme.surface
        z: 2
        Text {
            anchors.centerIn: parent
            visible: root.probeActive && root.probeSeries.length > 0
            text: root.probeSeries.length
                  ? (Number(root.probeSeries[0].value).toFixed(root.valueDecimals)
                     + root.yUnit)
                  : ""
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleSmall.size
            font.weight: Font.Medium
            font.family: Md3Theme.typography.fontFamily
        }
    }

    Repeater {
        model: root.showPercentLabels ? geom.slices : []
        delegate: Text {
            required property var modelData
            visible: modelData.sweep > 18
            x: modelData.lx - implicitWidth / 2
            y: modelData.ly - implicitHeight / 2
            z: 3
            text: modelData.percent.toFixed(0) + "%"
            color: Md3Theme.colorScheme.colorOnPrimary
            font.pixelSize: 11
            font.weight: Font.DemiBold
            font.family: Md3Theme.typography.fontFamily
            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, 0.35)
        }
    }

    Md3ChartInteraction {
        chart: root
        enableZoomPan: false
        usePlotMargins: false
        showCrosshair: false
    }
}

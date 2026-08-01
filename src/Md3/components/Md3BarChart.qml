import QtQuick
import Md3

/// Vertical / horizontal / stacked bar chart — zoom/pan/probe like Md3LineChart.
Md3Chart {
    id: root

    showArea: false
    showDots: false
    smooth: false
    property real barGap: 0.28
    property real barRadius: 4
    /// Grouped (side-by-side) vs stacked.
    property bool stacked: false
    /// Horizontal bars (categories on Y).
    property bool horizontal: false

    function rebuild() {
        const all = (series && series.length > 0) ? series : [values]
        const seriesCount = Math.max(1, all.length)
        const numsList = []
        let maxLen = 0
        for (let s = 0; s < seriesCount; ++s) {
            const nums = seriesNums(all[s] || [])
            numsList.push(nums)
            maxLen = Math.max(maxLen, nums.length)
        }

        let range
        if (stacked && maxLen > 0) {
            let lo = 0
            let hi = 0
            for (let i = 0; i < maxLen; ++i) {
                let sum = 0
                let neg = 0
                for (let s = 0; s < seriesCount; ++s) {
                    if (i >= numsList[s].length)
                        continue
                    const v = numsList[s][i]
                    if (v >= 0)
                        sum += v
                    else
                        neg += v
                }
                hi = Math.max(hi, sum)
                lo = Math.min(lo, neg)
            }
            if (!isNaN(minY))
                lo = minY
            if (!isNaN(maxY))
                hi = maxY
            if (hi <= lo) {
                lo -= 1
                hi += 1
            }
            const pad = (hi - lo) * 0.08
            range = { min: lo - pad, max: hi + pad }
        } else {
            range = rangeFromSeries(all.length ? all : [[0]])
        }

        const span = Math.max(1e-6, range.max - range.min)
        const win = windowIndices(Math.max(1, maxLen))
        const bars = []
        let rendered = 0
        const visibleCount = Math.max(1, win.i1 - win.i0 + 1)

        if (maxLen > 0) {
            if (!horizontal) {
                const groupW = plotWidth / visibleCount
                const inner = groupW * (1 - barGap)
                for (let ii = 0; ii < visibleCount; ++ii) {
                    const i = win.i0 + ii
                    if (i > win.i1)
                        break
                    if (stacked) {
                        let pos = 0
                        let neg = 0
                        for (let s = 0; s < seriesCount; ++s) {
                            if (i >= numsList[s].length)
                                continue
                            const v = numsList[s][i]
                            const yAt = val => plotTop + plotHeight * (1 - (val - range.min) / span)
                            let top
                            let bot
                            if (v >= 0) {
                                bot = yAt(pos)
                                pos += v
                                top = yAt(pos)
                            } else {
                                top = yAt(neg)
                                neg += v
                                bot = yAt(neg)
                            }
                            const x = plotLeft + ii * groupW + groupW * barGap * 0.5
                            bars.push({
                                x: x, y: Math.min(top, bot),
                                w: Math.max(1, inner),
                                h: Math.max(1, Math.abs(bot - top)),
                                color: colorAt(s),
                                index: i, series: s, value: v
                            })
                            rendered++
                        }
                    } else {
                        const barW = inner / seriesCount
                        const yAt = v => plotTop + plotHeight * (1 - (v - range.min) / span)
                        const y0 = yAt(Math.max(range.min, 0))
                        for (let s = 0; s < seriesCount; ++s) {
                            if (i >= numsList[s].length)
                                continue
                            const v = numsList[s][i]
                            const y = yAt(v)
                            const top = Math.min(y, y0)
                            const h = Math.max(1, Math.abs(y0 - y))
                            const x = plotLeft + ii * groupW + groupW * barGap * 0.5 + s * barW
                            bars.push({
                                x: x, y: top, w: Math.max(1, barW - 1), h: h,
                                color: colorAt(s), index: i, series: s, value: v
                            })
                            rendered++
                        }
                    }
                }
            } else {
                const groupH = plotHeight / visibleCount
                const inner = groupH * (1 - barGap)
                for (let ii = 0; ii < visibleCount; ++ii) {
                    const i = win.i0 + ii
                    if (i > win.i1)
                        break
                    if (stacked) {
                        let pos = 0
                        let neg = 0
                        for (let s = 0; s < seriesCount; ++s) {
                            if (i >= numsList[s].length)
                                continue
                            const v = numsList[s][i]
                            const xAt = val => plotLeft + plotWidth * ((val - range.min) / span)
                            let left
                            let right
                            if (v >= 0) {
                                left = xAt(pos)
                                pos += v
                                right = xAt(pos)
                            } else {
                                right = xAt(neg)
                                neg += v
                                left = xAt(neg)
                            }
                            const y = plotTop + ii * groupH + groupH * barGap * 0.5
                            bars.push({
                                x: Math.min(left, right), y: y,
                                w: Math.max(1, Math.abs(right - left)),
                                h: Math.max(1, inner),
                                color: colorAt(s), index: i, series: s, value: v
                            })
                            rendered++
                        }
                    } else {
                        const barH = inner / seriesCount
                        const xAt = v => plotLeft + plotWidth * ((v - range.min) / span)
                        const x0 = xAt(Math.max(range.min, 0))
                        for (let s = 0; s < seriesCount; ++s) {
                            if (i >= numsList[s].length)
                                continue
                            const v = numsList[s][i]
                            const x = xAt(v)
                            const left = Math.min(x, x0)
                            const w = Math.max(1, Math.abs(x0 - x))
                            const y = plotTop + ii * groupH + groupH * barGap * 0.5 + s * barH
                            bars.push({
                                x: left, y: y, w: w, h: Math.max(1, barH - 1),
                                color: colorAt(s), index: i, series: s, value: v
                            })
                            rendered++
                        }
                    }
                }
            }
        }

        renderedPointCount = rendered
        geom.rangeMin = range.min
        geom.rangeMax = range.max
        geom.span = span
        geom.bars = bars
        geom.numsList = numsList
        geom.sampleCount = maxLen
        geom.seriesCount = seriesCount
        rebuilt()
        if (probeActive)
            _updateProbeAtPixel(probePixelX)
    }

    function _updateProbeAtPixel(px) {
        if (!showProbe || geom.sampleCount < 1) {
            clearProbe()
            return
        }
        let idx
        if (horizontal) {
            const t = (probePixelY - plotTop) / Math.max(1, plotHeight)
            const win = windowIndices(geom.sampleCount)
            idx = Math.round(win.start + t * (win.end - win.start))
            idx = Math.min(geom.sampleCount - 1, Math.max(0, idx))
        } else {
            idx = indexAtPlotX(px, geom.sampleCount)
        }
        if (idx < 0) {
            clearProbe()
            return
        }
        const info = []
        for (let s = 0; s < geom.numsList.length; ++s) {
            const nums = geom.numsList[s]
            if (idx >= nums.length)
                continue
            info.push({
                label: qsTr("S%1").arg(s + 1),
                value: nums[idx],
                color: colorAt(s)
            })
        }
        const x = horizontal ? (plotLeft + plotWidth / 2) : plotXForIndex(idx, geom.sampleCount)
        const win = windowIndices(geom.sampleCount)
        const visibleCount = Math.max(1, win.i1 - win.i0 + 1)
        const ii = idx - win.i0
        const y = horizontal
                ? (plotTop + (ii + 0.5) * plotHeight / visibleCount)
                : (plotTop + plotHeight / 2)
        setProbe(idx, x, info, y)
    }

    function nudgeProbe(delta) {
        if (!showProbe || geom.sampleCount < 1)
            return
        let idx = probeActive ? probeIndex : 0
        if (idx < 0)
            idx = 0
        idx = Math.min(geom.sampleCount - 1, Math.max(0, idx + Math.round(delta)))
        if (horizontal) {
            const win = windowIndices(geom.sampleCount)
            const visibleCount = Math.max(1, win.i1 - win.i0 + 1)
            const ii = idx - win.i0
            const y = plotTop + (ii + 0.5) * plotHeight / visibleCount
            _updateProbeAtPos(plotLeft + plotWidth / 2, y)
        } else {
            _updateProbeAtPixel(plotXForIndex(idx, geom.sampleCount))
        }
    }

    function _updateProbeAtPos(px, py) {
        probePixelY = py
        _updateProbeAtPixel(px)
    }

    QtObject {
        id: geom
        property real rangeMin: 0
        property real rangeMax: 1
        property real span: 1
        property var bars: []
        property var numsList: []
        property int sampleCount: 0
        property int seriesCount: 1
    }

    onStackedChanged: requestRebuild()
    onHorizontalChanged: requestRebuild()
    onBarGapChanged: requestRebuild()

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        radius: Md3Theme.shape.small
    }

    Item {
        anchors.fill: parent
        clip: true

        Repeater {
            model: root.showGrid ? root.horizontalGridLines + 1 : 0
            delegate: Rectangle {
                required property int index
                readonly property real t: index / Math.max(1, root.horizontalGridLines)
                width: root.horizontal ? 1 : root.plotWidth
                height: root.horizontal ? root.plotHeight : 1
                x: root.horizontal
                   ? (root.plotLeft + root.plotWidth * t)
                   : root.plotLeft
                y: root.horizontal
                   ? root.plotTop
                   : (root.plotTop + root.plotHeight * (1 - t))
                color: root.resolvedGridColor()
                opacity: 0.45
            }
        }

        Repeater {
            model: geom.bars
            delegate: Rectangle {
                required property var modelData
                x: modelData.x
                y: modelData.y
                width: modelData.w
                height: modelData.h
                radius: Math.min(root.barRadius,
                                 Math.min(width, height) / 2)
                color: modelData.color
                opacity: root.probeActive && root.probeIndex === modelData.index ? 1 : 0.92
            }
        }
    }

    Repeater {
        model: root.showYLabels && !root.horizontal ? root.horizontalGridLines + 1 : 0
        delegate: Text {
            required property int index
            readonly property real t: index / Math.max(1, root.horizontalGridLines)
            readonly property real v: geom.rangeMin + geom.span * t
            x: 0
            y: root.plotTop + root.plotHeight * (1 - t) - 8
            width: root.plotLeft - 6
            height: 16
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            text: v.toFixed(root.valueDecimals) + root.yUnit
            color: root.resolvedAxisLabelColor()
            font.pixelSize: 11
            font.family: Md3Theme.typography.fontFamily
        }
    }

    Md3ChartInteraction {
        chart: root
    }
}

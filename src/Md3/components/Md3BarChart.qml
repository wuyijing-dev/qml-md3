import QtQuick

/// Vertical bar chart — extends Md3Chart.
Md3Chart {
    id: root

    showArea: false
    showDots: false
    smooth: false
    property real barGap: 0.28
    property real barRadius: 4

    function rebuild() {
        const all = (series && series.length > 0) ? series : [values]
        const range = rangeFromSeries(all.length ? all : [[0]])
        const span = Math.max(1e-6, range.max - range.min)
        const yAt = v => plotTop + plotHeight * (1 - (v - range.min) / span)
        const seriesCount = Math.max(1, all.length)
        let maxLen = 0
        const numsList = []
        for (let s = 0; s < seriesCount; ++s) {
            const nums = seriesNums(all[s] || [])
            numsList.push(nums)
            maxLen = Math.max(maxLen, nums.length)
        }
        const bars = []
        let rendered = 0
        if (maxLen > 0) {
            const groupW = plotWidth / maxLen
            const inner = groupW * (1 - barGap)
            const barW = inner / seriesCount
            for (let i = 0; i < maxLen; ++i) {
                for (let s = 0; s < seriesCount; ++s) {
                    const nums = numsList[s]
                    if (i >= nums.length)
                        continue
                    const v = nums[i]
                    const y = yAt(v)
                    const y0 = yAt(Math.max(range.min, 0))
                    const top = Math.min(y, y0)
                    const h = Math.max(1, Math.abs(y0 - y))
                    const x = plotLeft + i * groupW + groupW * barGap * 0.5 + s * barW
                    bars.push({
                        x: x,
                        y: top,
                        w: Math.max(1, barW - 1),
                        h: h,
                        color: colorAt(s)
                    })
                    rendered++
                }
            }
        }
        renderedPointCount = rendered
        geom.rangeMin = range.min
        geom.rangeMax = range.max
        geom.span = span
        geom.bars = bars
        rebuilt()
    }

    QtObject {
        id: geom
        property real rangeMin: 0
        property real rangeMax: 1
        property real span: 1
        property var bars: []
    }

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        radius: Md3Theme.shape.small
    }

    // Grid lines
    Repeater {
        model: root.showGrid ? root.horizontalGridLines + 1 : 0
        delegate: Rectangle {
            required property int index
            readonly property real t: index / Math.max(1, root.horizontalGridLines)
            width: root.plotWidth
            height: 1
            x: root.plotLeft
            y: root.plotTop + root.plotHeight * (1 - t)
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
            radius: Math.min(root.barRadius, width / 2)
            color: modelData.color
        }
    }

    Repeater {
        model: root.showYLabels ? root.horizontalGridLines + 1 : 0
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
}

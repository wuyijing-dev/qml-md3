import QtQuick
import QtQuick.Layouts
import Md3

/// Charts demo — hero chart sync; remaining cards via Md3DeferredSection (progressiveContent).
Item {
    id: root

    property Component kpiCard: Component {
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            implicitHeight: 620
            height: 620
            Column {
                width: parent.width
                spacing: 16
                Text {
                    text: qsTr("圆形表盘")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: Md3Theme.typography.titleSmall.size
                }
                Flow {
                    width: parent.width
                    spacing: 20
                    Md3Gauge {
                        value: 72
                        label: qsTr("Arc")
                        unit: "%"
                        size: 112
                    }
                    Md3RingGauge {
                        value: 64
                        label: qsTr("Ring")
                        unit: "%"
                        size: 112
                        valueColor: Md3Theme.colorScheme.tertiary
                    }
                    Md3NeedleGauge {
                        value: 55
                        label: qsTr("Needle")
                        unit: ""
                        size: 120
                    }
                    Md3SegmentGauge {
                        value: 8
                        from: 0
                        to: 12
                        segments: 12
                        label: qsTr("Segment")
                        unit: ""
                        decimals: 0
                        size: 112
                        valueColor: Md3Theme.colorScheme.secondary
                    }
                    Md3DotsGauge {
                        value: 70
                        label: qsTr("Dots")
                        unit: "%"
                        size: 112
                    }
                    Md3MultiRingGauge {
                        size: 132
                        minCenterRatio: 0.42
                        centerValue: "81%"
                        centerLabel: qsTr("Multi")
                        rings: [
                            { value: 81, color: Md3Theme.colorScheme.primary },
                            { value: 64, color: Md3Theme.colorScheme.tertiary },
                            { value: 42, color: Md3Theme.colorScheme.secondary }
                        ]
                    }
                    Md3HalfGauge {
                        value: 68
                        label: qsTr("Half")
                        unit: "%"
                        size: 130
                        valueColor: Md3Theme.colorScheme.tertiary
                    }
                    Md3WaveGauge {
                        value: 58
                        label: qsTr("Wave")
                        unit: "%"
                        size: 112
                    }
                    Md3TickRingGauge {
                        value: 76
                        label: qsTr("Ticks")
                        unit: "%"
                        size: 112
                        valueColor: Md3Theme.colorScheme.secondary
                    }
                    Md3ArcBandGauge {
                        value: 82
                        label: qsTr("Band")
                        unit: "%"
                        size: 112
                    }
                    Md3KnobGauge {
                        value: 45
                        label: qsTr("Knob")
                        size: 112
                        valueColor: Md3Theme.colorScheme.tertiary
                    }
                    Md3CompassGauge {
                        value: 42
                        label: qsTr("HDG")
                        size: 112
                    }
                }
                Row {
                    spacing: 16
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Requests / min")
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.pixelSize: Md3Theme.typography.labelLarge.size
                    }
                    Md3Sparkline {
                        width: 160
                        height: 40
                        showArea: true
                        showLastDot: true
                        values: [12, 18, 15, 22, 28, 24, 31, 27, 35, 40, 38, 42]
                    }
                }
            }
        }
    }

    property Component extraChartsCard: Component {
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            height: 560
            Column {
                width: parent.width
                spacing: 12
                Text {
                    text: qsTr("Radar · Funnel · Radial bars")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: Md3Theme.typography.titleSmall.size
                }
                Row {
                    width: parent.width
                    spacing: 12
                    Md3RadarChart {
                        width: Math.min(260, (parent.width - 24) / 3)
                        height: 220
                        categories: [qsTr("Speed"), qsTr("Reliability"), qsTr("UX"), qsTr("Docs"), qsTr("A11y"), qsTr("Perf")]
                        values: [80, 92, 75, 68, 88, 70]
                    }
                    Md3FunnelChart {
                        width: Math.min(260, (parent.width - 24) / 3)
                        height: 220
                        values: [
                            { label: qsTr("Visit"), value: 1200 },
                            { label: qsTr("Signup"), value: 640 },
                            { label: qsTr("Activate"), value: 310 },
                            { label: qsTr("Pay"), value: 120 }
                        ]
                    }
                    Md3RadialBarChart {
                        width: Math.min(260, (parent.width - 24) / 3)
                        height: 220
                        showLabels: true
                        values: [
                            { label: "A", value: 86 },
                            { label: "B", value: 64 },
                            { label: "C", value: 48 },
                            { label: "D", value: 32 }
                        ]
                    }
                }
                Text {
                    text: qsTr("Area · Waterfall · Bullet")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: Md3Theme.typography.titleSmall.size
                }
                Row {
                    width: parent.width
                    spacing: 12
                    Md3AreaChart {
                        width: Math.min(300, (parent.width - 24) / 2)
                        height: 160
                        stacked: true
                        values: [
                            [12, 18, 15, 22, 28, 24, 31],
                            [8, 10, 12, 9, 14, 11, 16]
                        ]
                    }
                    Md3WaterfallChart {
                        width: Math.min(300, (parent.width - 24) / 2)
                        height: 160
                        values: [
                            { label: qsTr("Start"), value: 100 },
                            { label: qsTr("+Sales"), value: 40 },
                            { label: qsTr("-Cost"), value: -25 },
                            { label: qsTr("+Other"), value: 15 },
                            { label: qsTr("End"), value: 130, isTotal: true }
                        ]
                    }
                }
                Md3BulletChart {
                    width: parent.width
                    label: qsTr("Revenue vs target")
                    unit: "k"
                    value: 72
                    comparative: 80
                    to: 100
                    ranges: [50, 75, 100]
                }
                Md3BulletChart {
                    width: parent.width
                    label: qsTr("Satisfaction")
                    value: 88
                    comparative: 85
                    to: 100
                    ranges: [60, 80, 100]
                }
            }
        }
    }

    property Component heatCard: Component {
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            height: 220
            Column {
                width: parent.width
                spacing: 8
                Text {
                    text: qsTr("Contribution heatmap (GitHub)")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: Md3Theme.typography.titleSmall.size
                }
                Md3HeatmapChart {
                    width: parent.width
                    style: Md3HeatmapChart.Contribution
                    weeks: 53
                    cellSize: 11
                    cellGap: 3
                    cellRadius: 2
                    values: {
                        const rows = []
                        for (let i = 0; i < 53 * 7; ++i) {
                            const w = i % 7
                            const week = Math.floor(i / 7)
                            let n = 0
                            if ((week + w) % 5 === 0)
                                n = 1 + (i % 4)
                            if ((week * 3 + w) % 11 === 0)
                                n = 3 + (i % 2)
                            if (i % 29 === 0)
                                n = 4
                            rows.push(n)
                        }
                        return rows
                    }
                }
            }
        }
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.height
        clip: true
        // Pull deferred sections in early when user scrolls
        onContentYChanged: {
            if (contentY > 40) {
                stage1.arm()
                stage1b.arm()
            }
                if (contentY > 180) {
                stage2a.arm()
                stage2b.arm()
                stage2c.arm()
                stage2d.arm()
                stage2e.arm()
                stage2f.arm()
                stage2g.arm()
                stage2h.arm()
            }
        }

        ColumnLayout {
            id: column
            width: root.width
            spacing: 16

            Text {
                text: qsTr("Charts")
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.headlineMedium.size
            }
            Text {
                Layout.fillWidth: true
                text: qsTr("折线/柱/散点/饼 · 缩放平移探针 · Md3CodeBlock")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodyMedium.size
                wrapMode: Text.Wrap
            }

            // Shell-first: title shows immediately; live chart + toolbar incubate next frames.
            Md3DeferredSection {
                Layout.fillWidth: true
                preferredHeight: 280
                delayMs: 0
                asynchronous: true
                sourceComponent: heroLiveBlock
            }

            Md3DeferredSection {
                id: stage1
                Layout.fillWidth: true
                preferredHeight: 280
                delayMs: 1
                asynchronous: true
                sourceComponent: multiCard
            }
            Md3DeferredSection {
                id: stage1b
                preferredHeight: 260
                delayMs: 1
                asynchronous: true
                sourceComponent: barCard
            }
            Md3DeferredSection {
                id: stage2a
                preferredHeight: 240
                delayMs: 48
                asynchronous: true
                sourceComponent: bigCard
            }
            Md3DeferredSection {
                id: stage2b
                preferredHeight: 200
                delayMs: 48
                asynchronous: true
                sourceComponent: sparseCard
            }
            Md3DeferredSection {
                id: stage2c
                preferredHeight: 240
                delayMs: 64
                asynchronous: true
                sourceComponent: scatterCard
            }
            Md3DeferredSection {
                id: stage2d
                preferredHeight: 240
                delayMs: 64
                asynchronous: true
                sourceComponent: pieCard
            }
            Md3DeferredSection {
                id: stage2e
                preferredHeight: 320
                delayMs: 80
                asynchronous: true
                sourceComponent: codeCard
            }
            Md3DeferredSection {
                id: stage2f
                preferredHeight: 620
                delayMs: 96
                asynchronous: true
                sourceComponent: root.kpiCard
            }
            Md3DeferredSection {
                id: stage2g
                preferredHeight: 220
                delayMs: 112
                asynchronous: true
                sourceComponent: root.heatCard
            }
            Md3DeferredSection {
                id: stage2h
                preferredHeight: 560
                delayMs: 128
                asynchronous: true
                sourceComponent: root.extraChartsCard
            }
        }
    }

    function _demoSeriesA() {
        const a = []
        for (let i = 0; i < 160; ++i)
            a.push(42 + Math.sin(i * 0.14) * 22 + Math.sin(i * 0.03) * 8)
        return a
    }
    function _demoSeriesB() {
        const b = []
        for (let i = 0; i < 160; ++i)
            b.push(28 + Math.cos(i * 0.11) * 16 + i * 0.02)
        return b
    }

    Component {
        id: heroLiveBlock
        Column {
            width: root.width
            spacing: 16
            Flow {
                width: parent.width
                spacing: 8
                Md3Button {
                    text: liveChart.item && liveChart.item.paused ? qsTr("继续") : qsTr("暂停")
                    variant: Md3Button.FilledTonal
                    enabled: !!(liveChart.item)
                    onClicked: {
                        if (!liveChart.item)
                            return
                        liveChart.item.paused ? liveChart.item.resume() : liveChart.item.pause()
                    }
                }
                Md3Button {
                    text: qsTr("面积")
                    variant: liveChart.item && liveChart.item.showArea ? Md3Button.Filled : Md3Button.Outlined
                    enabled: !!(liveChart.item)
                    onClicked: if (liveChart.item) liveChart.item.showArea = !liveChart.item.showArea
                }
                Md3Button {
                    text: qsTr("面积强调")
                    variant: liveChart.item && liveChart.item.areaEmphasis ? Md3Button.Filled : Md3Button.Outlined
                    enabled: !!(liveChart.item)
                    onClicked: if (liveChart.item) liveChart.item.areaEmphasis = !liveChart.item.areaEmphasis
                }
                Md3Button {
                    text: qsTr("网格")
                    variant: liveChart.item && liveChart.item.showGrid ? Md3Button.Filled : Md3Button.Outlined
                    enabled: !!(liveChart.item)
                    onClicked: if (liveChart.item) liveChart.item.showGrid = !liveChart.item.showGrid
                }
                Md3Button {
                    text: qsTr("平滑")
                    variant: liveChart.item && liveChart.item.smooth ? Md3Button.Filled : Md3Button.Outlined
                    enabled: !!(liveChart.item)
                    onClicked: if (liveChart.item) liveChart.item.smooth = !liveChart.item.smooth
                }
                Md3Button {
                    text: qsTr("适配 Y")
                    variant: Md3Button.Outlined
                    enabled: !!(liveChart.item)
                    onClicked: {
                        if (!liveChart.item)
                            return
                        liveChart.item.minY = Number.NaN
                        liveChart.item.maxY = Number.NaN
                        liveChart.item.fitY()
                    }
                }
                Md3Button {
                    text: qsTr("固定 0–100")
                    variant: Md3Button.Outlined
                    enabled: !!(liveChart.item)
                    onClicked: {
                        if (!liveChart.item)
                            return
                        liveChart.item.minY = 0
                        liveChart.item.maxY = 100
                    }
                }
            }
            Md3Card {
                variant: Md3Card.Filled
                width: parent.width
                implicitHeight: 220
                height: 220
                title: qsTr("Live sine (Md3LineChart)")
                Loader {
                    id: liveChart
                    width: parent.width
                    height: 160
                    active: true
                    asynchronous: true
                    sourceComponent: Component {
                        Md3LineChart {
                            live: true
                            paused: true
                            livePointCount: 32
                            showDots: false
                            showArea: true
                            showProbe: true
                            smooth: false
                            minY: 0
                            maxY: 100
                            horizontalGridLines: 4
                            Component.onCompleted: liveArm.start()
                            Timer {
                                id: liveArm
                                interval: 32
                                onTriggered: parent.paused = false
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: multiCard
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            height: 280
            title: qsTr("Zoom / pan / probe (wheel · drag · hover)")
            subtitle: qsTr("滚轮缩放 · 拖动平移（带惯性）· 悬停探针 · 双击重置。interactive/showProbe 默认开启。")
            actions: [{ text: qsTr("重置视图"), variant: "outlined" }]
            onActionClicked: interactChart.resetView()
            Md3LineChart {
                id: interactChart
                width: parent.width
                height: 200
                valueDecimals: 1
                series: [root._demoSeriesA(), root._demoSeriesB()]
                seriesColors: [
                    Md3Theme.colorScheme.primary,
                    Md3Theme.colorScheme.secondary
                ]
                showDots: false
                showArea: true
                smooth: true
                horizontalGridLines: 4
            }
        }
    }

    Component {
        id: barCard
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            height: 260
            Column {
                width: parent.width
                spacing: 8
                RowLayout {
                    width: parent.width
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Bar · stack / horizontal · zoom+probe")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.titleSmall.size
                    }
                    Md3Button {
                        text: barChart.stacked ? qsTr("分组") : qsTr("堆叠")
                        variant: Md3Button.Outlined
                        onClicked: barChart.stacked = !barChart.stacked
                    }
                    Md3Button {
                        text: barChart.horizontal ? qsTr("纵向") : qsTr("横向")
                        variant: Md3Button.Outlined
                        onClicked: barChart.horizontal = !barChart.horizontal
                    }
                    Md3Button {
                        text: qsTr("重置")
                        variant: Md3Button.Text
                        onClicked: barChart.resetView()
                    }
                }
                Md3BarChart {
                    id: barChart
                    width: parent.width
                    height: 190
                    valueDecimals: 0
                    labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                    series: [
                        [12, 18, 15, 28, 24, 36, 32],
                        [8, 14, 20, 16, 22, 18, 26]
                    ]
                    seriesColors: [
                        Md3Theme.colorScheme.primary,
                        Md3Theme.colorScheme.tertiary
                    ]
                    horizontalGridLines: 4
                    showYLabels: true
                }
            }
        }
    }

    Component {
        id: bigCard
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            height: 240
            Column {
                width: parent.width
                spacing: 8
                RowLayout {
                    width: parent.width
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Large series (Md3ChartData → line)")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.titleSmall.size
                    }
                    Md3Button {
                        text: qsTr("清除")
                        variant: Md3Button.Outlined
                        onClicked: {
                            bigData.clear()
                            bigChart.clear()
                        }
                    }
                    Md3Button {
                        text: bigData.rawCount >= 1000000 ? qsTr("1M pts") : qsTr("生成 100万点")
                        variant: Md3Button.Outlined
                        onClicked: {
                            bigData.targetPoints = Math.max(64, Math.floor(bigChart.width * 2.5))
                            bigData.fillSine(1000000)
                        }
                    }
                }
                Text {
                    width: parent.width
                    visible: bigData.rawCount > 0
                    text: qsTr("原始 %1 → 绘制 %2")
                          .arg(bigData.rawCount)
                          .arg(bigData.pointCount)
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
                Md3ChartData { id: bigData }
                Md3LineChart {
                    id: bigChart
                    width: parent.width
                    height: 160
                    values: bigData.points
                    smooth: false
                    showDots: false
                    showArea: true
                    interactive: true
                    showProbe: true
                    valueDecimals: 2
                    horizontalGridLines: 4
                    onWidthChanged: {
                        if (bigData.rawCount > 0)
                            bigData.targetPoints = Math.max(64, Math.floor(width * 2.5))
                    }
                }
            }
        }
    }

    Component {
        id: sparseCard
        Md3Card {
            variant: Md3Card.Elevated
            width: root.width
            height: 200
            Column {
                width: parent.width
                spacing: 8
                Text {
                    text: qsTr("Sparse line (smooth off)")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: Md3Theme.typography.titleSmall.size
                }
                Md3LineChart {
                    width: parent.width
                    height: 140
                    values: [4, 9, 6, 14, 11, 18, 16, 22]
                    smooth: false
                    showDots: true
                    showProbe: true
                    interactive: true
                    valueDecimals: 0
                    lineColor: Md3Theme.colorScheme.tertiary
                    fillColor: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.tertiary, 0.22)
                    horizontalGridLines: 3
                }
            }
        }
    }

    Component {
        id: scatterCard
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            height: 240
            Column {
                width: parent.width
                spacing: 8
                RowLayout {
                    width: parent.width
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Scatter (Md3ScatterChart)")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.titleSmall.size
                    }
                    Md3Button {
                        text: qsTr("重置")
                        variant: Md3Button.Outlined
                        onClicked: scatter.resetView()
                    }
                }
                Md3ScatterChart {
                    id: scatter
                    width: parent.width
                    height: 180
                    interactive: true
                    showProbe: true
                    valueDecimals: 1
                    series: [
                        [12, 18, 9, 28, 22, 36, 30, 40, 25, 48, 33, 20],
                        [8, 14, 20, 11, 26, 18, 32, 24, 38, 16, 28, 22]
                    ]
                    pointRadius: 5
                    horizontalGridLines: 4
                }
            }
        }
    }

    Component {
        id: pieCard
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            height: 240
            Column {
                width: parent.width
                spacing: 8
                RowLayout {
                    width: parent.width
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Pie / Donut (Md3PieChart)")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.titleSmall.size
                    }
                    Md3Button {
                        text: pie.innerRatio > 0.1 ? qsTr("饼图") : qsTr("环图")
                        variant: Md3Button.Outlined
                        onClicked: pie.innerRatio = pie.innerRatio > 0.1 ? 0 : 0.58
                    }
                }
                Md3PieChart {
                    id: pie
                    width: parent.width
                    height: 180
                    showProbe: true
                    valueDecimals: 0
                    yUnit: ""
                    labels: [qsTr("A"), qsTr("B"), qsTr("C"), qsTr("D"), qsTr("E")]
                    values: [32, 24, 18, 14, 12]
                    innerRatio: 0.58
                }
            }
        }
    }

    Component {
        id: codeCard
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            height: 320
            Column {
                width: parent.width
                spacing: 8
                Text {
                    text: qsTr("Code (Md3CodeBlock)")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: Md3Theme.typography.titleSmall.size
                }
                Md3CodeBlock {
                    width: parent.width
                    height: 260
                    language: "qml"
                    showLineNumbers: true
                    code: "Md3BarChart {
    interactive: true
    showProbe: true
    stacked: true
    labels: [\"Mon\", \"Tue\", \"Wed\"]
    series: [[12, 18, 15], [8, 14, 20]]
}
Md3ScatterChart { interactive: true; showProbe: true; values: [...] }
Md3PieChart { innerRatio: 0.55; labels: [\"A\",\"B\"]; values: [40, 60] }"
                }
            }
        }
    }
}

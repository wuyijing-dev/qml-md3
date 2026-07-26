import QtQuick
import QtQuick.Layouts
import Md3

/// Progressive charts demo — first card sync, rest deferred so navigation stays snappy.
Item {
    id: root

    /// 0 = live only, 1 = multi+bar, 2 = big+sparse
    property int deferStage: 0

    Timer {
        id: defer1
        interval: 1
        running: true
        onTriggered: root.deferStage = Math.max(root.deferStage, 1)
    }
    Timer {
        id: defer2
        interval: 48
        running: true
        onTriggered: root.deferStage = Math.max(root.deferStage, 2)
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.height
        clip: true
        // Pull in remaining cards early when user scrolls
        onContentYChanged: {
            if (contentY > 40)
                root.deferStage = Math.max(root.deferStage, 1)
            if (contentY > 180)
                root.deferStage = Math.max(root.deferStage, 2)
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

            Flow {
                Layout.fillWidth: true
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

            // Hero live chart — sync, starts paused for one frame then runs
            Md3Card {
                variant: Md3Card.Filled
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                Column {
                    width: parent.width
                    spacing: 8
                    Text {
                        text: qsTr("Live sine (Md3LineChart)")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.titleSmall.size
                    }
                    Loader {
                        id: liveChart
                        width: parent.width
                        height: 160
                        active: true
                        asynchronous: false
                        sourceComponent: Component {
                            Md3LineChart {
                                live: true
                                paused: true
                                livePointCount: 48
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

            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: active && status === Loader.Ready ? 280 : (active ? 280 : 0)
                active: root.deferStage >= 1
                asynchronous: true
                visible: status === Loader.Ready || active
                opacity: status === Loader.Ready ? 1 : 0.35
                sourceComponent: multiCard
            }

            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: active && status === Loader.Ready ? 260 : (active ? 260 : 0)
                active: root.deferStage >= 1
                asynchronous: true
                visible: status === Loader.Ready || active
                opacity: status === Loader.Ready ? 1 : 0.35
                sourceComponent: barCard
            }

            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: active && status === Loader.Ready ? 240 : (active ? 240 : 0)
                active: root.deferStage >= 2
                asynchronous: true
                visible: status === Loader.Ready || active
                opacity: status === Loader.Ready ? 1 : 0.35
                sourceComponent: bigCard
            }

            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: active && status === Loader.Ready ? 200 : (active ? 200 : 0)
                active: root.deferStage >= 2
                asynchronous: true
                visible: status === Loader.Ready || active
                opacity: status === Loader.Ready ? 1 : 0.35
                sourceComponent: sparseCard
            }

            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: active && status === Loader.Ready ? 240 : (active ? 240 : 0)
                active: root.deferStage >= 2
                asynchronous: true
                visible: status === Loader.Ready || active
                opacity: status === Loader.Ready ? 1 : 0.35
                sourceComponent: scatterCard
            }

            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: active && status === Loader.Ready ? 240 : (active ? 240 : 0)
                active: root.deferStage >= 2
                asynchronous: true
                visible: status === Loader.Ready || active
                opacity: status === Loader.Ready ? 1 : 0.35
                sourceComponent: pieCard
            }

            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: active && status === Loader.Ready ? 320 : (active ? 320 : 0)
                active: root.deferStage >= 2
                asynchronous: true
                visible: status === Loader.Ready || active
                opacity: status === Loader.Ready ? 1 : 0.35
                sourceComponent: codeCard
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
        id: multiCard
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            height: 280
            Column {
                width: parent.width
                spacing: 8
                RowLayout {
                    width: parent.width
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Zoom / pan / probe (wheel · drag · hover)")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.titleSmall.size
                    }
                    Md3Button {
                        text: qsTr("重置视图")
                        variant: Md3Button.Outlined
                        onClicked: interactChart.resetView()
                    }
                }
                Text {
                    width: parent.width
                    text: qsTr("滚轮缩放 · 拖动平移（带惯性）· 悬停探针 · 双击重置。interactive/showProbe 默认开启。")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                    wrapMode: Text.Wrap
                }
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

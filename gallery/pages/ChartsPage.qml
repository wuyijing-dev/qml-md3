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
                text: qsTr("Md3Chart 基类：pause/resume/clear/fitY。主题 reveal：圆内为新主题实时内容，圆外为旧主题快照。")
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
                                // Live path skips Catmull; toggle still available for static feel demos
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
                Layout.preferredHeight: active && status === Loader.Ready ? 220 : (active ? 220 : 0)
                active: root.deferStage >= 1
                asynchronous: true
                visible: status === Loader.Ready || active
                opacity: status === Loader.Ready ? 1 : 0.35
                sourceComponent: multiCard
            }

            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: active && status === Loader.Ready ? 220 : (active ? 220 : 0)
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
        }
    }

    Component {
        id: multiCard
        Md3Card {
            variant: Md3Card.Outlined
            width: root.width
            height: 220
            Column {
                width: parent.width
                spacing: 8
                Text {
                    text: qsTr("Multi-series line")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: Md3Theme.typography.titleSmall.size
                }
                Md3LineChart {
                    width: parent.width
                    height: 160
                    series: [
                        [12, 18, 15, 28, 24, 36, 32, 40, 38, 48],
                        [8, 14, 20, 16, 22, 18, 26, 30, 28, 34]
                    ]
                    seriesColors: [
                        Md3Theme.colorScheme.primary,
                        Md3Theme.colorScheme.secondary
                    ]
                    showDots: true
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
            height: 220
            Column {
                width: parent.width
                spacing: 8
                RowLayout {
                    width: parent.width
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Bar chart (Md3BarChart)")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.titleSmall.size
                    }
                    Md3Button {
                        text: qsTr("清空")
                        variant: Md3Button.Outlined
                        onClicked: barChart.clear()
                    }
                    Md3Button {
                        text: qsTr("示例数据")
                        variant: Md3Button.FilledTonal
                        onClicked: {
                            barChart.series = [
                                [12, 18, 15, 28, 24, 36, 32],
                                [8, 14, 20, 16, 22, 18, 26]
                            ]
                            barChart.seriesColors = [
                                Md3Theme.colorScheme.primary,
                                Md3Theme.colorScheme.tertiary
                            ]
                        }
                    }
                }
                Md3BarChart {
                    id: barChart
                    width: parent.width
                    height: 150
                    values: [12, 18, 15, 28, 24, 36, 32, 40]
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
                    lineColor: Md3Theme.colorScheme.tertiary
                    fillColor: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.tertiary, 0.22)
                    horizontalGridLines: 3
                }
            }
        }
    }
}

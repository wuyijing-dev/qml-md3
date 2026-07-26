import QtQuick
import QtQuick.Layouts
import Md3

Item {
    id: root

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.height
        clip: true

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
                text: qsTr("QML Shapes 描边（圆角接合）+ Md3ChartData C++ 降采样。百万点先在 C++ 生成/压缩，再交给 Shape 绘制。")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodyMedium.size
                wrapMode: Text.Wrap
            }

            Md3Card {
                variant: Md3Card.Filled
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                Column {
                    width: parent.width
                    spacing: 8
                    Text {
                        text: qsTr("Live sine (animated)")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.titleSmall.size
                    }
                    Md3LineChart {
                        width: parent.width
                        height: 160
                        live: root.visible
                        livePointCount: 48
                        showDots: false
                        showArea: true
                        smooth: true
                        minY: 0
                        maxY: 100
                        horizontalGridLines: 4
                    }
                }
            }

            Md3Card {
                variant: Md3Card.Outlined
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                Column {
                    width: parent.width
                    spacing: 8
                    Text {
                        text: qsTr("Multi-series")
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

            Md3Card {
                variant: Md3Card.Outlined
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                Column {
                    width: parent.width
                    spacing: 8
                    RowLayout {
                        width: parent.width
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Large series (C++ downsample → Shapes)")
                            color: Md3Theme.colorScheme.colorOnSurface
                            font.pixelSize: Md3Theme.typography.titleSmall.size
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
                        text: qsTr("原始 %1 点 → 绘制 %2 点（Shapes）")
                              .arg(bigData.rawCount)
                              .arg(bigData.pointCount)
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.pixelSize: Md3Theme.typography.bodySmall.size
                        wrapMode: Text.Wrap
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
                            if (bigData.rawCount > 0) {
                                bigData.targetPoints = Math.max(64, Math.floor(width * 2.5))
                            }
                        }
                    }
                }
            }

            Md3Card {
                variant: Md3Card.Elevated
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                Column {
                    width: parent.width
                    spacing: 8
                    Text {
                        text: qsTr("Sparse / stepped look (smooth off)")
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
}

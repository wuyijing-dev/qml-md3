import QtQuick
import QtQuick.Layouts
import Md3

Item {
    id: root

    property real phase: 0
    readonly property var liveValues: {
        const p = root.phase
        const out = []
        for (let i = 0; i < 40; ++i) {
            const t = p + i * 0.22
            out.push(50 + Math.sin(t) * 28 + Math.sin(t * 0.37) * 12)
        }
        return out
    }

    Timer {
        interval: 32
        running: root.visible
        repeat: true
        onTriggered: root.phase += 0.08
    }

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
                text: qsTr("MD3 line charts (Flutter / fl_chart style): smooth curves, area fill, grid.")
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
                        values: root.liveValues
                        showDots: false
                        showArea: true
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
                        horizontalGridLines: 4
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
                        fillColor: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.tertiary, 0.2)
                        horizontalGridLines: 3
                    }
                }
            }
        }
    }
}

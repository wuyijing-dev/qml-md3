import QtQuick
import Md3

/// Gallery-only floating HUD (not an Md3 library component).
Item {
    id: root

    property var monitor: null
    property bool compact: false
    property bool expanded: true

    width: expanded ? 288 : 136
    // Size to content — avoid clipping the chart / metrics grid
    height: Math.ceil(chrome.implicitHeight)

    Md3Card {
        id: chrome
        width: parent.width
        height: implicitHeight
        variant: Md3Card.Elevated
        padding: 12

        Column {
            id: body
            width: parent.width
            spacing: 8

            Row {
                width: parent.width
                spacing: 8

                Md3Icon {
                    anchors.verticalCenter: parent.verticalCenter
                    icon: "speed"
                    size: 18
                    iconColor: Md3Theme.colorScheme.primary
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Performance")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.titleSmall.size
                    font.weight: Font.Medium
                    width: parent.width - 72
                    elide: Text.ElideRight
                }
                Md3TitleBarButton {
                    buttonWidth: 28
                    buttonHeight: 28
                    iconSize: 14
                    icon: root.expanded ? "unfold_less" : "unfold_more"
                    accessibleName: root.expanded ? qsTr("Collapse") : qsTr("Expand")
                    onClicked: root.expanded = !root.expanded
                }
            }

            Grid {
                visible: root.expanded
                width: parent.width
                columns: 2
                columnSpacing: 12
                rowSpacing: 4

                Text {
                    text: qsTr("FPS")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 11
                }
                Text {
                    text: root.monitor ? root.monitor.fps.toFixed(1) : "—"
                    color: Md3Theme.colorScheme.primary
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }

                Text {
                    text: qsTr("Frame")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 11
                }
                Text {
                    text: root.monitor ? (root.monitor.frameTimeMs.toFixed(2) + " ms") : "—"
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }

                Text {
                    text: qsTr("CPU")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 11
                }
                Text {
                    text: root.monitor ? (root.monitor.cpuPercent.toFixed(1) + "%") : "—"
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }

                Text {
                    text: qsTr("Memory")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 11
                }
                Text {
                    text: root.monitor
                          ? (root.monitor.workingSetMb.toFixed(1) + " MB")
                          : "—"
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }
            }

            Md3LineChart {
                visible: root.expanded
                width: parent.width
                height: root.compact ? 64 : 88
                values: (root.expanded && root.monitor) ? root.monitor.fpsHistory : []
                minY: 0
                maxY: 120
                showYLabels: true
                showArea: false
                showDots: false
                smooth: false
                lineWidth: 2
                horizontalGridLines: 2
                valueDecimals: 0
                labelWidth: 28
                contentPadding: 4
            }

            Md3LineChart {
                visible: root.expanded && !root.compact
                width: parent.width
                height: 56
                values: (root.expanded && !root.compact && root.monitor)
                        ? root.monitor.memoryHistory : []
                showYLabels: true
                showArea: false
                showDots: false
                smooth: false
                lineWidth: 2
                horizontalGridLines: 2
                valueDecimals: 0
                labelWidth: 28
                contentPadding: 4
                lineColor: Md3Theme.colorScheme.tertiary
                seriesColors: [Md3Theme.colorScheme.tertiary]
            }
        }
    }
}

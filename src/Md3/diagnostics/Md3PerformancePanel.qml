import QtQuick

/// Performance HUD content. Host may dock it or open a separate dialog.
Item {
    id: root

    property var monitor: null
    property bool compact: true
    property bool expanded: true
    property bool picking: false
    property var selectedInfo: ({})
    /// When true, show "dock" affordance; when false, show "pop out".
    property bool detached: false
    property bool fillHeight: false

    readonly property bool isLinux: !!(monitor && monitor.platformId === "linux")
    readonly property bool isWindows: !!(monitor && monitor.platformId === "windows")
    readonly property bool gpuOk: !!(monitor && monitor.gpuAvailable && monitor.gpuPercent >= 0)

    signal pickToggleRequested()
    signal detachRequested()
    signal dockRequested()

    width: expanded ? 336 : 148
    height: fillHeight ? parent ? parent.height : chrome.implicitHeight
                       : Math.ceil(chrome.implicitHeight)

    Md3Card {
        id: chrome
        width: parent.width
        height: root.fillHeight ? parent.height : implicitHeight
        variant: Md3Card.Elevated
        padding: 12

        Column {
            width: parent.width
            spacing: 8

            Row {
                width: parent.width
                spacing: 4

                Md3Icon {
                    anchors.verticalCenter: parent.verticalCenter
                    icon: "speed"
                    size: 18
                    iconColor: Md3Theme.colorScheme.primary
                }
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 132
                    spacing: 0
                    Text {
                        width: parent.width
                        text: qsTr("Performance")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.titleSmall.size
                        font.weight: Font.Medium
                        elide: Text.ElideRight
                    }
                    Text {
                        visible: root.expanded && !!(root.monitor)
                        width: parent.width
                        text: {
                            if (!root.monitor)
                                return ""
                            const plat = root.monitor.platformLabel || ""
                            const api = root.monitor.graphicsApi || ""
                            return api && api !== "—" ? (plat + " · " + api) : plat
                        }
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.pixelSize: 10
                        elide: Text.ElideRight
                    }
                }
                Md3TitleBarButton {
                    buttonWidth: 28
                    buttonHeight: 28
                    iconSize: 14
                    icon: "near_me"
                    checked: root.picking
                    accessibleName: qsTr("Select element")
                    onClicked: root.pickToggleRequested()
                }
                Md3TitleBarButton {
                    buttonWidth: 28
                    buttonHeight: 28
                    iconSize: 14
                    icon: root.detached ? "close_fullscreen" : "open_in_new"
                    accessibleName: root.detached ? qsTr("Dock panel") : qsTr("Open as window")
                    onClicked: root.detached ? root.dockRequested() : root.detachRequested()
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
                    text: qsTr("GPU")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 11
                }
                Text {
                    text: root.gpuOk
                          ? (root.monitor.gpuPercent.toFixed(1) + "%")
                          : qsTr("n/a")
                    color: root.gpuOk
                           ? Md3Theme.colorScheme.colorOnSurface
                           : Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }

                Text {
                    visible: !!(root.monitor && root.monitor.gpuMemoryMb >= 0)
                    text: qsTr("GPU mem")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 11
                }
                Text {
                    visible: !!(root.monitor && root.monitor.gpuMemoryMb >= 0)
                    text: root.monitor
                          ? (root.monitor.gpuMemoryMb.toFixed(1) + " MB")
                          : "—"
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }

                Text {
                    text: root.monitor && root.monitor.memoryLabel
                          ? root.monitor.memoryLabel
                          : qsTr("Memory")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 11
                }
                Text {
                    text: root.monitor
                          ? (root.monitor.memoryMb.toFixed(1) + " MB")
                          : "—"
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }

                // Windows: show Private Bytes (commit) as secondary — often ~2× Task Manager.
                Text {
                    visible: root.isWindows
                    text: qsTr("Private bytes")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 10
                }
                Text {
                    visible: root.isWindows
                    text: root.monitor
                          ? (root.monitor.privateBytesMb.toFixed(1) + " MB")
                          : "—"
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }

                Text {
                    visible: root.isWindows
                    text: qsTr("Working set")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 10
                }
                Text {
                    visible: root.isWindows
                    text: root.monitor
                          ? (root.monitor.workingSetMb.toFixed(1) + " MB")
                          : "—"
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }

                // Linux: RSS is primary; show PSS + Private for System Monitor comparison.
                Text {
                    visible: root.isLinux
                    text: qsTr("PSS")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 10
                }
                Text {
                    visible: root.isLinux
                    text: root.monitor
                          ? (root.monitor.privateWorkingSetMb.toFixed(1) + " MB")
                          : "—"
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }

                Text {
                    visible: root.isLinux
                    text: qsTr("Private")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 10
                }
                Text {
                    visible: root.isLinux
                    text: root.monitor
                          ? (root.monitor.privateBytesMb.toFixed(1) + " MB")
                          : "—"
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignRight
                    width: parent.width / 2 - 6
                }
            }

            Md3Sparkline {
                visible: root.expanded
                width: parent.width
                height: 48
                values: (root.expanded && root.monitor) ? root.monitor.fpsHistory : []
                minY: 0
                maxY: 120
                stroke: Md3Theme.colorScheme.primary
            }

            Md3Sparkline {
                visible: root.expanded && root.gpuOk
                width: parent.width
                height: 36
                values: (root.expanded && root.monitor) ? root.monitor.gpuHistory : []
                minY: 0
                maxY: 100
                stroke: Md3Theme.colorScheme.secondary
            }

            Md3Sparkline {
                visible: root.expanded && !root.compact
                width: parent.width
                height: 36
                values: (root.expanded && !root.compact && root.monitor)
                        ? root.monitor.memoryHistory : []
                stroke: Md3Theme.colorScheme.tertiary
            }

            Column {
                visible: root.expanded && !!(root.selectedInfo && root.selectedInfo.typeName)
                width: parent.width
                spacing: 4

                Text {
                    text: qsTr("选中组件")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 11
                }
                Text {
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: {
                        const i = root.selectedInfo || {}
                        const name = i.objectName
                                      ? (i.typeName + "  #" + i.objectName)
                                      : (i.typeName || "")
                        const size = (i.width !== undefined)
                                     ? ("\n" + Math.round(i.width) + " × " + Math.round(i.height)
                                        + "  children " + (i.childCount || 0))
                                     : ""
                        const parentType = i.parentType ? ("\nparent " + i.parentType) : ""
                        return name + size + parentType
                    }
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: 12
                    font.family: Md3Theme.typography.fontFamily
                }
            }

            Row {
                visible: root.expanded
                width: parent.width
                spacing: 8
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("页内渐进")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: 11
                    width: parent.width - 56
                }
                Md3Switch {
                    checked: Md3Theme.progressiveContent
                    onToggled: function (v) {
                        Md3Theme.progressiveContent = v
                    }
                }
            }
        }
    }
}

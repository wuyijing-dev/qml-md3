import QtQuick

Rectangle {
    id: root

    property var model: []
    property int currentIndex: 0

    signal currentIndexChangedByUser(int index)

    readonly property real indicatorWidth: 64
    readonly property real indicatorHeight: 32

    width: parent ? parent.width : 360
    height: 80
    color: Md3Theme.colorScheme.surfaceContainer

    // Shared sliding active indicator (behind destinations)
    Rectangle {
        id: activeIndicator
        width: root.indicatorWidth
        height: root.indicatorHeight
        radius: Md3Theme.shape.full
        color: Md3Theme.colorScheme.secondaryContainer
        visible: root.model.length > 0
        z: 0
        x: {
            const n = Math.max(1, root.model.length)
            const destW = root.width / n
            return destW * root.currentIndex + (destW - root.indicatorWidth) / 2
        }
        y: {
            const labelH = Md3Theme.typography.labelMedium.size + 2
            const contentH = root.indicatorHeight + 4 + labelH
            return (root.height - contentH) / 2
        }

        Behavior on x {
            NumberAnimation {
                duration: Md3Motion.spatialSnapDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }
    }

    Row {
        id: row
        anchors.fill: parent
        z: 1

        Repeater {
            model: root.model
            delegate: Item {
                id: dest
                required property int index
                required property var modelData
                width: root.width / Math.max(1, root.model.length)
                height: parent.height

                readonly property bool selected: root.currentIndex === index

                Column {
                    anchors.centerIn: parent
                    spacing: 4

                    Item {
                        id: iconSlot
                        width: root.indicatorWidth
                        height: root.indicatorHeight
                        anchors.horizontalCenter: parent.horizontalCenter

                        Md3Ripple {
                            id: ripple
                            rippleColor: dest.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                       : Md3Theme.colorScheme.colorOnSurfaceVariant
                            clipRadius: Md3Theme.shape.full
                        }
                        Md3StateOverlay {
                            overlayColor: dest.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                        : Md3Theme.colorScheme.colorOnSurfaceVariant
                            hovered: mouse.containsMouse
                            pressed: mouse.pressed
                            focused: false
                            controlEnabled: true
                            radius: Md3Theme.shape.full
                        }

                        Md3Icon {
                            anchors.centerIn: parent
                            icon: dest.modelData.icon !== undefined ? dest.modelData.icon : "circle"
                            size: 24
                            iconColor: dest.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                     : Md3Theme.colorScheme.colorOnSurfaceVariant
                            Behavior on iconColor {
                                ColorAnimation {
                                    duration: Md3Motion.short4
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Md3Motion.standard
                                }
                            }
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: dest.modelData.label !== undefined ? dest.modelData.label : ""
                        color: dest.selected ? Md3Theme.colorScheme.colorOnSurface
                                             : Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.labelMedium.size
                        font.weight: Md3Theme.typography.labelMedium.weight
                        Behavior on color {
                            ColorAnimation {
                                duration: Md3Motion.short4
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Md3Motion.standard
                            }
                        }
                    }
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: function (mouse) {
                        const local = mapToItem(iconSlot, mouse.x, mouse.y)
                        ripple.pulse(local.x, local.y)
                        root.currentIndex = dest.index
                        root.currentIndexChangedByUser(dest.index)
                    }
                }
            }
        }
    }
}

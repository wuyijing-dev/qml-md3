import QtQuick
import Md3

Rectangle {
    id: root

    property var model: []
    property int currentIndex: 0

    signal currentIndexChangedByUser(int index)

    readonly property real indicatorWidth: 64
    readonly property real indicatorHeight: 32

    width: parent ? parent.width : 360
    height: Md3Theme.bottomBarHeight
    color: Md3Theme.colorScheme.surfaceContainer
    activeFocusOnTab: true
    focus: true

    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Navigation bar")

    function _moveDest(delta) {
        const n = model.length
        if (n <= 0)
            return
        const next = (currentIndex + delta + n) % n
        currentIndex = next
        currentIndexChangedByUser(next)
    }

    Keys.onPressed: function (event) {
        if (model.length <= 0)
            return
        if (event.key === Qt.Key_Left || event.key === Qt.Key_Up) {
            _moveDest(-1)
            event.accepted = true
        } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Down) {
            _moveDest(1)
            event.accepted = true
        } else if (event.key === Qt.Key_Space || event.key === Qt.Key_Return
                   || event.key === Qt.Key_Enter) {
            currentIndexChangedByUser(currentIndex)
            event.accepted = true
        }
    }

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
                            focused: root.activeFocus && dest.selected
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

                        Md3Badge {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.rightMargin: 4
                            anchors.topMargin: 0
                            z: 5
                            visible: {
                                const m = dest.modelData
                                if (!m)
                                    return false
                                if (m.badgeDot === true)
                                    return true
                                if (m.badge !== undefined && m.badge !== null && String(m.badge).length > 0)
                                    return true
                                if (m.badgeText !== undefined && String(m.badgeText).length > 0)
                                    return true
                                return false
                            }
                            dot: !!(dest.modelData && dest.modelData.badgeDot)
                            text: {
                                const m = dest.modelData
                                if (!m || m.badgeDot)
                                    return ""
                                if (m.badge !== undefined && m.badge !== null)
                                    return String(m.badge)
                                if (m.badgeText !== undefined)
                                    return String(m.badgeText)
                                return ""
                            }
                            max: dest.modelData && dest.modelData.badgeMax !== undefined
                                 ? Number(dest.modelData.badgeMax) : 99
                            sizePreset: Md3Badge.Small
                        }
                    }

                    Md3Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: dest.modelData.label !== undefined ? dest.modelData.label : ""
                        role: Md3Text.LabelMedium
                        tone: Md3Text.Custom
                        customColor: dest.selected ? Md3Theme.colorScheme.colorOnSurface
                                                   : Md3Theme.colorScheme.colorOnSurfaceVariant
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

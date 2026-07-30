import QtQuick
import Md3

Item {
    id: root

    property bool open: false
    property bool modal: true
    property var model: []
    property int currentIndex: 0
    property string title: ""
    property real drawerWidth: 360
    // MD3 modal drawer sits flush to the host's start edge (content / scaffold), not the OS window
    property real startMargin: 0

    signal currentIndexChangedByUser(int index)
    signal dismissed()

    readonly property real destinationHeight: 56
    readonly property real destinationSpacing: 0
    readonly property real panelWidth: Math.min(drawerWidth, Math.max(0, width - startMargin))

    anchors.fill: parent
    // Stay visible while close animation runs
    visible: open || drawer.x > -drawer.width + startMargin + 0.5 || scrim.opacity > 0.01
    z: 950
    clip: true // keep drawer/scrim inside host (e.g. gallery content pane)

    Accessible.role: Accessible.Pane
    Accessible.name: title.length ? title : qsTr("Navigation drawer")

    function destinationY(index) {
        return index * (destinationHeight + destinationSpacing)
    }

    function dismiss() {
        open = false
        dismissed()
    }

    Rectangle {
        id: scrim
        anchors.fill: parent
        visible: root.modal
        color: Md3Theme.colorScheme.scrim
        opacity: root.open ? 0.32 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: Md3Motion.overlayDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        MouseArea {
            anchors.fill: parent
            enabled: root.open && root.modal
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.dismiss()
        }
    }

    Md3Shadow {
        anchors.fill: drawer
        elevation: root.open ? 1 : 0
        cornerRadius: 0
        // Approximate trailing round: shadow uses rect; fine for soft depth
        opacity: drawer.opacity
    }

    Rectangle {
        id: drawer
        width: root.panelWidth
        height: parent.height
        // Slide from the host's left edge (content area), not the application window
        x: root.open ? root.startMargin : root.startMargin - width
        y: 0
        color: Md3Theme.colorScheme.surfaceContainerLow
        // MD3: rounded on the trailing edge only
        topLeftRadius: 0
        bottomLeftRadius: 0
        topRightRadius: Md3Theme.shape.large
        bottomRightRadius: Md3Theme.shape.large

        Behavior on x {
            NumberAnimation {
                duration: Md3Motion.spatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 0

            Text {
                visible: root.title.length > 0
                width: parent.width
                // Avoid `height: visible ? …` — that binds height↔visible and loops.
                height: root.title.length > 0 ? implicitHeight : 0
                text: root.title
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.titleSmall.size
                font.family: Md3Theme.typography.fontFamily
                leftPadding: 16
                topPadding: 4
                bottomPadding: 12
            }

            Item {
                id: destinations
                width: parent.width
                height: Math.max(0, root.model.length) * root.destinationHeight

                Rectangle {
                    id: activeIndicator
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: root.destinationHeight
                    y: root.destinationY(root.currentIndex)
                    radius: Md3Theme.shape.full
                    color: Md3Theme.colorScheme.secondaryContainer
                    visible: root.model.length > 0
                    z: 0

                    Behavior on y {
                        NumberAnimation {
                            duration: Md3Motion.spatialSnapDuration
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Md3Motion.emphasized
                        }
                    }
                }

                Repeater {
                    model: root.model
                    delegate: Item {
                        id: dest
                        required property int index
                        required property var modelData

                        width: destinations.width
                        height: root.destinationHeight
                        y: root.destinationY(index)
                        z: 1

                        readonly property bool selected: root.currentIndex === index

                        Md3Ripple {
                            id: ripple
                            anchors.fill: parent
                            rippleColor: dest.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                       : Md3Theme.colorScheme.colorOnSurface
                            clipRadius: Md3Theme.shape.full
                        }
                        Md3StateOverlay {
                            overlayColor: dest.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                        : Md3Theme.colorScheme.colorOnSurface
                            hovered: mouse.containsMouse
                            pressed: mouse.pressed
                            focused: false
                            controlEnabled: true
                            radius: Md3Theme.shape.full
                        }

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            spacing: 12
                            z: 2
                            Md3Icon {
                                icon: modelData.icon !== undefined ? modelData.icon : "circle"
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
                            Text {
                                text: modelData.label !== undefined ? modelData.label : ""
                                color: dest.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                     : Md3Theme.colorScheme.colorOnSurface
                                font.family: Md3Theme.typography.fontFamily
                                font.pixelSize: Md3Theme.typography.labelLarge.size
                                anchors.verticalCenter: parent.verticalCenter
                                Behavior on color {
                                    ColorAnimation {
                                        duration: Md3Motion.short4
                                        easing.type: Easing.BezierSpline
                                        easing.bezierCurve: Md3Motion.standard
                                    }
                                }
                            }
                        }

                        Md3Badge {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 16
                            z: 5
                            visible: {
                                const m = modelData
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
                            dot: !!(modelData && modelData.badgeDot)
                            text: {
                                const m = modelData
                                if (!m || m.badgeDot)
                                    return ""
                                if (m.badge !== undefined && m.badge !== null)
                                    return String(m.badge)
                                if (m.badgeText !== undefined)
                                    return String(m.badgeText)
                                return ""
                            }
                            max: modelData && modelData.badgeMax !== undefined ? Number(modelData.badgeMax) : 99
                            sizePreset: Md3Badge.Small
                        }

                        MouseArea {
                            id: mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: function (mouse) {
                                ripple.pulse(mouse.x, mouse.y)
                                root.currentIndex = dest.index
                                root.currentIndexChangedByUser(dest.index)
                                if (root.modal)
                                    root.dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}

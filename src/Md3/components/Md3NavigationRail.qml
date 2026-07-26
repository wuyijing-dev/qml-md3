import QtQuick
import QtQuick.Window

Rectangle {
    id: root

    property var model: []
    property int currentIndex: 0
    property bool expanded: false
    property string headerLabel: ""
    /// Built-in control to expand/collapse and show full labels
    property bool showExpandToggle: true

    signal currentIndexChangedByUser(int index)
    /// Hover intent for PageHost predictive prefetch (L2 / soft L1).
    signal destinationHovered(int index)
    signal destinationUnhovered(int index)
    signal expandToggleClicked()

    readonly property real destinationHeight: 56
    readonly property real destinationSpacing: 4
    readonly property real indicatorInset: 12
    readonly property real collapsedIndicatorWidth: 56
    readonly property real collapsedIndicatorHeight: 32
    readonly property int expandDuration: Md3Motion.spatialDuration

    width: expanded ? 256 : 80
    height: parent ? parent.height : 400
    color: {
        const w = Window.window
        if (w && w.usesSystemBackdrop) {
            const t = w.backdropTitleTint !== undefined ? w.backdropTitleTint : 0.22
            return Qt.alpha(Md3Theme.colorScheme.surfaceContainer, Math.max(0.15, t + 0.05))
        }
        return Md3Theme.colorScheme.surface
    }
    clip: true

    Behavior on width {
        NumberAnimation {
            duration: root.expandDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }

    function destinationY(index) {
        return index * (destinationHeight + destinationSpacing)
    }

    // Expand / collapse — shows full destination labels when open
    Item {
        id: expandToggle
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.leftMargin: root.indicatorInset
        width: root.expanded ? Math.max(root.collapsedIndicatorWidth, parent.width - root.indicatorInset * 2)
                             : root.collapsedIndicatorWidth
        height: 40
        visible: root.showExpandToggle
        z: 5
        Accessible.name: root.expanded ? qsTr("Collapse navigation") : qsTr("Expand navigation")
        Accessible.role: Accessible.Button
        Accessible.onPressAction: root.expandToggleClicked()

        Behavior on width {
            NumberAnimation {
                duration: root.expandDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: Md3Theme.shape.full
            color: expandMouse.containsMouse || expandMouse.pressed
                   ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, expandMouse.pressed ? 0.12 : 0.08)
                   : "transparent"
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: root.expanded ? 16 : (root.collapsedIndicatorWidth - 24) / 2
            spacing: 12

            Behavior on anchors.leftMargin {
                NumberAnimation {
                    duration: root.expandDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }

            Md3Icon {
                icon: root.expanded ? "menu_open" : "menu"
                size: 24
                iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: qsTr("Menu")
                opacity: root.expanded ? 1 : 0
                visible: opacity > 0.02
                width: root.expanded ? implicitWidth : 0
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.labelLarge.size
                anchors.verticalCenter: parent.verticalCenter
                Behavior on opacity {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
            }
        }

        MouseArea {
            id: expandMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.expandToggleClicked()
        }
    }

    Flickable {
        id: flick
        anchors.fill: parent
        anchors.topMargin: root.showExpandToggle ? 52 : 12
        anchors.bottomMargin: 8
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        contentWidth: width
        contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: column
            width: flick.width
            spacing: 4

            Text {
                opacity: root.expanded && root.headerLabel.length > 0 ? 1 : 0
                visible: opacity > 0.01
                height: opacity > 0.01 ? implicitHeight : 0
                width: parent.width
                text: root.headerLabel
                leftPadding: 16
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.titleSmall.size
                font.family: Md3Theme.typography.fontFamily
                Behavior on opacity {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
            }

            Item {
                id: destinations
                width: parent.width
                height: Math.max(0, root.model.length) * (root.destinationHeight + root.destinationSpacing)
                       - (root.model.length > 0 ? root.destinationSpacing : 0)

            // Active indicator: jumps to the clicked row instantly, then grows
            // horizontally from center → edges (not a slide from the previous item).
            property real _indicatorReveal: 1
            property int _lastIndicatorIndex: -1

            Connections {
                target: root
                function onCurrentIndexChanged() {
                    if (destinations._lastIndicatorIndex < 0) {
                        destinations._lastIndicatorIndex = root.currentIndex
                        destinations._indicatorReveal = 1
                        return
                    }
                    if (destinations._lastIndicatorIndex === root.currentIndex)
                        return
                    destinations._lastIndicatorIndex = root.currentIndex
                    destinations._indicatorReveal = 0
                    indicatorRevealAnim.restart()
                }
            }

            NumberAnimation {
                id: indicatorRevealAnim
                target: destinations
                property: "_indicatorReveal"
                from: 0
                to: 1
                duration: Md3Motion.short4
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasizedDecelerate
            }

            Rectangle {
                id: activeIndicator
                x: root.indicatorInset
                width: root.expanded
                       ? Math.max(root.collapsedIndicatorWidth, destinations.width - root.indicatorInset * 2)
                       : root.collapsedIndicatorWidth
                height: root.expanded ? root.destinationHeight : root.collapsedIndicatorHeight
                // Instant Y — no travel from previous destination
                y: root.destinationY(root.currentIndex)
                   + (root.destinationHeight - (root.expanded ? root.destinationHeight
                                                              : root.collapsedIndicatorHeight)) / 2
                radius: Md3Theme.shape.full
                color: Md3Theme.colorScheme.secondaryContainer
                visible: root.model.length > 0
                z: 0
                transform: Scale {
                    origin.x: activeIndicator.width / 2
                    origin.y: activeIndicator.height / 2
                    xScale: Math.max(0.001, destinations._indicatorReveal)
                    yScale: 1
                }

                Behavior on x {
                    NumberAnimation {
                        duration: root.expandDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
                    }
                }
                Behavior on width {
                    enabled: !indicatorRevealAnim.running
                    NumberAnimation {
                        duration: root.expandDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
                    }
                }
                Behavior on height {
                    NumberAnimation {
                        duration: root.expandDuration
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

                    Item {
                        id: hit
                        anchors.left: parent.left
                        anchors.leftMargin: root.indicatorInset
                        anchors.verticalCenter: parent.verticalCenter
                        width: root.expanded
                               ? Math.max(root.collapsedIndicatorWidth, parent.width - root.indicatorInset * 2)
                               : root.collapsedIndicatorWidth
                        height: root.expanded ? root.destinationHeight : root.collapsedIndicatorHeight

                        Behavior on width {
                            NumberAnimation {
                                duration: root.expandDuration
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Md3Motion.emphasized
                            }
                        }
                        Behavior on height {
                            NumberAnimation {
                                duration: root.expandDuration
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Md3Motion.emphasized
                            }
                        }

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
                    }

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: root.expanded
                                            ? root.indicatorInset + 16
                                            : root.indicatorInset + (root.collapsedIndicatorWidth - 24) / 2
                        spacing: 12
                        z: 2

                        Behavior on anchors.leftMargin {
                            NumberAnimation {
                                duration: root.expandDuration
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Md3Motion.emphasized
                            }
                        }

                        Md3Icon {
                            icon: modelData.icon !== undefined ? modelData.icon : "circle"
                            size: 24
                            iconColor: dest.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                     : Md3Theme.colorScheme.colorOnSurfaceVariant
                            anchors.verticalCenter: parent.verticalCenter
                            Behavior on iconColor {
                                ColorAnimation {
                                    duration: Md3Motion.short4
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Md3Motion.standard
                                }
                            }
                        }
                        Text {
                            opacity: root.expanded ? 1 : 0
                            visible: opacity > 0.02
                            width: root.expanded ? implicitWidth : 0
                            clip: true
                            text: modelData.label !== undefined ? modelData.label : ""
                            color: dest.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                 : Md3Theme.colorScheme.colorOnSurface
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.labelLarge.size
                            anchors.verticalCenter: parent.verticalCenter
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: Md3Motion.short3
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Md3Motion.standard
                                }
                            }
                            Behavior on width {
                                NumberAnimation {
                                    duration: root.expandDuration
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Md3Motion.emphasized
                                }
                            }
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
                        onEntered: root.destinationHovered(dest.index)
                        onExited: root.destinationUnhovered(dest.index)
                        onClicked: function (mouse) {
                            const local = mapToItem(hit, mouse.x, mouse.y)
                            ripple.pulse(local.x, local.y)
                            // Page switch first (parent navigateTo), then indicator morph.
                            if (dest.index !== root.currentIndex)
                                root.currentIndexChangedByUser(dest.index)
                            root.currentIndex = dest.index
                        }
                    }
                }
            }
        }
        }
    }
}

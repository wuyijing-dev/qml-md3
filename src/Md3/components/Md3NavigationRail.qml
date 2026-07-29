import QtQuick
import QtQuick.Window

Rectangle {
    id: root

    /// Main (scrollable) destinations. Each entry: { icon, label, destIndex? }
    /// destIndex defaults to array index when omitted (legacy).
    property var model: []
    /// Bottom-pinned destinations (same entry shape). Use real destIndex for PageHost.
    property var footerModel: []
    /// Selected destination index (maps to destIndex, not visual row).
    property int currentIndex: 0
    property bool expanded: false
    property string headerLabel: ""
    property bool showExpandToggle: true

    signal currentIndexChangedByUser(int index)
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

    function destIndexOf(entry, fallback) {
        if (entry && entry.destIndex !== undefined && entry.destIndex !== null)
            return Number(entry.destIndex)
        return fallback
    }

    function destinationY(index) {
        return index * (destinationHeight + destinationSpacing)
    }

    function _selectDest(destIndex) {
        if (destIndex !== root.currentIndex)
            root.currentIndexChangedByUser(destIndex)
        root.currentIndex = destIndex
    }

    Component {
        id: destDelegate
        Item {
            id: dest
            property int destIndex: 0
            property var modelData: ({})
            property Item indicatorHost: null

            width: parent ? parent.width : 80
            height: root.destinationHeight

            readonly property bool selected: root.currentIndex === destIndex

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

                // Active pill lives on the selected row (works in scroll + footer).
                Rectangle {
                    id: activePill
                    anchors.fill: parent
                    radius: Md3Theme.shape.full
                    color: Md3Theme.colorScheme.secondaryContainer
                    visible: dest.selected
                    opacity: destinationsShared._indicatorReveal
                    transform: Scale {
                        origin.x: activePill.width / 2
                        origin.y: activePill.height / 2
                        xScale: Math.max(0.001, destinationsShared._indicatorReveal)
                        yScale: 1
                    }
                    z: 0
                }

                Md3Ripple {
                    id: ripple
                    z: 1
                    rippleColor: dest.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                               : Md3Theme.colorScheme.colorOnSurfaceVariant
                    clipRadius: Md3Theme.shape.full
                }
                Md3StateOverlay {
                    z: 1
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
                Item {
                    // Badge sits on the icon when collapsed; beside label when expanded.
                    width: badge.visible ? Math.max(8, badge.width - 4) : 0
                    height: 1
                    visible: false
                }
                Md3Text {
                    opacity: root.expanded ? 1 : 0
                    visible: opacity > 0.02
                    width: root.expanded ? implicitWidth : 0
                    clip: true
                    text: modelData.label !== undefined ? modelData.label : ""
                    role: Md3Text.LabelLarge
                    tone: Md3Text.Custom
                    customColor: dest.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                               : Md3Theme.colorScheme.colorOnSurface
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

            Md3Badge {
                id: badge
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: root.expanded
                                   ? root.indicatorInset + 28
                                   : root.indicatorInset + root.collapsedIndicatorWidth - 14
                anchors.topMargin: (parent.height - root.indicatorHeight) / 2 - 2
                z: 6
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
                onEntered: root.destinationHovered(dest.destIndex)
                onExited: root.destinationUnhovered(dest.destIndex)
                onClicked: function (mouse) {
                    const local = mapToItem(hit, mouse.x, mouse.y)
                    ripple.pulse(local.x, local.y)
                    root._selectDest(dest.destIndex)
                }
            }

            Accessible.name: modelData.label !== undefined ? modelData.label : qsTr("Destination")
            Accessible.role: Accessible.PageTab
            Accessible.checkable: true
            Accessible.checked: dest.selected
            Accessible.onPressAction: root._selectDest(dest.destIndex)
        }
    }

    // Shared indicator reveal state across main + footer rows
    QtObject {
        id: destinationsShared
        property real _indicatorReveal: 1
        property int _lastIndicatorIndex: -1
    }

    Connections {
        target: root
        function onCurrentIndexChanged() {
            if (destinationsShared._lastIndicatorIndex < 0) {
                destinationsShared._lastIndicatorIndex = root.currentIndex
                destinationsShared._indicatorReveal = 1
                return
            }
            if (destinationsShared._lastIndicatorIndex === root.currentIndex)
                return
            destinationsShared._lastIndicatorIndex = root.currentIndex
            destinationsShared._indicatorReveal = 0
            indicatorRevealAnim.restart()
        }
    }

    NumberAnimation {
        id: indicatorRevealAnim
        target: destinationsShared
        property: "_indicatorReveal"
        from: 0
        to: 1
        duration: Md3Motion.short4
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Md3Motion.emphasizedDecelerate
    }

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
            Md3Text {
                text: qsTr("Menu")
                opacity: root.expanded ? 1 : 0
                visible: root.expanded
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurface
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

    readonly property real _footerBlockHeight: {
        const n = root.footerModel ? root.footerModel.length : 0
        if (n <= 0)
            return 0
        return n * (root.destinationHeight + root.destinationSpacing)
                - root.destinationSpacing + 12
    }

    Flickable {
        id: flick
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: root.showExpandToggle ? 52 : 12
        anchors.bottom: footerColumn.top
        anchors.bottomMargin: 4
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        contentWidth: width
        contentHeight: mainColumn.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: mainColumn
            width: flick.width
            spacing: 4

            Md3Text {
                opacity: root.expanded && root.headerLabel.length > 0 ? 1 : 0
                visible: root.expanded && root.headerLabel.length > 0
                width: parent.width
                text: root.headerLabel
                leftPadding: 16
                role: Md3Text.TitleSmall
                tone: Md3Text.OnSurfaceVariant
                Behavior on opacity {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
            }

            Repeater {
                model: root.model
                delegate: Loader {
                    required property int index
                    required property var modelData
                    width: mainColumn.width
                    height: root.destinationHeight
                    sourceComponent: destDelegate
                    onLoaded: {
                        item.destIndex = root.destIndexOf(modelData, index)
                        item.modelData = modelData
                    }
                    Binding {
                        target: item
                        property: "destIndex"
                        value: root.destIndexOf(modelData, index)
                        when: item !== null
                    }
                    Binding {
                        target: item
                        property: "modelData"
                        value: modelData
                        when: item !== null
                    }
                }
            }
        }
    }

    Column {
        id: footerColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        spacing: root.destinationSpacing
        visible: root.footerModel && root.footerModel.length > 0

        Rectangle {
            width: parent.width - root.indicatorInset * 2
            anchors.horizontalCenter: parent.horizontalCenter
            height: 1
            color: Md3Theme.colorScheme.outlineVariant
            opacity: 0.6
            visible: parent.visible
        }

        Repeater {
            model: root.footerModel
            delegate: Loader {
                required property int index
                required property var modelData
                width: footerColumn.width
                height: root.destinationHeight
                sourceComponent: destDelegate
                Binding {
                    target: item
                    property: "destIndex"
                    value: root.destIndexOf(modelData, index)
                    when: item !== null
                }
                Binding {
                    target: item
                    property: "modelData"
                    value: modelData
                    when: item !== null
                }
            }
        }
    }
}

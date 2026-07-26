import QtQuick
import QtQuick.Window

/// Win11 Explorer / browser document tabs — reorder, close, tear-off, add pop-in.
Item {
    id: root

    /// [{ title, icon?, closable? }]
    property var model: []
    property int currentIndex: 0
    property bool showAddButton: true
    property bool closable: true
    property bool tearOffEnabled: true
    property bool reorderEnabled: true
    property real tabHeight: 32
    property real minTabWidth: 120
    property real maxTabWidth: 240
    property real dragThreshold: 8
    property real tearOffSlop: 28
    /// Play pop-in when a tab is appended
    property bool animateAdd: true

    signal tabActivated(int index)
    signal tabCloseRequested(int index)
    signal tabAddRequested()
    signal tabMoved(int from, int to)
    signal tabTearOff(int index, real globalX, real globalY)

    implicitHeight: tabHeight + 6
    height: implicitHeight
    width: parent ? parent.width : 400
    clip: false

    readonly property color barColor: {
        const w = Window.window
        if (w && w.usesSystemBackdrop) {
            const t = w.backdropTitleTint !== undefined ? w.backdropTitleTint : 0.08
            return Qt.alpha(Md3Theme.colorScheme.surfaceContainerHigh,
                            Math.min(0.45, Math.max(0.08, t + 0.12)))
        }
        return Md3Theme.colorScheme.surfaceContainerHigh
    }
    readonly property color tabSelected: {
        const w = Window.window
        if (w && w.usesSystemBackdrop) {
            const t = w.backdropContentTint !== undefined ? w.backdropContentTint : 0.12
            return Qt.alpha(Md3Theme.colorScheme.surface, Math.min(0.55, Math.max(0.15, t + 0.15)))
        }
        return Md3Theme.colorScheme.surface
    }
    readonly property color tabHover: Md3Theme.colorScheme.withOpacity(
                                          Md3Theme.colorScheme.colorOnSurface, 0.05)
    readonly property real tabRadius: 8

    property int _dragIndex: -1
    property int _dropIndex: -1
    property real _dragStartX: 0
    property real _dragStartY: 0
    property bool _dragging: false
    property bool _tearArmed: false
    property real _ghostX: 0
    property real _ghostY: 0
    property string _ghostTitle: ""
    property string _ghostIcon: ""
    property int _prevCount: 0
    property int _animIndex: -1

    function _tabWidth() {
        if (!model || model.length === 0)
            return minTabWidth
        const avail = Math.max(0, list.width - 4)
        const ideal = avail / Math.max(1, model.length)
        // Prefer scroll over crushing tabs below a readable size
        return Math.max(minTabWidth, Math.min(maxTabWidth, ideal))
    }

    readonly property bool _canScroll: list.contentWidth > list.width + 1
    readonly property bool _canScrollLeft: {
        list.contentX
        return root._canScroll && list.contentX > 1
    }
    readonly property bool _canScrollRight: {
        list.contentX
        list.contentWidth
        list.width
        return root._canScroll
                && list.contentX < list.contentWidth - list.width - 1
    }

    function scrollTabs(delta) {
        const maxX = Math.max(0, list.contentWidth - list.width)
        list.contentX = Math.max(0, Math.min(maxX, list.contentX + delta))
    }

    function ensureTabVisible(index) {
        if (index < 0 || !model || index >= model.length)
            return
        const w = _tabWidth()
        const left = index * w
        const right = left + w
        if (left < list.contentX)
            list.contentX = Math.max(0, left)
        else if (right > list.contentX + list.width)
            list.contentX = Math.max(0, right - list.width)
    }

    onCurrentIndexChanged: Qt.callLater(function () {
        root.ensureTabVisible(root.currentIndex)
    })
    onModelChanged: {
        const n = model ? model.length : 0
        if (animateAdd && n > _prevCount && n > 0)
            _animIndex = n - 1
        _prevCount = n
        Qt.callLater(function () {
            root._animIndex = -1
            root.ensureTabVisible(root.currentIndex)
        })
    }

    function _entry(i) {
        if (!model || i < 0 || i >= model.length)
            return null
        return model[i]
    }

    function _closableOf(i) {
        const e = _entry(i)
        if (e && e.closable !== undefined)
            return !!e.closable
        return root.closable && model && model.length > 1
    }

    function _indexAtX(x) {
        if (!model || model.length === 0)
            return 0
        const w = _tabWidth()
        const i = Math.floor((x + list.contentX - 6) / w)
        return Math.max(0, Math.min(model.length - 1, i))
    }

    function _outsideWindow(gx, gy) {
        const w = Window.window
        if (!w)
            return true
        return gx < w.x || gy < w.y || gx > w.x + w.width || gy > w.y + w.height
    }

    function _finishDrag(gx, gy) {
        const from = _dragIndex
        const tear = root.tearOffEnabled && from >= 0
                     && (_tearArmed || _outsideWindow(gx, gy))
        const drop = _dropIndex
        _dragging = false
        _tearArmed = false
        _dragIndex = -1
        _dropIndex = -1
        ghost.visible = false
        if (from < 0)
            return
        if (tear) {
            root.tabTearOff(from, gx, gy)
            return
        }
        if (root.reorderEnabled && drop >= 0 && drop !== from)
            root.tabMoved(from, drop)
    }

    // Title-bar strip (Explorer gray)
    Rectangle {
        anchors.fill: parent
        color: root.barColor
    }

    // Bottom hairline — selected tab covers it (sheet metaphor)
    Rectangle {
        id: bottomRule
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Md3Theme.colorScheme.outlineVariant
        z: 1
    }

    // Scroll chevrons + add — pinned so overflowing tabs stay reachable
    Row {
        id: trailingTools
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 4
        spacing: 2
        z: 5

        Rectangle {
            visible: root._canScroll
            width: visible ? 28 : 0
            height: 28
            radius: 6
            anchors.verticalCenter: parent.verticalCenter
            opacity: root._canScrollLeft ? 1 : 0.35
            color: scrollLeftMouse.containsMouse && root._canScrollLeft
                   ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.08)
                   : "transparent"
            Md3Icon {
                anchors.centerIn: parent
                icon: "chevron_left"
                size: 18
                iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
            }
            MouseArea {
                id: scrollLeftMouse
                anchors.fill: parent
                enabled: root._canScrollLeft
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.scrollTabs(-Math.max(120, root._tabWidth() * 2))
            }
        }

        Rectangle {
            visible: root._canScroll
            width: visible ? 28 : 0
            height: 28
            radius: 6
            anchors.verticalCenter: parent.verticalCenter
            opacity: root._canScrollRight ? 1 : 0.35
            color: scrollRightMouse.containsMouse && root._canScrollRight
                   ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.08)
                   : "transparent"
            Md3Icon {
                anchors.centerIn: parent
                icon: "chevron_right"
                size: 18
                iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
            }
            MouseArea {
                id: scrollRightMouse
                anchors.fill: parent
                enabled: root._canScrollRight
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.scrollTabs(Math.max(120, root._tabWidth() * 2))
            }
        }

        Item {
            id: addSlot
            width: root.showAddButton ? 36 : 0
            height: parent.height
            visible: root.showAddButton

            Rectangle {
                width: 28
                height: 28
                radius: 6
                anchors.centerIn: parent
                color: addMouse.containsMouse
                       ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.08)
                       : "transparent"
                Md3Icon {
                    anchors.centerIn: parent
                    icon: "add"
                    size: 16
                    iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                }
                MouseArea {
                    id: addMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.tabAddRequested()
                }
            }
        }
    }

    ListView {
        id: list
        anchors.left: parent.left
        anchors.right: trailingTools.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 6
        anchors.rightMargin: 2
        anchors.topMargin: 4
        anchors.bottomMargin: 0
        orientation: ListView.Horizontal
        spacing: 0
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick
        model: root.model
        // Keep flick enabled; tab MouseArea only steals after drag threshold
        interactive: !_dragging

        WheelHandler {
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: function (event) {
                const dx = event.angleDelta.y !== 0 ? -event.angleDelta.y : event.angleDelta.x
                if (dx !== 0) {
                    root.scrollTabs(dx)
                    event.accepted = true
                }
            }
        }

        footer: null

        add: Transition {
            enabled: root.animateAdd
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: Md3Motion.short4
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasizedDecelerate
            }
        }
        displaced: Transition {
            NumberAnimation {
                properties: "x"
                duration: Md3Motion.short3
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }
        remove: Transition {
            NumberAnimation {
                property: "opacity"
                to: 0
                duration: Md3Motion.short2
            }
        }

        delegate: Item {
            id: tab
            required property int index
            required property var modelData

            width: root._tabWidth()
            height: list.height
            z: selected ? 3 : 1
            opacity: root._dragging && root._dragIndex === index ? 0.3 : 1

            readonly property string title: {
                const m = modelData
                return m && m.text !== undefined ? m.text
                     : (m && m.title !== undefined ? m.title : String(m))
            }
            readonly property string iconName: {
                const m = modelData
                return (m && m.icon !== undefined) ? m.icon : ""
            }
            readonly property bool selected: root.currentIndex === index
            readonly property bool canClose: root._closableOf(index)
            readonly property bool popping: root._animIndex === index

            // Pop-in from the + button
            transform: Scale {
                id: popScale
                origin.x: tab.width / 2
                origin.y: tab.height
                xScale: tab.popping ? 0.86 : 1
                yScale: tab.popping ? 0.86 : 1
                Behavior on xScale {
                    NumberAnimation {
                        duration: Md3Motion.short4
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasizedDecelerate
                    }
                }
                Behavior on yScale {
                    NumberAnimation {
                        duration: Md3Motion.short4
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasizedDecelerate
                    }
                }
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                anchors.rightMargin: 24
                hoverEnabled: true
                cursorShape: root._dragging ? Qt.ClosedHandCursor : Qt.ArrowCursor
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                // Allow ListView to flick until we commit to a tab drag
                preventStealing: root._dragging
                z: 0
                onClicked: function (ev) {
                    if (ev.button === Qt.MiddleButton) {
                        if (tab.canClose)
                            root.tabCloseRequested(tab.index)
                        return
                    }
                    if (root._dragging)
                        return
                    root.currentIndex = tab.index
                    root.tabActivated(tab.index)
                }
                onPressed: function (ev) {
                    if (ev.button !== Qt.LeftButton)
                        return
                    root._dragIndex = tab.index
                    root._dropIndex = tab.index
                    root._dragStartX = ev.x
                    root._dragStartY = ev.y
                    root._dragging = false
                    root._tearArmed = false
                    root._ghostTitle = tab.title
                    root._ghostIcon = tab.iconName
                }
                onPositionChanged: function (ev) {
                    if (root._dragIndex !== tab.index)
                        return
                    const dx = ev.x - root._dragStartX
                    const dy = ev.y - root._dragStartY
                    // Prefer horizontal flick of the strip over accidental reorder
                    if (!root._dragging) {
                        if (Math.abs(dy) >= root.tearOffSlop
                                || (Math.abs(dx) >= root.dragThreshold * 2
                                    && Math.abs(dx) > Math.abs(dy) * 1.5
                                    && root.reorderEnabled)) {
                            root._dragging = true
                            ghost.visible = true
                            preventStealing = true
                        } else {
                            return
                        }
                    }
                    if (!root._dragging)
                        return
                    const g = mapToItem(root, ev.x, ev.y)
                    root._ghostX = g.x - ghost.width / 2
                    root._ghostY = g.y - ghost.height / 2
                    const gp = mapToGlobal(ev.x, ev.y)
                    root._tearArmed = root.tearOffEnabled
                            && (Math.abs(dy) >= root.tearOffSlop
                                || root._outsideWindow(gp.x, gp.y))
                    if (root.reorderEnabled && !root._tearArmed)
                        root._dropIndex = root._indexAtX(g.x)
                }
                onReleased: function (ev) {
                    if (root._dragIndex !== tab.index)
                        return
                    const gp = mapToGlobal(ev.x, ev.y)
                    root._finishDrag(gp.x, gp.y)
                }
                onCanceled: {
                    root._dragging = false
                    root._tearArmed = false
                    root._dragIndex = -1
                    root._dropIndex = -1
                    ghost.visible = false
                }
            }

            // Explorer sheet tab: rounded top only, flush with content below
            Item {
                id: bg
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 2
                anchors.bottomMargin: tab.selected ? -1 : 1
                z: 1
                enabled: false

                Rectangle {
                    anchors.fill: parent
                    radius: root.tabRadius
                    color: tab.selected ? root.tabSelected
                         : (dragArea.containsMouse ? root.tabHover : "transparent")
                }
                Rectangle {
                    visible: tab.selected || dragArea.containsMouse
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: root.tabRadius
                    color: tab.selected ? root.tabSelected
                         : (dragArea.containsMouse ? root.tabHover : "transparent")
                }
            }

            Row {
                id: row
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: closeBtn.left
                anchors.rightMargin: 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: tab.selected ? -0.5 : 0
                spacing: 6
                clip: true
                z: 2
                enabled: false

                Md3Icon {
                    visible: tab.iconName.length > 0
                    icon: tab.iconName
                    size: 16
                    iconColor: tab.selected ? Md3Theme.colorScheme.primary
                                            : Md3Theme.colorScheme.colorOnSurfaceVariant
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: tab.title
                    elide: Text.ElideRight
                    width: Math.max(24, row.width - (tab.iconName.length > 0 ? 22 : 0))
                    color: tab.selected ? Md3Theme.colorScheme.colorOnSurface
                                        : Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: 12
                    font.weight: tab.selected ? Font.Medium : Font.Normal
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Compact close — Explorer style
            Item {
                id: closeBtn
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: tab.selected ? -0.5 : 0
                width: 18
                height: 18
                z: 3
                visible: tab.canClose && (tab.selected || dragArea.containsMouse || closeMouse.containsMouse)
                opacity: visible ? 1 : 0

                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: closeMouse.containsMouse
                           ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.1)
                           : "transparent"
                }
                Md3Icon {
                    anchors.centerIn: parent
                    icon: "close"
                    size: 12
                    iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                }
                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.tabCloseRequested(tab.index)
                }
            }
        }
    }

    Rectangle {
        visible: root._dragging && !root._tearArmed && root._dropIndex >= 0
        width: 2
        height: list.height - 8
        radius: 1
        color: Md3Theme.colorScheme.primary
        y: 4
        x: 6 + root._dropIndex * root._tabWidth() - list.contentX
        z: 20
    }

    Rectangle {
        id: ghost
        visible: false
        width: Math.min(root.maxTabWidth, Math.max(root.minTabWidth, root._tabWidth()))
        height: list.height - 2
        radius: root.tabRadius
        color: root.tabSelected
        border.width: 1
        border.color: Md3Theme.colorScheme.outlineVariant
        x: root._ghostX
        y: root._ghostY
        z: 100
        opacity: root._tearArmed ? 0.95 : 0.88
        layer.enabled: true
        layer.smooth: true

        Row {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 6
            Md3Icon {
                visible: root._ghostIcon.length > 0
                icon: root._ghostIcon
                size: 16
                iconColor: Md3Theme.colorScheme.primary
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: root._ghostTitle
                elide: Text.ElideRight
                width: parent.width - 28
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}

import QtQuick

/*
  Material 3 Expressive / Android volume-style slider:
  thick capsule track, active+inactive segments, vertical handle
  taller than the track thickness, continuous end-stop or discrete ticks.
*/
Item {
    id: root

    property real from: 0
    property real to: 1
    property real value: 0.5
    property real stepSize: 0
    // Use Item.enabled (do not redeclare)
    property bool showLabel: false
    /// Field label above the track (replaces Column { Text; Slider } glue).
    property string label: ""
    /// Material icon left of `label` (Android volume-row pattern).
    property string leadingIcon: ""
    /// Show current value to the right of `label`.
    property bool showValue: false
    property int valueDecimals: 2
    /// Thick capsule height (MD3 expressive ~16–20)
    property real trackHeight: 16
    /// Handle thickness (along track). Keep slim.
    property real handleWidth: 4
    /// Handle length across track — must exceed trackHeight so thumb reads larger than the bar.
    property real handleHeight: trackHeight + 16
    property real segmentGap: 6
    /// Show end stop on continuous sliders (small terminal dot)
    property bool showStopIndicator: true
    /// Force tick dots; default = stepSize > 0
    property bool discrete: stepSize > 0
    property int maxTickCount: 24
    property string accessibleName: label.length ? label : "Slider"

    signal moved(real value)

    readonly property real _headerH: (label.length > 0 || showValue || leadingIcon.length > 0) ? 24 : 0
    readonly property real _bodyH: Math.max(48, handleHeight + 16)

    height: _headerH > 0 ? _headerH + 4 + _bodyH : _bodyH
    implicitHeight: height
    implicitWidth: 200
    width: implicitWidth
    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Slider
    Accessible.onIncreaseAction: nudge(1)
    Accessible.onDecreaseAction: nudge(-1)

    readonly property real progress: Math.max(0, Math.min(1, (value - from) / Math.max(0.0001, to - from)))
    readonly property color activeColor: enabled ? Md3Theme.colorScheme.primary
                                                 : Md3Theme.colorScheme.disabledContent()
    readonly property color inactiveColor: enabled ? Md3Theme.colorScheme.secondaryContainer
                                                   : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.12)
    readonly property color tickOnActive: Md3Theme.colorScheme.colorOnPrimary
    readonly property color tickOnInactive: Md3Theme.colorScheme.primary
    readonly property int tickCount: {
        if (!discrete || stepSize <= 0)
            return 0
        const n = Math.round((to - from) / stepSize) + 1
        return Math.max(2, Math.min(maxTickCount, n))
    }

    function setValue(v) {
        let next = Math.max(from, Math.min(to, v))
        if (stepSize > 0) {
            const steps = Math.round((next - from) / stepSize)
            next = from + steps * stepSize
            next = Math.max(from, Math.min(to, next))
        }
        if (value !== next) {
            value = next
            moved(value)
        }
    }

    function nudge(dir) {
        const delta = stepSize > 0 ? stepSize : (to - from) / 20
        setValue(value + dir * delta)
    }

    function valueAt(px) {
        const t = Math.max(0, Math.min(1, (px - track.x) / Math.max(1, track.width)))
        return from + t * (to - from)
    }

    Keys.onLeftPressed: nudge(-1)
    Keys.onRightPressed: nudge(1)
    Keys.onDownPressed: nudge(-1)
    Keys.onUpPressed: nudge(1)

    Row {
        id: headerRow
        visible: root.label.length > 0 || root.showValue || root.leadingIcon.length > 0
        width: parent.width
        height: root._headerH
        spacing: 8

        Md3Icon {
            visible: root.leadingIcon.length > 0
            icon: root.leadingIcon
            size: 20
            iconColor: root.enabled ? Md3Theme.colorScheme.primary
                                    : Md3Theme.colorScheme.disabledContent()
            anchors.verticalCenter: parent.verticalCenter
        }
        Md3Text {
            width: Math.max(0, parent.width
                            - (root.leadingIcon.length > 0 ? 20 + parent.spacing : 0)
                            - valueLabel.implicitWidth - parent.spacing)
            text: root.label
            role: Md3Text.BodyMedium
            tone: Md3Text.OnSurfaceVariant
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
        }
        Md3Text {
            id: valueLabel
            visible: root.showValue
            text: {
                const d = root.stepSize > 0 && root.stepSize >= 1 ? 0 : root.valueDecimals
                return Number(root.value).toFixed(d)
            }
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurface
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Item {
        id: sliderBody
        anchors.left: parent.left
        anchors.right: parent.right
        y: headerRow.visible ? headerRow.height + 4 : 0
        height: root._bodyH

    Item {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Math.max(4, root.handleWidth)
        anchors.rightMargin: Math.max(4, root.handleWidth)
        height: root.trackHeight

        readonly property real handleX: {
            const travel = Math.max(0, width - root.handleWidth)
            return travel * root.progress
        }
        readonly property real activeW: Math.max(0, handleX - root.segmentGap * 0.5)
        readonly property real inactiveX: handleX + root.handleWidth + root.segmentGap * 0.5
        readonly property real inactiveW: Math.max(0, width - inactiveX)

        Rectangle {
            id: inactiveSeg
            x: track.inactiveX
            width: track.inactiveW
            height: parent.height
            radius: height / 2
            color: root.inactiveColor
            visible: width > 0.5
        }

        Rectangle {
            id: activeSeg
            x: 0
            width: track.activeW
            height: parent.height
            radius: height / 2
            color: root.activeColor
            visible: width > 0.5
        }

        Rectangle {
            visible: root.showStopIndicator && !root.discrete && track.inactiveW > 12
            width: 4
            height: 4
            radius: 2
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: Math.max(6, parent.height * 0.35)
            color: root.tickOnInactive
            opacity: root.enabled ? 0.9 : 0.4
        }

        Repeater {
            model: root.tickCount
            delegate: Rectangle {
                required property int index
                readonly property real t: root.tickCount <= 1 ? 0 : index / (root.tickCount - 1)
                readonly property real cx: t * track.width
                readonly property bool onActive: cx < track.handleX + root.handleWidth * 0.5
                width: 3
                height: 3
                radius: 1.5
                visible: Math.abs(cx - (track.handleX + root.handleWidth * 0.5)) > root.handleWidth + 2
                x: cx - width / 2
                y: (track.height - height) / 2
                color: onActive ? root.tickOnActive : root.tickOnInactive
                opacity: root.enabled ? 0.85 : 0.35
            }
        }

        // Thumb: taller than track thickness so it reads as the control, not part of the bar
        Rectangle {
            id: handle
            x: track.handleX
            width: root.handleWidth
            height: root.handleHeight
            radius: width / 2
            anchors.verticalCenter: parent.verticalCenter
            color: root.activeColor
            border.width: 0

            Md3Shadow {
                anchors.fill: parent
                elevation: root.enabled ? 1 : 0
                cornerRadius: handle.radius
            }

            Item {
                anchors.centerIn: parent
                width: 48
                height: 48
                Md3StateOverlay {
                    overlayColor: Md3Theme.colorScheme.primary
                    hovered: mouse.containsMouse
                    focused: root.activeFocus
                    pressed: mouse.pressed
                    controlEnabled: root.enabled
                    radius: 24
                }
            }
        }
    }

    Rectangle {
        parent: sliderBody
        visible: root.showLabel && (mouse.pressed || root.activeFocus)
        anchors.horizontalCenter: track.left
        anchors.horizontalCenterOffset: track.handleX + root.handleWidth / 2
        anchors.bottom: track.top
        anchors.bottomMargin: 8
        width: labelText.implicitWidth + 16
        height: 28
        radius: Md3Theme.shape.extraSmall
        color: Md3Theme.colorScheme.inverseSurface
        Text {
            id: labelText
            anchors.centerIn: parent
            text: Number(root.value).toFixed(stepSize > 0 && stepSize >= 1 ? 0 : 2)
            color: Md3Theme.colorScheme.colorOnInverseSurface
            font.pixelSize: Md3Theme.typography.labelLarge.size
            font.family: Md3Theme.typography.fontFamily
        }
    }

    Md3FocusRing {
        parent: sliderBody
        anchors.centerIn: track
        anchors.horizontalCenterOffset: track.handleX + root.handleWidth / 2 - track.width / 2
        width: 32
        height: Math.max(32, root.handleHeight + 8)
        radius: 16
        focused: root.activeFocus
        controlEnabled: root.enabled
    }

    MouseArea {
        id: mouse
        parent: sliderBody
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: root.enabled
        preventStealing: true
        onPressed: function (mouse) {
            root.forceActiveFocus()
            root.setValue(root.valueAt(mouse.x))
        }
        onPositionChanged: function (mouse) {
            if (pressed)
                root.setValue(root.valueAt(mouse.x))
        }
    }
    } // sliderBody
}

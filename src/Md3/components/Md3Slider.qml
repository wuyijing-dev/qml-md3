import QtQuick

/*
  Material 3 Expressive / Android volume-style slider:
  thick capsule track, active+inactive segments, thin vertical handle,
  continuous end-stop or discrete tick dots.
*/
Item {
    id: root

    property real from: 0
    property real to: 1
    property real value: 0.5
    property real stepSize: 0
    property bool enabled: true
    property bool showLabel: false
    /// Thick capsule height (MD3 expressive ~20)
    property real trackHeight: 20
    property real handleWidth: 10
    property real handleInset: 2
    property real segmentGap: 6
    /// Show end stop on continuous sliders (small terminal dot)
    property bool showStopIndicator: true
    /// Force tick dots; default = stepSize > 0
    property bool discrete: stepSize > 0
    property int maxTickCount: 24
    property string accessibleName: "Slider"

    signal moved(real value)

    height: Math.max(48, trackHeight + 24)
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

    Item {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        height: root.trackHeight

        readonly property real handleX: {
            const travel = Math.max(0, width - root.handleWidth)
            return travel * root.progress
        }
        readonly property real activeW: Math.max(0, handleX - root.segmentGap * 0.5)
        readonly property real inactiveX: handleX + root.handleWidth + root.segmentGap * 0.5
        readonly property real inactiveW: Math.max(0, width - inactiveX)

        // Inactive (right) capsule segment
        Rectangle {
            id: inactiveSeg
            x: track.inactiveX
            width: track.inactiveW
            height: parent.height
            radius: height / 2
            color: root.inactiveColor
            visible: width > 0.5
        }

        // Active (left) capsule segment
        Rectangle {
            id: activeSeg
            x: 0
            width: track.activeW
            height: parent.height
            radius: height / 2
            color: root.activeColor
            visible: width > 0.5
        }

        // Continuous end-stop
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

        // Discrete ticks
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

        // Vertical bar handle (MD3 expressive — wide enough to see between segments)
        Rectangle {
            id: handle
            x: track.handleX
            width: root.handleWidth
            height: Math.max(12, track.height - root.handleInset * 2)
            radius: width / 2
            anchors.verticalCenter: parent.verticalCenter
            color: root.activeColor
            border.width: 2
            border.color: root.enabled ? Md3Theme.colorScheme.colorOnPrimary
                                       : Md3Theme.colorScheme.surface

            Item {
                anchors.centerIn: parent
                width: 44
                height: 44
                Md3StateOverlay {
                    overlayColor: Md3Theme.colorScheme.primary
                    hovered: mouse.containsMouse
                    focused: root.activeFocus
                    pressed: mouse.pressed
                    controlEnabled: root.enabled
                    radius: 22
                }
            }
        }
    }

    Rectangle {
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
        anchors.centerIn: track
        anchors.horizontalCenterOffset: track.handleX + root.handleWidth / 2 - track.width / 2
        width: 28
        height: Math.max(28, root.trackHeight + 12)
        radius: 14
        focused: root.activeFocus
        controlEnabled: root.enabled
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
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
}

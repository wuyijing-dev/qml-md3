import QtQuick

Item {
    id: root

    property bool checked: false
    property bool enabled: true
    property bool showIcon: false
    property string accessibleName: "Switch"

    signal toggled(bool checked)

    width: 52
    height: 48
    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.CheckBox
    Accessible.checkable: true
    Accessible.checked: checked
    Accessible.onToggleAction: toggle()

    function toggle() {
        if (!enabled)
            return
        checked = !checked
        toggled(checked)
    }

    Keys.onSpacePressed: toggle()
    Keys.onReturnPressed: toggle()

    readonly property color trackColor: {
        if (!enabled)
            return checked ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.12)
                           : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.surfaceContainerHighest, 0.12)
        return checked ? Md3Theme.colorScheme.primary
                       : Md3Theme.colorScheme.surfaceContainerHighest
    }
    readonly property color thumbColor: {
        if (!enabled)
            return checked ? Md3Theme.colorScheme.surface
                           : Md3Theme.colorScheme.disabledContent()
        return checked ? Md3Theme.colorScheme.colorOnPrimary
                       : Md3Theme.colorScheme.outline
    }
    /// 0 = off, 1 = on — single driver so position/size stay in sync (avoids snappy dual Behaviors)
    property real thumbProgress: checked ? 1 : 0
    Behavior on thumbProgress {
        NumberAnimation {
            duration: Md3Motion.medium2
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }
    readonly property real thumbSize: 16 + thumbProgress * 8

    Rectangle {
        id: track
        anchors.centerIn: parent
        width: 52
        height: 32
        radius: Md3Theme.shape.full
        color: root.trackColor
        border.width: root.checked || !root.enabled ? 0 : 2
        border.color: root.enabled ? Md3Theme.colorScheme.outline
                                   : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Md3Motion.medium2
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        Behavior on border.width {
            NumberAnimation {
                duration: Md3Motion.medium1
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }

        Md3StateOverlay {
            overlayColor: root.checked ? Md3Theme.colorScheme.colorOnPrimary
                                       : Md3Theme.colorScheme.colorOnSurface
            hovered: mouse.containsMouse
            focused: root.activeFocus
            pressed: mouse.pressed
            controlEnabled: root.enabled
            radius: track.radius
        }

        Rectangle {
            id: thumb
            width: root.thumbSize
            height: root.thumbSize
            radius: width / 2
            color: root.thumbColor
            anchors.verticalCenter: parent.verticalCenter
            x: 4 + root.thumbProgress * (parent.width - width - 8)

            Behavior on color {
                ColorAnimation {
                    duration: Md3Motion.medium2
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }

            Md3Icon {
                anchors.centerIn: parent
                visible: root.showIcon
                icon: root.checked ? "check" : "close"
                size: 16
                iconColor: root.checked ? Md3Theme.colorScheme.primary
                                        : Md3Theme.colorScheme.surfaceContainerHighest
            }
        }
    }

    Md3FocusRing {
        anchors.centerIn: track
        width: track.width + 6
        height: track.height + 6
        radius: Md3Theme.shape.full
        focused: root.activeFocus
        controlEnabled: root.enabled
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        onClicked: {
            root.forceActiveFocus()
            root.toggle()
        }
    }
}

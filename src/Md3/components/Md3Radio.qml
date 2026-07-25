import QtQuick

Item {
    id: root

    property bool checked: false
    property var group: null // optional shared QtObject with property selectedValue
    property var value: null
    property bool enabled: true
    property string accessibleName: "Radio"

    signal clicked()

    width: 48
    height: 48
    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.RadioButton
    Accessible.checkable: true
    Accessible.checked: checked
    Accessible.onToggleAction: select()

    function select() {
        if (!enabled)
            return
        checked = true
        if (group && group.selectedValue !== undefined)
            group.selectedValue = value
        clicked()
    }

    Connections {
        target: root.group
        function onSelectedValueChanged() {
            if (root.group && root.value !== undefined)
                root.checked = (root.group.selectedValue === root.value)
        }
    }

    Keys.onSpacePressed: select()
    Keys.onReturnPressed: select()

    Rectangle {
        anchors.centerIn: parent
        width: 40
        height: 40
        radius: 20
        color: "transparent"
        Md3StateOverlay {
            overlayColor: root.checked ? Md3Theme.colorScheme.primary
                                       : Md3Theme.colorScheme.colorOnSurface
            hovered: mouse.containsMouse
            focused: root.activeFocus
            pressed: mouse.pressed
            controlEnabled: root.enabled
            radius: 20
        }
    }

    Rectangle {
        id: outer
        anchors.centerIn: parent
        width: 20
        height: 20
        radius: 10
        color: "transparent"
        border.width: 2
        border.color: {
            if (!root.enabled)
                return Md3Theme.colorScheme.disabledContent()
            return root.checked ? Md3Theme.colorScheme.primary
                                : Md3Theme.colorScheme.colorOnSurfaceVariant
        }

        Rectangle {
            anchors.centerIn: parent
            width: root.checked ? 10 : 0
            height: width
            radius: width / 2
            color: root.enabled ? Md3Theme.colorScheme.primary
                                : Md3Theme.colorScheme.disabledContent()

            Behavior on width {
                NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }
        }
    }

    Md3FocusRing {
        anchors.centerIn: parent
        width: 46
        height: 46
        radius: 23
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
            root.select()
        }
    }
}

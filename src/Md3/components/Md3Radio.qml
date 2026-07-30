import QtQuick

Md3SelectionControl {
    id: root

    property var group: null
    property var value: null
    accessibleName: text.length ? text : qsTr("Radio")
    accessibleRole: Accessible.RadioButton
    labelRole: Md3Text.BodyLarge
    onActivated: select()

    signal clicked()

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

    Item {
        id: radioChrome
        width: 48
        height: 48
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            anchors.centerIn: parent
            width: 40
            height: 40
            radius: 20
            color: "transparent"
            Md3StateOverlay {
                overlayColor: root.checked ? Md3Theme.colorScheme.primary
                                           : Md3Theme.colorScheme.colorOnSurface
                hovered: root.hovered
                focused: root.activeFocus
                pressed: root.pressed
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
    }
}

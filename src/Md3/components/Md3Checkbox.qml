import QtQuick

Md3SelectionControl {
    id: root

    property bool tristate: false
    property var checkState: checked ? Qt.Checked : Qt.Unchecked
    accessibleName: text.length ? text : "Checkbox"
    accessibleRole: Accessible.CheckBox
    labelRole: Md3Text.BodyLarge
    onActivated: cycle()

    signal toggled(var state)

    readonly property bool isChecked: checkState === Qt.Checked
    readonly property bool isPartial: checkState === Qt.PartiallyChecked
    readonly property bool selected: isChecked || isPartial

    function cycle() {
        if (!enabled)
            return
        if (tristate) {
            if (checkState === Qt.Unchecked)
                checkState = Qt.Checked
            else if (checkState === Qt.Checked)
                checkState = Qt.PartiallyChecked
            else
                checkState = Qt.Unchecked
        } else {
            checked = !checked
            checkState = checked ? Qt.Checked : Qt.Unchecked
        }
        checked = checkState === Qt.Checked
        toggled(checkState)
    }

    onCheckedChanged: {
        if (!tristate)
            checkState = checked ? Qt.Checked : Qt.Unchecked
    }

    Item {
        id: boxChrome
        width: 48
        height: 48
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: stateLayer
            anchors.centerIn: parent
            width: 40
            height: 40
            radius: width / 2
            color: "transparent"

            Md3StateOverlay {
                overlayColor: root.selected ? Md3Theme.colorScheme.primary
                                            : Md3Theme.colorScheme.colorOnSurface
                hovered: root.hovered
                focused: root.activeFocus
                pressed: root.pressed
                controlEnabled: root.enabled
                radius: stateLayer.radius
            }
        }

        Rectangle {
            id: box
            anchors.centerIn: parent
            width: 18
            height: 18
            radius: 2
            color: {
                if (!root.enabled && root.selected)
                    return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.38)
                if (root.selected)
                    return Md3Theme.colorScheme.primary
                return "transparent"
            }
            border.width: root.selected ? 0 : 2
            border.color: {
                if (!root.enabled)
                    return Md3Theme.colorScheme.disabledContent()
                return Md3Theme.colorScheme.colorOnSurfaceVariant
            }

            Behavior on color {
                ColorAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.uiEffects
                }
            }

            Canvas {
                id: mark
                anchors.fill: parent
                anchors.margins: 2
                opacity: root.isChecked ? 1 : 0
                onPaint: {
                    const ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.strokeStyle = root.enabled ? Md3Theme.colorScheme.colorOnPrimary
                                                   : Md3Theme.colorScheme.surface
                    ctx.lineWidth = 2
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"
                    ctx.beginPath()
                    ctx.moveTo(width * 0.15, height * 0.5)
                    ctx.lineTo(width * 0.4, height * 0.75)
                    ctx.lineTo(width * 0.85, height * 0.25)
                    ctx.stroke()
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: 10
                height: 2
                radius: 1
                color: root.enabled ? Md3Theme.colorScheme.colorOnPrimary : Md3Theme.colorScheme.surface
                opacity: root.isPartial ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
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

    onIsCheckedChanged: mark.requestPaint()
    onEnabledChanged: mark.requestPaint()
    Component.onCompleted: mark.requestPaint()
}

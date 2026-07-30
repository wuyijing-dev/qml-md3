import QtQuick
import Md3

Item {
    id: root

    property string text: ""
    property string label: qsTr("Select")
    property string leadingIcon: ""
    property var model: []
    property int currentIndex: -1
    readonly property bool open: menu.open

    signal activated(int index)
    signal opened()
    signal closed()

    width: 280
    height: 56

    Accessible.role: Accessible.PopupMenu
    Accessible.name: label.length ? label : (text.length ? text : qsTr("Dropdown menu"))

    readonly property string displayText: {
        if (currentIndex >= 0 && currentIndex < model.length) {
            const m = model[currentIndex]
            return m.text !== undefined ? m.text : String(m)
        }
        return text
    }

    function toggle() {
        if (!enabled)
            return
        if (menu.open)
            menu.dismiss()
        else
            openMenu()
    }

    function openMenu() {
        if (!enabled)
            return
        const p = field.mapToItem(null, 0, field.height + 4)
        menu.menuWidth = field.width
        menu.popup(p.x, p.y)
        root.opened()
    }

    Rectangle {
        id: field
        anchors.fill: parent
        radius: Md3Theme.shape.extraSmall
        color: "transparent"
        border.width: menu.open || mouse.containsMouse ? 2 : 1
        border.color: {
            if (!root.enabled)
                return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.12)
            if (menu.open)
                return Md3Theme.colorScheme.primary
            return Md3Theme.colorScheme.outline
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Md3Motion.short3
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.uiEffects
            }
        }
        Behavior on border.width {
            NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
        }

        Md3StateOverlay {
            overlayColor: Md3Theme.colorScheme.colorOnSurface
            hovered: mouse.containsMouse
            pressed: mouse.pressed
            controlEnabled: root.enabled
            radius: field.radius
        }

        Text {
            id: labelItem
            text: root.label
            x: 12
            y: root.displayText.length > 0 || menu.open ? -height / 2 : (parent.height - height) / 2
            z: 2
            color: menu.open ? Md3Theme.colorScheme.primary : Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: (root.displayText.length > 0 || menu.open)
                            ? Md3Theme.typography.labelSmall.size
                            : Md3Theme.typography.bodyLarge.size
            font.weight: (root.displayText.length > 0 || menu.open) ? Font.Medium : Font.Normal

            Behavior on y {
                NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }
            Behavior on font.pixelSize {
                NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }

            Rectangle {
                visible: root.displayText.length > 0 || menu.open
                anchors.centerIn: parent
                width: parent.width + 8
                height: 6
                color: Md3Theme.colorScheme.surface
                z: -1
            }
        }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 8
            spacing: 12

            Md3Icon {
                visible: root.leadingIcon.length > 0
                icon: root.leadingIcon
                size: 24
                iconColor: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                        : Md3Theme.colorScheme.disabledContent()
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - (root.leadingIcon.length > 0 ? 36 : 0) - 40
                text: root.displayText
                elide: Text.ElideRight
                color: root.enabled ? Md3Theme.colorScheme.colorOnSurface
                                    : Md3Theme.colorScheme.disabledContent()
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyLarge.size
                opacity: root.displayText.length > 0 ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
                }
            }

            Md3Icon {
                icon: "expand_more"
                size: 24
                iconColor: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                        : Md3Theme.colorScheme.disabledContent()
                anchors.verticalCenter: parent.verticalCenter
                rotation: menu.open ? 180 : 0
                Behavior on rotation {
                    NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
                }
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: field
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.toggle()
    }

    Md3Menu {
        id: menu
        modal: true
        onOpenChanged: {
            if (!open)
                root.closed()
        }

        Repeater {
            model: root.model
            Md3MenuItem {
                required property int index
                required property var modelData
                width: Math.max(menu.menuWidth, 168)
                text: modelData.text !== undefined ? modelData.text : String(modelData)
                icon: modelData.icon !== undefined ? modelData.icon : ""
                selected: root.currentIndex === index
                showCheck: true
                leadingCheck: false
                onClicked: {
                    root.currentIndex = index
                    root.text = text
                    root.activated(index)
                    menu.dismiss()
                }
            }
        }
    }
}

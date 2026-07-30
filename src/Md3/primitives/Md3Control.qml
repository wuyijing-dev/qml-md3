import QtQuick
import Md3

Item {
    id: root

    property bool hovered: mouse.containsMouse
    property bool pressed: mouse.pressed
    property bool focused: activeFocus
    property bool controlEnabled: enabled
    property string accessibleName: ""
    property string accessibleRole: "button"
    property real visualDensity: 0
    property color stateColor: Md3Theme.colorScheme.colorOnSurface
    property bool showRipple: true
    property real controlRadius: 0

    signal clicked()
    signal pressAndHold()

    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button
    Accessible.onPressAction: if (enabled) root.clicked()

    Keys.onReturnPressed: if (enabled) root.clicked()
    Keys.onEnterPressed: if (enabled) root.clicked()
    Keys.onSpacePressed: if (enabled) root.clicked()

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: root.enabled
        onClicked: mouse => {
            if (root.showRipple)
                ripple.pulse(mouse.x, mouse.y)
            root.forceActiveFocus()
            root.clicked()
        }
        onPressAndHold: root.pressAndHold()
    }

    Md3Ripple {
        id: ripple
        rippleColor: root.stateColor
        clipRadius: root.controlRadius
    }

    Md3StateOverlay {
        overlayColor: root.stateColor
        hovered: root.hovered
        focused: root.focused
        pressed: root.pressed
        controlEnabled: root.controlEnabled
        radius: root.controlRadius
    }

    Md3FocusRing {
        anchors.fill: parent
        anchors.margins: -3
        focused: root.focused
        controlEnabled: root.controlEnabled
        visualFocus: false
        radius: root.controlRadius + 3
    }
}

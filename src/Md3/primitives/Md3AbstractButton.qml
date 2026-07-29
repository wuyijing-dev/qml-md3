import QtQuick

/// Shared pressable base for Md3Button / IconButton / FAB / Chip.
/// Subclasses set `contentColor`, `containerColor`, `cornerRadius`, `pressTarget`,
/// and handle `onPressFeedback` to pulse their Md3Ripple.
Item {
    id: root

    property string text: ""
    property string icon: ""
    property string accessibleName: text.length ? text : (icon.length ? icon : qsTr("Button"))
    property int accessibleRole: Accessible.Button
    /// Keyboard focus ring — set true on Tab / arrow keys; cleared on mouse click.
    property bool visualFocus: false
    property color contentColor: Md3Theme.colorScheme.colorOnSurface
    property color containerColor: "transparent"
    property real cornerRadius: 0
    /// Coordinate space for pressFeedback (usually the painted background item).
    property Item pressTarget: root
    /// When true, Space/Enter/click toggle `checked` before emitting clicked.
    property bool checkable: false
    property bool checked: false

    /// When false, the built-in MouseArea ignores presses (custom hit areas).
    property bool pressEnabled: true
    property real pressRightMargin: 0
    property real pressLeftMargin: 0

    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed

    signal clicked()
    signal toggled(bool checked)
    /// Map click into `pressTarget` so subclasses can `ripple.pulse(x, y)`.
    signal pressFeedback(real x, real y)

    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: accessibleRole
    Accessible.checkable: checkable
    Accessible.checked: checked
    Accessible.onPressAction: if (enabled) root.activate(true)

    function activate(fromKeyboard) {
        if (!enabled)
            return
        if (fromKeyboard)
            visualFocus = true
        if (checkable) {
            checked = !checked
            toggled(checked)
        }
        clicked()
    }

    function markKeyboardFocus() {
        visualFocus = true
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab
                || event.key === Qt.Key_Left || event.key === Qt.Key_Right
                || event.key === Qt.Key_Up || event.key === Qt.Key_Down)
            root.visualFocus = true
    }
    Keys.onReturnPressed: if (enabled) activate(true)
    Keys.onEnterPressed: if (enabled) activate(true)
    Keys.onSpacePressed: if (enabled) activate(true)

    MouseArea {
        id: mouse
        anchors.fill: parent
        anchors.leftMargin: root.pressLeftMargin
        anchors.rightMargin: root.pressRightMargin
        hoverEnabled: true
        enabled: root.enabled && root.pressEnabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: function (ev) {
            root.visualFocus = false
            const target = root.pressTarget ? root.pressTarget : root
            const local = mapToItem(target, ev.x, ev.y)
            root.pressFeedback(local.x, local.y)
            root.forceActiveFocus()
            root.activate(false)
        }
    }
}

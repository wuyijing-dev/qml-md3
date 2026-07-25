import QtQuick

Rectangle {
    id: root
    // Keyboard focus only — never show a ring from mouse press.
    radius: 8
    color: "transparent"
    border.width: visible ? 2 : 0
    border.color: Md3Theme.colorScheme.secondary
    visible: focused && controlEnabled && visualFocus
    z: 100

    property bool focused: false
    property bool controlEnabled: true
    property bool visualFocus: false
}

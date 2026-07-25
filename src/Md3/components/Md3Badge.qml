import QtQuick

Item {
    id: root

    property string text: ""
    property bool dot: false
    property color badgeColor: Md3Theme.colorScheme.error
    property color labelColor: Md3Theme.colorScheme.colorOnError

    readonly property bool large: !dot && text.length > 0

    implicitWidth: large ? Math.max(16, label.implicitWidth + 8) : 6
    implicitHeight: large ? 16 : 6
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: Md3Theme.shape.full
        color: root.badgeColor

        Text {
            id: label
            anchors.centerIn: parent
            visible: root.large
            text: root.text
            color: root.labelColor
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelSmall.size
            font.weight: Md3Theme.typography.labelSmall.weight
        }
    }
}

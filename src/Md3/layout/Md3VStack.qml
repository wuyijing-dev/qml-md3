import QtQuick

/// Vertical stack with spacing/padding and optional fill width.
Item {
    id: root

    property real spacing: 8
    property real padding: 0
    property bool fillWidth: true
    property bool clipContent: false
    default property alias content: contentCol.data

    implicitWidth: Math.max(1, contentCol.implicitWidth + padding * 2)
    implicitHeight: contentCol.implicitHeight + padding * 2

    Column {
        id: contentCol
        clip: root.clipContent
        x: root.padding
        y: root.padding
        width: root.fillWidth ? Math.max(0, root.width - root.padding * 2) : implicitWidth
        spacing: root.spacing
    }
}

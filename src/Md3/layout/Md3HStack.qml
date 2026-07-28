import QtQuick

/// Horizontal stack with spacing/padding and optional fill height.
Item {
    id: root

    property real spacing: 8
    property real padding: 0
    property bool fillHeight: false
    property bool clipContent: false
    default property alias content: contentRow.data

    implicitWidth: contentRow.implicitWidth + padding * 2
    implicitHeight: Math.max(1, contentRow.implicitHeight + padding * 2)

    Row {
        id: contentRow
        clip: root.clipContent
        x: root.padding
        y: root.padding
        height: root.fillHeight ? Math.max(0, root.height - root.padding * 2) : implicitHeight
        spacing: root.spacing
    }
}

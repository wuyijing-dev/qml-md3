import QtQuick

/// Wrapping flow layout with padding and row spacing.
Item {
    id: root

    property real spacing: 8
    property real rowSpacing: 8
    property real padding: 0
    property bool fillWidth: true
    default property alias content: flow.data

    implicitWidth: Math.max(1, flow.implicitWidth + padding * 2)
    implicitHeight: flow.implicitHeight + padding * 2
    width: fillWidth && parent ? parent.width : implicitWidth

    Flow {
        id: flow
        x: root.padding
        y: root.padding
        width: root.fillWidth ? Math.max(0, root.width - root.padding * 2) : implicitWidth
        spacing: root.spacing

        // Qt Quick Flow does not expose dedicated row spacing; emulate by margins in delegates
        // is noisy, so we apply a simple extra baseline via top/bottom padding to keep rhythm.
        topPadding: root.rowSpacing * 0.5
        bottomPadding: root.rowSpacing * 0.5
    }
}

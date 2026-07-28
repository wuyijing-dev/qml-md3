import QtQuick

Item {
    id: root

    enum LayoutMode { Fit, Scroll }

    property int layoutMode: Md3AdaptiveContainer.Fit
    property real padding: 0
    property bool clipContent: true
    property real contentSpacing: 12
    default property alias content: contentColumn.data

    implicitWidth: Math.max(280, contentColumn.implicitWidth + padding * 2)
    implicitHeight: layoutMode === Md3AdaptiveContainer.Fit
                    ? contentColumn.implicitHeight + padding * 2
                    : 320

    Flickable {
        id: flick
        anchors.fill: parent
        clip: root.clipContent
        contentWidth: width
        contentHeight: contentColumn.implicitHeight + root.padding * 2
        interactive: root.layoutMode === Md3AdaptiveContainer.Scroll
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: contentColumn
            x: root.padding
            y: root.padding
            width: Math.max(0, flick.width - root.padding * 2)
            spacing: root.contentSpacing
        }
    }
}

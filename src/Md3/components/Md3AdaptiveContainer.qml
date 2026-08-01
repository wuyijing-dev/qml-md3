import QtQuick
import Md3

/// Standalone column-stacking adaptive container (gallery / direct use).
/// Md3 container components embed `Md3ContainerBody` and expose `layoutMode` directly.
/// Uses Md3VStack (HeightSync) instead of bare Column to avoid Qt 6.8 height-collapse overlaps.
Item {
    id: root

    enum LayoutMode { Fit, Scroll }

    property int layoutMode: Md3AdaptiveContainer.Fit
    property real padding: 0
    property bool clipContent: true
    property real contentSpacing: 12
    default property alias content: contentStack.content

    implicitWidth: Math.max(280, body.contentImplicitWidth + padding * 2)
    implicitHeight: layoutMode === Md3AdaptiveContainer.Fit
                    ? body.contentImplicitHeight + padding * 2
                    : 320

    Md3ContainerBody {
        id: body
        anchors.fill: parent
        layoutMode: root.layoutMode
        padding: root.padding
        clipContent: root.clipContent

        Md3VStack {
            id: contentStack
            width: parent.width
            spacing: root.contentSpacing
            fillWidth: true
        }
    }
}

import QtQuick

/// Fit / Scroll content host embedded by Md3 container components.
Item {
    id: root

    enum LayoutMode { Fit, Scroll }

    property int layoutMode: Md3ContainerBody.Fit
    property real padding: 0
    property bool clipContent: true

    default property alias content: contentHost.data

    readonly property alias contentHost: contentHost
    readonly property real contentImplicitWidth: contentHost.implicitWidth
    readonly property real contentImplicitHeight: contentHost.implicitHeight

    implicitWidth: Math.max(1, contentImplicitWidth + padding * 2)
    implicitHeight: layoutMode === Md3ContainerBody.Fit
                    ? contentImplicitHeight + padding * 2
                    : (height > 0 ? height : 320)

    Flickable {
        id: flick
        anchors.fill: parent
        clip: root.clipContent
        contentWidth: width
        contentHeight: contentImplicitHeight + root.padding * 2
        interactive: root.layoutMode === Md3ContainerBody.Scroll
                     && contentHeight > height + 1
        boundsBehavior: Flickable.StopAtBounds

        Item {
            id: contentHost
            x: root.padding
            y: root.padding
            width: Math.max(0, flick.width - root.padding * 2)
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}

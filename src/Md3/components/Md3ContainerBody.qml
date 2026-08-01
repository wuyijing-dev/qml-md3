import QtQuick
import Md3

/// Fit / Scroll content host embedded by Md3 container components.
Item {
    id: root

    enum LayoutMode { Fit, Scroll }

    property int layoutMode: Md3ContainerBody.Fit
    property real padding: 0
    property bool clipContent: true
    property real fitFallbackHeight: 320

    default property alias content: contentHost.data

    readonly property alias contentHost: contentHost
    readonly property real contentImplicitWidth: contentHost.childrenRect.width
    readonly property bool hasParentFillChild: _hasParentFillChild()
    readonly property real contentImplicitHeight: _measureContentHeight()

    function _hasParentFillChild() {
        const kids = contentHost.children
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false || !c.anchors)
                continue
            if (c.anchors.fill === contentHost)
                return true
            if (c.anchors.top === contentHost && c.anchors.bottom === contentHost)
                return true
        }
        return false
    }

    function _measureContentHeight() {
        // If child uses anchors.fill parent, deriving implicit height from childrenRect
        // creates a feedback loop (parent implicitHeight -> child height -> childrenRect).
        if (hasParentFillChild)
            return 0
        return contentHost.childrenRect.height
    }

    implicitWidth: Math.max(1, contentImplicitWidth + padding * 2)
    implicitHeight: layoutMode === Md3ContainerBody.Fit
                    ? (hasParentFillChild
                       ? fitFallbackHeight
                       : contentImplicitHeight + padding * 2)
                    : 320

    Flickable {
        id: flick
        anchors.fill: parent
        clip: root.clipContent
        contentWidth: width
        contentHeight: {
            const intrinsic = contentImplicitHeight + root.padding * 2
            // Do not fold flick.height into contentHeight — fights parent height bindings.
            return Math.max(intrinsic, 1)
        }
        interactive: root.layoutMode === Md3ContainerBody.Scroll
                     && contentHeight > height + 1
        boundsBehavior: Flickable.StopAtBounds

        // Give Fit-mode content a real viewport height so nested expand/fill children
        // (Card body lists, etc.) are not stuck at height 0 inside the Flickable host.
        Item {
            id: contentHost
            x: root.padding
            y: root.padding
            width: Math.max(0, flick.width - root.padding * 2)
            height: {
                if (root.layoutMode === Md3ContainerBody.Scroll)
                    return Math.max(childrenRect.height, 1)
                const viewH = Math.max(0, flick.height - root.padding * 2)
                if (viewH > 1)
                    return viewH
                return Math.max(childrenRect.height, 1)
            }
        }
    }
}

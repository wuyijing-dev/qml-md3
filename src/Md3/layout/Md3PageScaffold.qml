import QtQuick
import Md3

/// Page chrome: fixed header, body (scroll or fit), optional sticky footer.
Item {
    id: root

    property alias header: headerSlot.data
    property alias stickyFooter: footerSlot.data
    default property alias body: bodySlot.data
    /// When true (default), body is an ``Md3ScrollView`` between header and footer.
    property bool scrollBody: true
    property real verticalScrollbarGutter: 0

    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Page")

    Item {
        id: headerSlot
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: children.length ? Math.max(1, childrenRect.height) : 0
        clip: true
    }

    Item {
        id: footerSlot
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: children.length ? Math.max(1, childrenRect.height) : 0
        z: 2
        clip: true
    }

    Md3ScrollView {
        id: scroller
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerSlot.bottom
        anchors.bottom: footerSlot.top
        visible: root.scrollBody
        verticalScrollbarGutter: root.verticalScrollbarGutter

        Item {
            id: scrollBodyHost
            width: scroller.contentAvailableWidth
            height: Math.max(1, bodySlot.implicitHeight, bodySlot.childrenRect.height)

            Item {
                id: bodySlot
                width: parent.width
                height: Math.max(1, childrenRect.height)
                implicitHeight: childrenRect.height
            }
        }
    }

    Item {
        id: fitHost
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerSlot.bottom
        anchors.bottom: footerSlot.top
        visible: !root.scrollBody

        // When Fit: bodySlot is reparented here so children fill the pane.
    }

    onScrollBodyChanged: Qt.callLater(_syncBodyParent)
    Component.onCompleted: Qt.callLater(_syncBodyParent)

    function _syncBodyParent() {
        if (root.scrollBody) {
            bodySlot.parent = scrollBodyHost
            bodySlot.anchors.fill = undefined
            bodySlot.width = Qt.binding(function () { return scrollBodyHost.width })
            bodySlot.height = Qt.binding(function () {
                return Math.max(1, bodySlot.childrenRect.height)
            })
        } else {
            bodySlot.parent = fitHost
            bodySlot.anchors.fill = fitHost
        }
    }
}

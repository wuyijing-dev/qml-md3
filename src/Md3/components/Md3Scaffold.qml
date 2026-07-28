import QtQuick

Item {
    id: root

    property alias appBar: appBarSlot.data
    property alias navigationBar: navBarSlot.data
    property alias fab: fabSlot.data
    property alias drawer: drawerSlot.data
    property int layoutMode: Md3ContainerBody.Fit
    default property alias content: body.content

    Rectangle {
        anchors.fill: parent
        color: Md3Theme.colorScheme.surface
    }

    Item {
        id: drawerSlot
        anchors.fill: parent
        z: 10
    }

    Column {
        anchors.fill: parent

        Item {
            id: appBarSlot
            width: parent.width
            height: children.length ? children[0].height : 0
        }

        Md3ContainerBody {
            id: body
            width: parent.width
            height: parent.height - appBarSlot.height - navBarSlot.height
            layoutMode: root.layoutMode
        }

        Item {
            id: navBarSlot
            width: parent.width
            height: children.length ? children[0].height : 0
        }
    }

    Item {
        id: fabSlot
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 16
        anchors.bottomMargin: 16 + navBarSlot.height
        width: childrenRect.width
        height: childrenRect.height
        z: 5
    }
}

import QtQuick
import Md3

/// App shell: optional built-in TopAppBar / NavigationBar / Drawer from props,
/// or custom slots (`appBar:`, `navigationBar:`, `drawer:`, `fab:`).
Item {
    id: root

    clip: true

    /// Convenience: materialize Md3TopAppBar when set (and appBar slot empty).
    property string title: ""
    property string leadingIcon: "menu"
    property bool showLeading: true
    property var trailingIcons: []
    /// Convenience: materialize Md3NavigationBar when non-empty (and navigationBar slot empty).
    property var navigationBarModel: []
    property alias navModel: root.navigationBarModel
    property int navigationBarIndex: 0
    /// Convenience: materialize Md3NavigationDrawer when non-empty (and drawer slot empty).
    property var drawerModel: []
    property string drawerTitle: ""
    property bool drawerOpen: false

    property alias appBar: appBarSlot.data
    property alias navigationBar: navBarSlot.data
    property alias fab: fabSlot.data
    property alias drawer: drawerSlot.data
    property int layoutMode: Md3ContainerBody.Fit
    default property alias content: body.content

    signal leadingClicked()
    signal trailingClicked(int index)
    signal navigationBarIndexChangedByUser(int index)
    signal drawerIndexChangedByUser(int index)

    readonly property bool _useBuiltinAppBar: (title.length > 0 || trailingIcons.length > 0)
                                              && appBarSlot.children.length === 0
    readonly property bool _useBuiltinNavBar: navigationBarModel && navigationBarModel.length > 0
                                              && navBarSlot.children.length === 0
    readonly property bool _useBuiltinDrawer: drawerModel && drawerModel.length > 0
                                              && drawerSlot.children.length === 0

    function openDrawer() { drawerOpen = true }
    function closeDrawer() { drawerOpen = false }

    Rectangle {
        anchors.fill: parent
        color: Md3Theme.colorScheme.surface
    }

    Item {
        id: drawerSlot
        anchors.fill: parent
        z: 10
    }

    Md3NavigationDrawer {
        id: builtinDrawer
        anchors.fill: parent
        z: 11
        visible: root._useBuiltinDrawer
        title: root.drawerTitle
        model: root.drawerModel
        open: root.drawerOpen
        onOpenChanged: root.drawerOpen = open
        onCurrentIndexChangedByUser: function (index) {
            root.drawerIndexChangedByUser(index)
        }
    }

    Column {
        anchors.fill: parent

        Item {
            id: appBarHost
            width: parent.width
            height: {
                if (appBarSlot.children.length > 0)
                    return appBarSlot.children[0].height
                return builtinAppBar.visible ? builtinAppBar.height : 0
            }

            Item {
                id: appBarSlot
                anchors.fill: parent
            }

            Md3TopAppBar {
                id: builtinAppBar
                width: parent.width
                visible: root._useBuiltinAppBar
                title: root.title
                leadingIcon: root.leadingIcon
                showLeading: root.showLeading
                trailingIcons: root.trailingIcons
                onLeadingClicked: {
                    if (root._useBuiltinDrawer || root.drawerModel.length > 0)
                        root.drawerOpen = true
                    root.leadingClicked()
                }
                onTrailingClicked: function (index) { root.trailingClicked(index) }
            }
        }

        Md3ContainerBody {
            id: body
            width: parent.width
            height: parent.height - appBarHost.height - navBarHost.height
            layoutMode: root.layoutMode
        }

        Item {
            id: navBarHost
            width: parent.width
            height: {
                if (navBarSlot.children.length > 0)
                    return navBarSlot.children[0].height
                return builtinNavBar.visible ? builtinNavBar.height : 0
            }

            Item {
                id: navBarSlot
                anchors.fill: parent
            }

            Md3NavigationBar {
                id: builtinNavBar
                width: parent.width
                visible: root._useBuiltinNavBar
                model: root.navigationBarModel
                currentIndex: root.navigationBarIndex
                onCurrentIndexChangedByUser: function (index) {
                    root.navigationBarIndex = index
                    root.navigationBarIndexChangedByUser(index)
                }
            }
        }
    }

    Item {
        id: fabSlot
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 16
        anchors.bottomMargin: 16 + navBarHost.height
        width: childrenRect.width
        height: childrenRect.height
        z: 5
    }
}

import QtQuick
import Md3

/// Page title row with optional subtitle and trailing actions (overflow on narrow width).
///
/// **Children go to the actions row** (`default property` → `actions`). Do not wrap
/// this in another Item that aliases `pageHeader.data`.
Item {
    id: root

    property string title: ""
    property string subtitle: ""
    default property alias actions: actionsRow.data
    property real actionsMaxWidth: Math.max(120, width * 0.55)
    property bool overflowEnabled: true
    property string overflowIcon: "more_vert"

    signal overflowClicked()

    implicitHeight: Math.max(titleCol.implicitHeight, actionsHost.implicitHeight, 40)
    implicitWidth: 200
    height: implicitHeight

    readonly property bool _overflow: {
        void actionsRow.children.length
        void root.width
        if (!overflowEnabled || root.width < 1)
            return false
        return actionsRow.implicitWidth > root.actionsMaxWidth + 0.5
    }

    function _overflowModel() {
        const kids = actionsRow.children
        const out = []
        for (let i = 0; i < kids.length; ++i) {
            const src = kids[i]
            if (!src || src.visible === false)
                continue
            const label = (src.text !== undefined && String(src.text).length)
                          ? String(src.text)
                          : (src.accessibleName !== undefined ? String(src.accessibleName)
                             : (src.icon !== undefined ? String(src.icon) : qsTr("Action")))
            out.push({
                text: label,
                enabled: src.enabled !== false,
                _index: i
            })
        }
        return out
    }

    function _activateOverflowIndex(menuIndex) {
        const rows = overflowMenu.model
        if (!rows || menuIndex < 0 || menuIndex >= rows.length)
            return
        const srcIndex = rows[menuIndex]._index
        const src = actionsRow.children[srcIndex]
        if (!src)
            return
        if (typeof src.clicked === "function")
            src.clicked()
        else if (src.clicked)
            src.clicked()
    }

    Column {
        id: titleCol
        anchors.left: parent.left
        anchors.right: actionsHost.left
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        Md3Text {
            width: parent.width
            text: root.title
            role: Md3Text.TitleLarge
            elide: Text.ElideRight
            visible: root.title.length > 0
        }
        Md3Text {
            width: parent.width
            text: root.subtitle
            role: Md3Text.BodyMedium
            tone: Md3Text.OnSurfaceVariant
            elide: Text.ElideRight
            visible: root.subtitle.length > 0
        }
    }

    Item {
        id: actionsHost
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: root._overflow ? overflowBtn.implicitWidth
                              : Math.min(actionsRow.implicitWidth, root.actionsMaxWidth)
        height: Math.max(actionsRow.implicitHeight, overflowBtn.implicitHeight, 40)
        clip: !root._overflow

        Row {
            id: actionsRow
            spacing: 8
            visible: !root._overflow
            height: implicitHeight
        }

        Md3IconButton {
            id: overflowBtn
            visible: root._overflow
            icon: root.overflowIcon
            accessibleName: qsTr("More actions")
            onClicked: {
                overflowMenu.model = root._overflowModel()
                overflowMenu.rebuildFromModel()
                overflowMenu.open = true
                root.overflowClicked()
            }
        }

        Md3Menu {
            id: overflowMenu
            onItemClicked: function (path) {
                // path is menu item text for model-built menus
                const rows = overflowMenu.model
                for (let i = 0; i < rows.length; ++i) {
                    if (String(rows[i].text) === String(path)) {
                        root._activateOverflowIndex(i)
                        return
                    }
                }
            }
        }
    }
}

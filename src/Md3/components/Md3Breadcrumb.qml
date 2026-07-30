import QtQuick
import Md3

/// Horizontal breadcrumb trail. model: ["Home","Folder"] or [{ title, icon? }, ...]
Item {
    id: root

    property var model: []
    property int maxVisible: 6
    property real spacing: 4
    property real fontSize: Md3Theme.typography.labelLarge.size

    signal crumbClicked(int index)

    implicitHeight: 32
    implicitWidth: row.implicitWidth
    height: implicitHeight

    readonly property var _items: {
        const m = model || []
        const out = []
        for (let i = 0; i < m.length; ++i) {
            const it = m[i]
            if (typeof it === "string")
                out.push({ title: it, icon: "" })
            else if (it && it.title !== undefined)
                out.push({ title: String(it.title), icon: it.icon ? String(it.icon) : "" })
        }
        return out
    }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.spacing

        Repeater {
            model: root._items.length

            Row {
                id: crumbRow
                required property int index
                spacing: root.spacing

                readonly property var modelData: root._items[index]
                readonly property bool collapsedGap: {
                    const n = root._items.length
                    return n > root.maxVisible && index === 1
                }
                readonly property bool hiddenByCollapse: {
                    const n = root._items.length
                    if (n <= root.maxVisible)
                        return false
                    // Keep first + last (maxVisible-1); hide middle except index 1 (ellipsis)
                    if (index === 0 || index >= n - (root.maxVisible - 1))
                        return false
                    return index !== 1
                }
                readonly property bool isLast: index === root._items.length - 1

                visible: !hiddenByCollapse

                Md3Icon {
                    visible: index > 0
                    anchors.verticalCenter: parent.verticalCenter
                    icon: "chevron_right"
                    size: 16
                    iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                }

                Md3Text {
                    visible: crumbRow.collapsedGap
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("…")
                    role: Md3Text.LabelLarge
                    tone: Md3Text.OnSurfaceVariant
                    font.pixelSize: root.fontSize
                }

                Md3AbstractButton {
                    id: crumb
                    visible: !crumbRow.collapsedGap
                    height: 28
                    width: crumbLabel.implicitWidth + (modelData.icon.length > 0 ? 22 : 12)
                    anchors.verticalCenter: parent.verticalCenter
                    accessibleName: modelData.title
                    pressEnabled: !crumbRow.isLast
                    onClicked: root.crumbClicked(index)
                    onPressFeedback: function (x, y) { }

                    Row {
                        anchors.centerIn: parent
                        spacing: 4
                        Md3Icon {
                            visible: modelData.icon.length > 0
                            anchors.verticalCenter: parent.verticalCenter
                            icon: modelData.icon
                            size: 16
                            iconColor: crumbRow.isLast ? Md3Theme.colorScheme.colorOnSurface
                                                       : Md3Theme.colorScheme.primary
                        }
                        Md3Text {
                            id: crumbLabel
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.title
                            role: Md3Text.LabelLarge
                            tone: Md3Text.Custom
                            customColor: crumbRow.isLast ? Md3Theme.colorScheme.colorOnSurface
                                                         : Md3Theme.colorScheme.primary
                            font.pixelSize: root.fontSize
                            font.weight: crumbRow.isLast ? Font.Medium : Font.Normal
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: Md3Theme.shape.extraSmall
                        color: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.08)
                        visible: crumb.hovered && !crumbRow.isLast
                    }
                }
            }
        }
    }
}

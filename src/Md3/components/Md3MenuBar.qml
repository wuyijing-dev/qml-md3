import QtQuick

Rectangle {
    id: root

    property var model: [] // [{ text, children?: [{text, icon?}] }]
    signal itemClicked(string path)

    height: 48
    width: parent ? parent.width : 400
    color: Md3Theme.colorScheme.surfaceContainer

    Row {
        id: row
        anchors.fill: parent
        anchors.leftMargin: 8
        spacing: 0

        Repeater {
            model: root.model
            delegate: Item {
                id: dest
                required property int index
                required property var modelData

                readonly property string title: modelData.text !== undefined ? modelData.text : String(modelData)
                readonly property var childrenModel: modelData.children !== undefined ? modelData.children
                                                    : [{ text: "Action" }]

                width: label.implicitWidth + 24
                height: parent.height

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: Md3Theme.shape.small
                    color: menu.open && menu.anchorIndex === dest.index
                           ? Md3Theme.colorScheme.secondaryContainer
                           : (mouse.containsMouse ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.08)
                                                  : "transparent")
                    Behavior on color {
                        ColorAnimation {
                            duration: Md3Motion.short2
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Md3Motion.standard
                        }
                    }
                }

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: dest.title
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        menu.anchorIndex = dest.index
                        menu.menuWidth = Math.max(168, dest.width)
                        const p = dest.mapToItem(null, 0, dest.height)
                        // mapToItem(null) → window contentItem in Qt Quick
                        menu.popup(p.x, p.y)
                    }
                }
            }
        }
    }

    Md3Menu {
        id: menu
        property int anchorIndex: 0

        Repeater {
            model: {
                if (menu.anchorIndex < 0 || menu.anchorIndex >= root.model.length)
                    return []
                const m = root.model[menu.anchorIndex]
                return m && m.children !== undefined ? m.children : [{ text: "Action" }]
            }
            Md3MenuItem {
                required property int index
                required property var modelData
                text: modelData.text !== undefined ? modelData.text : String(modelData)
                icon: modelData.icon !== undefined ? modelData.icon : ""
                onClicked: {
                    const title = root.model[menu.anchorIndex]
                    const t = title && title.text !== undefined ? title.text : "Menu"
                    root.itemClicked(t + "/" + text)
                    menu.dismiss()
                }
            }
        }
    }
}

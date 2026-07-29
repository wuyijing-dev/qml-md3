import QtQuick

Item {
    id: root

    enum Variant { Primary, Secondary }

    property int variant: Md3TabBar.Primary
    property var model: []
    property int currentIndex: 0

    signal currentIndexChangedByUser(int index)

    height: 48
    width: parent ? parent.width : 360

    Row {
        id: row
        anchors.fill: parent
        Repeater {
            model: root.model
            delegate: Item {
                required property int index
                required property var modelData
                width: Math.max(90, label.implicitWidth + 32)
                height: parent.height
                readonly property bool selected: root.currentIndex === index
                readonly property string title: modelData.text !== undefined ? modelData.text : String(modelData)

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: title
                    color: selected ? Md3Theme.colorScheme.primary : Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.titleSmall.size
                    font.weight: Font.Medium
                }

                MouseArea {
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    anchors.fill: parent
                    onClicked: {
                        root.currentIndex = index
                        root.currentIndexChangedByUser(index)
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        height: root.variant === Md3TabBar.Primary ? 3 : 2
        radius: root.variant === Md3TabBar.Primary ? 3 : 0
        color: Md3Theme.colorScheme.primary
        width: row.children.length > currentIndex ? Math.max(24, row.children[currentIndex].width - 32) : 24
        x: {
            if (row.children.length <= currentIndex)
                return 0
            const item = row.children[currentIndex]
            return item.x + (item.width - width) / 2
        }

        Behavior on x {
            NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
        }
        Behavior on width {
            NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Md3Theme.colorScheme.surfaceContainerHighest
        z: -1
    }
}

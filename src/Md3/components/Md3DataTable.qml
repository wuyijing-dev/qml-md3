import QtQuick

Column {
    id: root

    property var columns: [] // [{ title, role, width }]
    property var rows: []    // array of objects
    property int selectedRow: -1

    signal rowClicked(int index)

    width: parent ? parent.width : 480
    spacing: 0

    Rectangle {
        width: parent.width
        height: 56
        color: Md3Theme.colorScheme.surface

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            Repeater {
                model: root.columns
                Text {
                    required property var modelData
                    width: modelData.width !== undefined ? modelData.width : 120
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData.title !== undefined ? modelData.title : ""
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                }
            }
        }
    }

    Md3Divider { width: parent.width }

    Repeater {
        model: root.rows
        delegate: Rectangle {
            required property int index
            required property var modelData
            width: root.width
            height: 52
            color: root.selectedRow === index ? Md3Theme.colorScheme.secondaryContainer
                                              : "transparent"

            Row {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                Repeater {
                    model: root.columns
                    Text {
                        required property var modelData
                        width: modelData.width !== undefined ? modelData.width : 120
                        anchors.verticalCenter: parent.verticalCenter
                        text: {
                            const role = modelData.role
                            const row = parent.parent.parent.modelData
                            return row && row[role] !== undefined ? String(row[role]) : ""
                        }
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                        elide: Text.ElideRight
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.selectedRow = index
                    root.rowClicked(index)
                }
            }

            Md3Divider {
                anchors.bottom: parent.bottom
                width: parent.width
            }
        }
    }
}

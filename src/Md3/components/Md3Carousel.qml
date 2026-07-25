import QtQuick

Item {
    id: root

    property var model: [] // [{ title, color? }]
    property int currentIndex: 0
    property real itemWidth: 280
    property real itemHeight: 160

    width: parent ? parent.width : 400
    height: itemHeight

    ListView {
        id: view
        anchors.fill: parent
        orientation: ListView.Horizontal
        spacing: 8
        clip: true
        model: root.model
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0
        preferredHighlightEnd: root.itemWidth
        onCurrentIndexChanged: root.currentIndex = currentIndex

        delegate: Rectangle {
            required property int index
            required property var modelData
            width: root.itemWidth
            height: root.itemHeight
            radius: Md3Theme.shape.extraLarge
            color: modelData.color !== undefined ? modelData.color
                                                 : Md3Theme.colorScheme.primaryContainer

            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 16
                text: modelData.title !== undefined ? modelData.title : ""
                color: Md3Theme.colorScheme.colorOnPrimaryContainer
                font.pixelSize: Md3Theme.typography.titleLarge.size
                font.family: Md3Theme.typography.fontFamily
            }
        }
    }
}

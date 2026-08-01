import QtQuick
import Md3

Item {
    id: root

    property bool open: false
    property string text: ""
    property var suggestions: []

    signal suggestionChosen(string value)
    signal closed()

    anchors.fill: parent
    visible: open
    z: 980
    Accessible.role: Accessible.EditableText
    Accessible.name: text.length ? text : qsTr("Search view")

    Rectangle {
        anchors.fill: parent
        color: Md3Theme.colorScheme.surfaceContainer
    }

    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Row {
            width: parent.width
            spacing: 8
            Md3IconButton {
                icon: "arrow_back"
                onClicked: {
                    root.open = false
                    root.closed()
                }
            }
            Md3SearchBar {
                width: parent.width - 56
                text: root.text
                onTextChanged: root.text = text
                onAccepted: function (t) {
                    root.suggestionChosen(t)
                }
            }
        }

        Repeater {
            model: root.open ? root.suggestions : []
            Md3ListTile {
                required property var modelData
                width: parent.width
                title: typeof modelData === "string" ? modelData : modelData.title
                leadingIcon: "search"
                onClicked: {
                    root.suggestionChosen(title)
                    root.open = false
                }
            }
        }
    }
}

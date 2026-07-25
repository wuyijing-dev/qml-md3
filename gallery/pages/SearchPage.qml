import QtQuick
import QtQuick.Layouts
import Md3

Item {
    id: root
    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        Text {
            text: "Search"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
        }
        Md3SearchBar {
            Layout.fillWidth: true
            onClicked: view.open = true
        }
        Item { Layout.fillHeight: true }
    }
    Md3SearchView {
        id: view
        anchors.fill: parent
        suggestions: ["Material Design", "Flutter FAB", "QML tokens", "Navigation bar"]
    }
}

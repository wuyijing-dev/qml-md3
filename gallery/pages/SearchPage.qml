import QtQuick
import Md3

Md3Page {
    id: root

    Md3VStack {
        anchors.fill: parent
        spacing: 16

        Md3Text {
            text: "Search"
            role: Md3Text.HeadlineMedium
        }
        Md3SearchBar {
            width: parent.width
            searchView: view
        }
        Md3Spacer { expand: true }
    }
    Md3SearchView {
        id: view
        anchors.fill: parent
        suggestions: ["Material Design", "Flutter FAB", "QML tokens", "Navigation bar"]
    }
}

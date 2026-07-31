import QtQuick
import Md3

Md3ApplicationWindow {
    id: win
    width: 480
    height: 360
    title: qsTr("Hello Md3")
    visible: true

    Md3Dialog {
        id: aboutDialog
        anchors.fill: parent
        title: qsTr("About")
        text: qsTr("Minimal find_package / add_subdirectory consumer.")
        showDismiss: false
        confirmText: qsTr("OK")
    }

    Column {
        anchors.centerIn: parent
        spacing: 16

        Md3Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Hello, Md3")
            role: Md3Text.HeadlineSmall
        }

        Md3Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Show dialog")
            onClicked: aboutDialog.open = true
        }

        Md3Hyperlink {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Theme is ready")
        }
    }
}

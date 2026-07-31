import QtQuick
import Md3

Md3ApplicationWindow {
    id: root
    width: 420
    height: 280
    title: qsTr("Hello Rust + Md3")
    visible: true

    Md3Page {
        anchors.fill: parent
        Md3Label {
            anchors.centerIn: parent
            text: qsTr("Hello from Rust (C ABI)")
            typography: Md3.Typography.TitleLarge
        }
    }
}

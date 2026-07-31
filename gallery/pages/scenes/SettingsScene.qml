import QtQuick
import Md3

Md3Page {
    id: root

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: col.implicitHeight
        clip: true
        Md3VStack {
            id: col
            width: parent.width
            spacing: 8
            Md3TopAppBar { width: parent.width; title: "Settings"; leadingIcon: "arrow_back" }
            Md3ListTile { width: parent.width; title: "Dark theme"; trailingIcon: "settings"; showDivider: true
                // demo: use switch via subtitle area — keep simple
            }
            Md3HStack {
                width: parent.width
                leftPadding: 16
                spacing: 12
                Md3Text {
                    text: "Use dark theme"
                    role: Md3Text.BodyLarge
                }
                Md3Switch {
                    id: darkSwitch
                    checked: Md3Theme.dark
                    onToggled: function (c) {
                        if (c === Md3Theme.dark)
                            return
                        const w = root.hostWindow()
                        if (w && typeof w.toggleThemeFrom === "function")
                            w.toggleThemeFrom(darkSwitch)
                        else
                            Md3Theme.dark = c
                    }
                }
            }
            Md3Divider { width: parent.width }
            Md3ListTile { width: parent.width; title: "Notifications"; subtitle: "Push, email"; leadingIcon: "info"; showDivider: true }
            Md3ListTile { width: parent.width; title: "Privacy"; leadingIcon: "visibility"; showDivider: true }
            Md3ListTile { width: parent.width; title: "About"; leadingIcon: "info" }
        }
    }
}

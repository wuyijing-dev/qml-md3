import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Md3

Flickable {
    contentWidth: width
    contentHeight: col.height
    clip: true
    Column {
        id: col
        width: parent.width
        spacing: 8
        Md3TopAppBar { width: parent.width; title: "Settings"; leadingIcon: "arrow_back" }
        Md3ListTile { width: parent.width; title: "Dark theme"; trailingIcon: "settings"; showDivider: true
            // demo: use switch via subtitle area — keep simple
        }
        Row {
            width: parent.width
            leftPadding: 16
            spacing: 12
            Text {
                text: "Use dark theme"
                color: Md3Theme.colorScheme.colorOnSurface
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Md3Theme.typography.bodyLarge.size
            }
            Md3Switch {
                id: darkSwitch
                checked: Md3Theme.dark
                onToggled: function (c) {
                    if (c === Md3Theme.dark)
                        return
                    const w = Window.window
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

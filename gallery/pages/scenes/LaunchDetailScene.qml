import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import Md3

Item {
    id: root
    anchors.fill: parent

    function _destinationIndexBySuffix(suffix) {
        const win = Window.window
        if (!win || !win.destinations)
            return -1
        for (let i = 0; i < win.destinations.length; ++i) {
            const d = win.destinations[i]
            const src = d && d.source ? String(d.source) : ""
            if (src.indexOf(suffix) >= 0)
                return i
        }
        return -1
    }

    function _backToList() {
        const win = Window.window
        if (!win)
            return
        const listIndex = _destinationIndexBySuffix("LaunchListScene.qml")
        if (listIndex < 0)
            return
        win.navigateTo(listIndex, {
            transitionMode: "launch",
            returnToSource: true
        })
    }

    readonly property string detailTitle: {
        const win = Window.window
        if (win && win._launchDetailTitle !== undefined && win._launchDetailTitle !== null
                && String(win._launchDetailTitle).length > 0)
            return String(win._launchDetailTitle)
        return qsTr("Detail")
    }

    readonly property string detailBody: {
        const win = Window.window
        if (win && win._launchDetailBody !== undefined && win._launchDetailBody !== null
                && String(win._launchDetailBody).length > 0)
            return String(win._launchDetailBody)
        return qsTr("Whole-page route opened from source bounds.")
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Md3TopAppBar {
            Layout.fillWidth: true
            title: root.detailTitle
            leadingIcon: "arrow_back"
            size: Md3TopAppBar.Small
            onLeadingClicked: root._backToList()
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Md3Theme.colorScheme.surface

            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 14

                Text {
                    text: root.detailTitle
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.headlineSmall.size
                }
                Text {
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: root.detailBody
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                }
                Md3Button {
                    text: qsTr("Back to list")
                    onClicked: root._backToList()
                }
            }
        }
    }
}

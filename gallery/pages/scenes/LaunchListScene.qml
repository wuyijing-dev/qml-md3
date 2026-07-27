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

    function _openDetailFrom(sourceItem, title, body) {
        const win = Window.window
        if (!win || !win.pageHost)
            return
        const detailIndex = _destinationIndexBySuffix("LaunchDetailScene.qml")
        if (detailIndex < 0)
            return
        const p = sourceItem.mapToItem(win.pageHost, 0, 0)
        win._launchDetailTitle = title
        win._launchDetailBody = body
        win.navigateTo(detailIndex, {
            transitionMode: "launch",
            sourceRect: Qt.rect(p.x, p.y, sourceItem.width, sourceItem.height),
            sourceRadius: 14
        })
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Md3TopAppBar {
            Layout.fillWidth: true
            title: qsTr("Launch List")
            size: Md3TopAppBar.Small
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Md3Theme.colorScheme.surfaceContainerLow

            Column {
                anchors.fill: parent

                Md3ListTile {
                    id: rowWelcome
                    width: parent.width
                    title: qsTr("Welcome")
                    subtitle: qsTr("Open details with launch transition")
                    showDivider: true
                    onClicked: root._openDetailFrom(rowWelcome, title,
                                                    qsTr("This page is opened as a whole-route transition from the tapped row bounds."))
                }
                Md3ListTile {
                    id: rowNotes
                    width: parent.width
                    title: qsTr("Release notes")
                    subtitle: qsTr("Route-level container transform")
                    showDivider: true
                    onClicked: root._openDetailFrom(rowNotes, title,
                                                    qsTr("The animation uses source bounds, nonlinear curves, and staged content fade."))
                }
                Md3ListTile {
                    id: rowFeedback
                    width: parent.width
                    title: qsTr("Feedback")
                    subtitle: qsTr("Return also goes back into source")
                    onClicked: root._openDetailFrom(rowFeedback, title,
                                                    qsTr("Use the back button on detail page to return into this row."))
                }
            }
        }
    }
}

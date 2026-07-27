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

    function _openDetailFrom(sourceItem, title, body, localX, localY) {
        const win = Window.window
        if (!win || !win.pageHost)
            return
        const detailIndex = _destinationIndexBySuffix("LaunchDetailScene.qml")
        if (detailIndex < 0)
            return
        const gp = sourceItem.mapToGlobal(localX !== undefined ? localX : sourceItem.width / 2,
                                         localY !== undefined ? localY : sourceItem.height / 2)
        const p = win.pageHost.mapFromGlobal(gp.x, gp.y)
        win.pushRoute(detailIndex, {
            title: title,
            body: body
        }, {
            transitionMode: "launch",
            sourcePoint: Qt.point(p.x, p.y),
            sourceRadius: 7
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
                    subtitle: qsTr("Push route with launch transition")
                    showDivider: true
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: function (mouse) {
                            mouse.accepted = false
                            root._openDetailFrom(rowWelcome, rowWelcome.title,
                                                 qsTr("Level 1 — tap opens detail via pushRoute."),
                                                 mouse.x, mouse.y)
                        }
                    }
                }
                Md3ListTile {
                    id: rowNotes
                    width: parent.width
                    title: qsTr("Release notes")
                    subtitle: qsTr("Multi-level nav stack + launch morph")
                    showDivider: true
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: function (mouse) {
                            mouse.accepted = false
                            root._openDetailFrom(rowNotes, rowNotes.title,
                                                 qsTr("goBack() pops the stack; rail stays on section root."),
                                                 mouse.x, mouse.y)
                        }
                    }
                }
                Md3ListTile {
                    id: rowFeedback
                    width: parent.width
                    title: qsTr("Feedback")
                    subtitle: qsTr("Detail can push another level")
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: function (mouse) {
                            mouse.accepted = false
                            root._openDetailFrom(rowFeedback, rowFeedback.title,
                                                 qsTr("Open detail, then use “Open level 2” for nested push."),
                                                 mouse.x, mouse.y)
                        }
                    }
                }
            }
        }
    }
}

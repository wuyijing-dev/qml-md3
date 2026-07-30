import QtQuick
import Md3

Md3Page {
    id: root

    function _destinationIndexBySuffix(suffix) {
        const win = hostWindow()
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
        const win = hostWindow()
        if (!win || !win.pageHost)
            return
        const detailIndex = _destinationIndexBySuffix("LaunchDetailScene.qml")
        if (detailIndex < 0)
            return
        const gp = sourceItem.mapToGlobal(localX !== undefined ? localX : sourceItem.width / 2,
                                         localY !== undefined ? localY : sourceItem.height / 2)
        const p = win.pageHost.mapFromGlobal(gp.x, gp.y)
        pushRoute(detailIndex, {
            title: title,
            body: body
        }, {
            transitionMode: "launch",
            sourcePoint: Qt.point(p.x, p.y),
            sourceRadius: 7
        })
    }

    Md3VStack {
        id: pageStack
        anchors.fill: parent
        spacing: 0

        Md3TopAppBar {
            id: topBar
            width: parent.width
            title: qsTr("Launch List")
            size: Md3TopAppBar.Small
        }

        Rectangle {
            width: parent.width
            height: Math.max(0, root.height - topBar.implicitHeight)
            color: Md3Theme.colorScheme.surfaceContainerLow

            Md3VStack {
                anchors.fill: parent
                spacing: 0

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

import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import Md3

Item {
    id: root
    anchors.fill: parent

    readonly property var route: {
        const win = Window.window
        return win && win.routeParams ? win.routeParams : ({})
    }

    readonly property int navDepth: {
        const win = Window.window
        return win && win.navDepth !== undefined ? win.navDepth : 0
    }

    readonly property string detailTitle: {
        if (route.title !== undefined && String(route.title).length > 0)
            return String(route.title)
        return qsTr("Detail")
    }

    readonly property string detailBody: {
        if (route.body !== undefined && String(route.body).length > 0)
            return String(route.body)
        return qsTr("Whole-page route opened from source bounds.")
    }

    function _back() {
        const win = Window.window
        if (!win)
            return
        if (!win.goBack())
            return
    }

    function _openLevel2() {
        const win = Window.window
        if (!win || !win.pageHost)
            return
        const gp = mapToGlobal(width / 2, height / 2)
        const p = win.pageHost.mapFromGlobal(gp.x, gp.y)
        win.pushRoute(win.currentIndex, {
            title: qsTr("Level %1").arg(navDepth + 2),
            body: qsTr("Nested pushRoute on the same detail page. goBack() returns to the previous level.")
        }, {
            transitionMode: "launch",
            sourcePoint: Qt.point(p.x, p.y),
            sourceRadius: 8
        })
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Md3TopAppBar {
            Layout.fillWidth: true
            title: root.detailTitle
            leadingIcon: "arrow_back"
            size: Md3TopAppBar.Small
            onLeadingClicked: root._back()
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
                    text: qsTr("Depth: %1").arg(root.navDepth + 1)
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
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
                Row {
                    spacing: 12
                    Md3Button {
                        text: qsTr("Back")
                        onClicked: root._back()
                    }
                    Md3Button {
                        text: qsTr("Open level 2")
                        onClicked: root._openLevel2()
                    }
                }
            }
        }
    }
}

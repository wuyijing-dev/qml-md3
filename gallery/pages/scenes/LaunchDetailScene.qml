import QtQuick
import QtQuick.Layouts
import Md3

Md3Page {
    id: root

    readonly property string detailTitle: {
        if (routeParams.title !== undefined && String(routeParams.title).length > 0)
            return String(routeParams.title)
        return qsTr("Detail")
    }

    readonly property string detailBody: {
        if (routeParams.body !== undefined && String(routeParams.body).length > 0)
            return String(routeParams.body)
        return qsTr("Whole-page route opened from source bounds.")
    }

    readonly property var crumbModel: {
        const items = [{ title: qsTr("列表打开"), icon: "list_alt" }]
        const depth = navDepth
        for (let i = 0; i < depth; ++i) {
            if (i === depth - 1)
                items.push({ title: detailTitle, icon: "description" })
            else
                items.push({ title: qsTr("层级 %1").arg(i + 1), icon: "folder" })
        }
        if (depth === 0)
            items.push({ title: detailTitle, icon: "description" })
        return items
    }

    function _goCrumb(index) {
        // index 0 = list root → pop entire stack
        const pops = Math.max(0, crumbModel.length - 1 - index)
        for (let i = 0; i < pops; ++i) {
            if (!goBack())
                break
        }
    }

    function _openLevel2() {
        const win = hostWindow()
        if (!win || !win.pageHost)
            return
        const gp = mapToGlobal(width / 2, height / 2)
        const p = win.pageHost.mapFromGlobal(gp.x, gp.y)
        const pageIndex = win.currentIndex !== undefined ? win.currentIndex : 0
        pushRoute(pageIndex, {
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
            onLeadingClicked: root.goBack()
        }

        Md3Breadcrumb {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: 8
            model: root.crumbModel
            onCrumbClicked: function (index) { root._goCrumb(index) }
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
                        onClicked: root.goBack()
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

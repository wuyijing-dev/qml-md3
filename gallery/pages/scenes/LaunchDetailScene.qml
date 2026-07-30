import QtQuick
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

    Md3VStack {
        id: pageStack
        anchors.fill: parent
        spacing: 0

        Md3TopAppBar {
            id: topBar
            width: parent.width
            title: root.detailTitle
            leadingIcon: "arrow_back"
            size: Md3TopAppBar.Small
            onLeadingClicked: root.goBack()
        }

        Item {
            id: breadcrumbRow
            width: parent.width
            height: breadcrumb.implicitHeight + 8

            Md3Breadcrumb {
                id: breadcrumb
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                model: root.crumbModel
                onCrumbClicked: function (index) { root._goCrumb(index) }
            }
        }

        Md3Surface {
            width: parent.width
            height: Math.max(0, root.height - topBar.implicitHeight - breadcrumbRow.height)
            radius: 0
            elevation: 0
            color: Md3Theme.colorScheme.surface

            Md3VStack {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 14

                Md3Text {
                    text: qsTr("Depth: %1").arg(root.navDepth + 1)
                    role: Md3Text.LabelLarge
                    tone: Md3Text.OnSurfaceVariant
                }
                Md3Text {
                    text: root.detailTitle
                    role: Md3Text.HeadlineSmall
                }
                Md3Text {
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: root.detailBody
                    role: Md3Text.BodyLarge
                    tone: Md3Text.OnSurfaceVariant
                }
                Md3HStack {
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

import QtQuick
import Md3

/// Compact pagination bar for tables / lists.
Item {
    id: root

    property int pageCount: 1
    property int currentPage: 0 // 0-based
    property int totalCount: -1
    property int pageSize: 10
    property bool showTotal: true

    signal pageRequested(int page)

    readonly property int safePageCount: Math.max(1, pageCount)
    readonly property int safePage: Math.max(0, Math.min(currentPage, safePageCount - 1))

    implicitWidth: row.implicitWidth
    implicitHeight: 48
    height: implicitHeight

    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Pagination")

    function goTo(page) {
        if (!enabled)
            return
        const p = Math.max(0, Math.min(page, safePageCount - 1))
        if (p === currentPage)
            return
        currentPage = p
        pageRequested(p)
    }

    function next() { goTo(safePage + 1) }
    function previous() { goTo(safePage - 1) }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.showTotal && root.totalCount >= 0
            text: {
                if (root.totalCount <= 0)
                    return qsTr("0 items")
                const from = root.safePage * root.pageSize + 1
                const to = Math.min(root.totalCount, (root.safePage + 1) * root.pageSize)
                return qsTr("%1–%2 of %3").arg(from).arg(to).arg(root.totalCount)
            }
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
            rightPadding: 8
        }

        Md3IconButton {
            icon: "chevron_left"
            enabled: root.enabled && root.safePage > 0
            accessibleName: qsTr("Previous page")
            onClicked: root.previous()
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("%1 / %2").arg(root.safePage + 1).arg(root.safePageCount)
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelLarge.size
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(48, implicitWidth)
        }

        Md3IconButton {
            icon: "chevron_right"
            enabled: root.enabled && root.safePage < root.safePageCount - 1
            accessibleName: qsTr("Next page")
            onClicked: root.next()
        }
    }
}

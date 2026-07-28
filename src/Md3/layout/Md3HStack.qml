import QtQuick

/// Horizontal stack with spacing, padding, alignment, and expanding spacers.
Item {
    id: root

    enum Alignment {
        Start,
        Center,
        End
    }

    property real spacing: 8
    property real padding: 0
    property real leftPadding: padding
    property real rightPadding: padding
    property real topPadding: padding
    property real bottomPadding: padding
    property bool fillHeight: false
    property bool stretchChildren: false
    property bool clipContent: false
    property int alignment: Md3HStack.Center
    default property alias content: contentRow.data

    implicitWidth: contentRow.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(1, contentRow.implicitHeight + topPadding + bottomPadding)

    Row {
        id: contentRow
        clip: root.clipContent
        x: root.leftPadding
        y: root.topPadding
        height: root.fillHeight ? Math.max(0, root.height - root.topPadding - root.bottomPadding)
                                : implicitHeight
        spacing: root.spacing

        onChildrenChanged: Qt.callLater(root._applyChildHints)
        onHeightChanged: Qt.callLater(root._applyChildHints)
    }

    onWidthChanged: Qt.callLater(_applyChildHints)
    onAlignmentChanged: Qt.callLater(_applyChildHints)
    onStretchChildrenChanged: Qt.callLater(_applyChildHints)
    onFillHeightChanged: Qt.callLater(_applyChildHints)
    Component.onCompleted: Qt.callLater(_applyChildHints)

    function _applyChildHints() {
        const kids = contentRow.children
        const availH = contentRow.height
        const availW = Math.max(0, root.width - root.leftPadding - root.rightPadding)

        // First pass: expand horizontal spacers.
        let fixed = 0
        let expanders = []
        let visibleCount = 0
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false)
                continue
            visibleCount++
            if (c.expand === true) {
                expanders.push(c)
            } else {
                const w = Math.max(c.width || 0, c.implicitWidth || 0)
                fixed += w
            }
        }
        const gaps = Math.max(0, visibleCount - 1) * root.spacing
        const remain = Math.max(0, availW - fixed - gaps)
        const each = expanders.length > 0 ? remain / expanders.length : 0
        for (let e = 0; e < expanders.length; ++e)
            expanders[e].width = each

        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false)
                continue

            if (root.stretchChildren || root.fillHeight)
                c.height = availH

            if (root.alignment === Md3HStack.Center)
                c.y = Math.max(0, (availH - c.height) * 0.5)
            else if (root.alignment === Md3HStack.End)
                c.y = Math.max(0, availH - c.height)
            else
                c.y = 0
        }
    }
}

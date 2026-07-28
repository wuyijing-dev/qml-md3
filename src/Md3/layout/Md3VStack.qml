import QtQuick

/// Vertical stack with spacing, padding, alignment, and optional child stretch.
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
    property bool fillWidth: true
    /// Stretch visible children to content width (skip Md3Spacer with expand).
    property bool stretchChildren: true
    property bool clipContent: false
    property int alignment: Md3VStack.Start
    default property alias content: contentCol.data

    implicitWidth: Math.max(1, contentCol.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentCol.implicitHeight + topPadding + bottomPadding

    Column {
        id: contentCol
        clip: root.clipContent
        x: root.leftPadding
        y: root.topPadding
        width: root.fillWidth ? Math.max(0, root.width - root.leftPadding - root.rightPadding)
                              : implicitWidth
        spacing: root.spacing

        onChildrenChanged: Qt.callLater(root._applyChildHints)
        onWidthChanged: Qt.callLater(root._applyChildHints)
    }

    onAlignmentChanged: Qt.callLater(_applyChildHints)
    onStretchChildrenChanged: Qt.callLater(_applyChildHints)
    onFillWidthChanged: Qt.callLater(_applyChildHints)
    Component.onCompleted: Qt.callLater(_applyChildHints)

    function _applyChildHints() {
        const kids = contentCol.children
        const avail = contentCol.width
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false)
                continue

            // Expanding spacer: take remaining vertical room when parent has explicit height.
            if (c.expand === true) {
                const used = contentCol.implicitHeight - (c.height || c.implicitHeight || 0)
                const remain = Math.max(0, root.height - root.topPadding - root.bottomPadding - used)
                c.height = remain
                c.width = avail
                continue
            }

            if (root.stretchChildren && root.fillWidth && avail > 0)
                c.width = avail

            if (root.alignment === Md3VStack.Center && avail > 0)
                c.x = Math.max(0, (avail - c.width) * 0.5)
            else if (root.alignment === Md3VStack.End && avail > 0)
                c.x = Math.max(0, avail - c.width)
            else
                c.x = 0
        }
    }
}

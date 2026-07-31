import QtQuick
import Md3

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

    property bool _applying: false

    implicitWidth: Math.max(1, contentCol.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentCol.implicitHeight + topPadding + bottomPadding

    Timer {
        id: layoutTimer
        interval: 0
        repeat: false
        onTriggered: root._applyChildHints()
    }

    Column {
        id: contentCol
        clip: root.clipContent
        x: root.leftPadding
        y: root.topPadding
        width: root.fillWidth ? Math.max(0, root.width - root.leftPadding - root.rightPadding)
                              : implicitWidth
        spacing: root.spacing

        onChildrenChanged: root._scheduleLayout()
        onWidthChanged: root._scheduleLayout()
    }

    onAlignmentChanged: _scheduleLayout()
    onStretchChildrenChanged: _scheduleLayout()
    onFillWidthChanged: _scheduleLayout()
    onHeightChanged: _scheduleLayout()
    Component.onCompleted: _scheduleLayout()
    Component.onDestruction: layoutTimer.stop()

    function _scheduleLayout() {
        if (!layoutTimer)
            return
        layoutTimer.restart()
    }

    function _setReal(item, prop, value) {
        if (!item)
            return
        const cur = item[prop]
        if (typeof cur === "number" && Math.abs(cur - value) < 0.5)
            return
        item[prop] = value
    }

    function _applyChildHints() {
        if (_applying || !contentCol)
            return
        _applying = true

        const kids = contentCol.children
        const avail = contentCol.width
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false)
                continue

            if (c.expand === true) {
                const used = contentCol.implicitHeight - (c.height || c.implicitHeight || 0)
                const remain = Math.max(0, root.height - root.topPadding - root.bottomPadding - used)
                _setReal(c, "height", remain)
                _setReal(c, "width", avail)
                continue
            }

            if (root.stretchChildren && root.fillWidth && avail > 0)
                _setReal(c, "width", avail)

            if (root.alignment === Md3VStack.Center && avail > 0)
                _setReal(c, "x", Math.max(0, (avail - c.width) * 0.5))
            else if (root.alignment === Md3VStack.End && avail > 0)
                _setReal(c, "x", Math.max(0, avail - c.width))
            else
                _setReal(c, "x", 0)
        }

        _applying = false
    }
}

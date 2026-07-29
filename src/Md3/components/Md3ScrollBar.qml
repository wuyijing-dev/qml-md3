import QtQuick

/// Themed scrollbar attached to a Flickable (vertical or horizontal).
Item {
    id: root

    property Flickable flickable: null
    property int orientation: Qt.Vertical
    property real thickness: 10
    property real minThumb: 28
    property bool autoHide: true
    property int fadeDelayMs: 900

    readonly property bool vertical: orientation === Qt.Vertical
    readonly property real _view: vertical
            ? (flickable ? flickable.height : 0)
            : (flickable ? flickable.width : 0)
    readonly property real _content: vertical
            ? (flickable ? flickable.contentHeight : 0)
            : (flickable ? flickable.contentWidth : 0)
    readonly property real _pos: vertical
            ? (flickable ? flickable.contentY : 0)
            : (flickable ? flickable.contentX : 0)
    readonly property bool needed: flickable && _content > _view + 1
    readonly property real thumbRatio: needed ? Math.min(1, _view / Math.max(1, _content)) : 1
    readonly property real thumbSize: needed ? Math.max(minThumb, (_view - 4) * thumbRatio) : 0
    readonly property real travel: Math.max(0, _view - 4 - thumbSize)
    readonly property real thumbPos: {
        if (!needed || travel <= 0)
            return 2
        const maxPos = Math.max(1, _content - _view)
        return 2 + travel * Math.max(0, Math.min(1, _pos / maxPos))
    }

    property bool _hovered: false
    property bool _dragging: false
    property bool _shown: !autoHide

    width: vertical ? thickness : (flickable ? flickable.width : 0)
    height: vertical ? (flickable ? flickable.height : 0) : thickness
    visible: needed
    opacity: (_shown || _hovered || _dragging || !autoHide) ? 1 : 0
    z: 50

    Behavior on opacity {
        NumberAnimation {
            duration: Md3Motion.effectsDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }

    function _flash() {
        if (!autoHide)
            return
        _shown = true
        hideTimer.restart()
    }

    function _scrollToThumb(local) {
        if (!flickable || !needed || travel <= 0)
            return
        const t = Math.max(0, Math.min(1, (local - 2 - thumbSize / 2) / travel))
        const maxPos = Math.max(0, _content - _view)
        if (vertical)
            flickable.contentY = t * maxPos
        else
            flickable.contentX = t * maxPos
    }

    Timer {
        id: hideTimer
        interval: root.fadeDelayMs
        onTriggered: {
            if (!root._hovered && !root._dragging)
                root._shown = false
        }
    }

    Connections {
        target: root.flickable
        function onContentYChanged() { root._flash() }
        function onContentXChanged() { root._flash() }
        function onContentHeightChanged() { root._flash() }
        function onContentWidthChanged() { root._flash() }
        function onMovingChanged() {
            if (root.flickable && root.flickable.moving)
                root._flash()
        }
        function onFlickingChanged() {
            if (root.flickable && root.flickable.flicking)
                root._flash()
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root.thickness / 2
        color: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.06)
        opacity: root._hovered || root._dragging ? 1 : 0.5
    }

    Rectangle {
        id: thumb
        radius: root.thickness / 2
        color: Md3Theme.colorScheme.withOpacity(
                   Md3Theme.colorScheme.colorOnSurfaceVariant,
                   root._dragging ? 0.55 : (root._hovered ? 0.42 : 0.28))
        width: root.vertical ? root.thickness - 4 : root.thumbSize
        height: root.vertical ? root.thumbSize : root.thickness - 4
        x: root.vertical ? 2 : root.thumbPos
        y: root.vertical ? root.thumbPos : 2

        Behavior on color {
            ColorAnimation { duration: Md3Motion.effectsDuration }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.ArrowCursor
        onEntered: {
            root._hovered = true
            root._flash()
        }
        onExited: {
            root._hovered = false
            if (!root._dragging)
                hideTimer.restart()
        }
        onPressed: function (mouse) {
            root._dragging = true
            root._flash()
            root._scrollToThumb(root.vertical ? mouse.y : mouse.x)
        }
        onPositionChanged: function (mouse) {
            if (pressed)
                root._scrollToThumb(root.vertical ? mouse.y : mouse.x)
        }
        onReleased: {
            root._dragging = false
            hideTimer.restart()
        }
    }
}

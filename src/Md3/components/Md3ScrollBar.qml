import QtQuick
import Md3

/// Themed scrollbar attached to a Flickable (vertical or horizontal).
/// Optional `annotations` enable WinUI AnnotatedScrollBar-style letter/tick labels.
Item {
    id: root

    property Flickable flickable: null
    property int orientation: Qt.Vertical
    property real thickness: 10
    property real minThumb: 28
    property bool autoHide: true
    property int fadeDelayMs: 900
    /// Equal-spaced labels (e.g. A–Z) or [{ position: 0..1, label }]. Vertical only.
    property var annotations: []
    property bool showAnnotations: annotations && annotations.length > 0
    property real annotationGutter: showAnnotations && vertical ? 18 : 0

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
    readonly property string activeAnnotation: {
        if (!showAnnotations || !annotations || annotations.length === 0)
            return ""
        const maxPos = Math.max(1, _content - _view)
        const t = maxPos > 0 ? _pos / maxPos : 0
        return _labelAt(t)
    }

    property bool _hovered: false
    property bool _dragging: false
    property bool _shown: !autoHide

    width: vertical ? (thickness + annotationGutter) : (flickable ? flickable.width : 0)
    height: vertical ? (flickable ? flickable.height : 0) : thickness
    visible: needed
    opacity: (_shown || _hovered || _dragging || !autoHide || showAnnotations) ? 1 : 0
    z: 50

    Accessible.role: Accessible.ScrollBar
    Accessible.name: activeAnnotation.length
                     ? qsTr("Scroll bar, %1").arg(activeAnnotation)
                     : qsTr("Scroll bar")

    function _labelAt(t) {
        const list = annotations || []
        if (!list.length)
            return ""
        if (typeof list[0] === "string") {
            const i = Math.max(0, Math.min(list.length - 1, Math.round(t * (list.length - 1))))
            return String(list[i])
        }
        let best = list[0]
        let bestD = Math.abs((best.position !== undefined ? best.position : 0) - t)
        for (let i = 1; i < list.length; ++i) {
            const p = list[i].position !== undefined ? list[i].position : (i / (list.length - 1))
            const d = Math.abs(p - t)
            if (d < bestD) {
                bestD = d
                best = list[i]
            }
        }
        return best.label !== undefined ? String(best.label) : ""
    }

    function scrollToAnnotation(index) {
        if (!flickable || !annotations || index < 0 || index >= annotations.length)
            return
        let t = 0
        const item = annotations[index]
        if (typeof item === "string")
            t = annotations.length <= 1 ? 0 : index / (annotations.length - 1)
        else
            t = item.position !== undefined ? item.position : (annotations.length <= 1 ? 0 : index / (annotations.length - 1))
        const maxPos = Math.max(0, _content - _view)
        if (vertical)
            flickable.contentY = t * maxPos
        else
            flickable.contentX = t * maxPos
        _flash()
    }

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
        id: track
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: root.vertical ? root.thickness : parent.width
        height: root.vertical ? parent.height : root.thickness
        anchors.left: root.vertical ? undefined : parent.left
        radius: root.thickness / 2
        color: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.06)
        opacity: root._hovered || root._dragging ? 1 : 0.5
    }

    Column {
        id: annotationCol
        visible: root.showAnnotations && root.vertical
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.annotationGutter
        spacing: 0

        Repeater {
            model: root.annotations || []
            delegate: Item {
                required property int index
                required property var modelData
                width: annotationCol.width
                height: annotationCol.height / Math.max(1, (root.annotations || []).length)

                Md3Text {
                    anchors.centerIn: parent
                    text: typeof modelData === "string" ? modelData
                          : (modelData.label !== undefined ? String(modelData.label) : "")
                    role: Md3Text.LabelSmall
                    tone: Md3Text.OnSurfaceVariant
                    font.pixelSize: 9
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.scrollToAnnotation(index)
                }
            }
        }
    }

    Rectangle {
        id: thumb
        parent: track
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

    Rectangle {
        visible: root.showAnnotations && root._dragging && root.activeAnnotation.length > 0
        anchors.right: track.left
        anchors.rightMargin: 6
        y: Math.max(0, Math.min(parent.height - height, thumb.y + thumb.height / 2 - height / 2))
        width: tipLabel.implicitWidth + 12
        height: tipLabel.implicitHeight + 8
        radius: Md3Theme.shape.extraSmall
        color: Md3Theme.colorScheme.inverseSurface
        z: 60

        Md3Text {
            id: tipLabel
            anchors.centerIn: parent
            text: root.activeAnnotation
            role: Md3Text.LabelMedium
            tone: Md3Text.Custom
            customColor: Md3Theme.colorScheme.colorOnInverseSurface
        }
    }

    MouseArea {
        anchors.fill: track
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

import QtQuick
import QtQuick.Layouts
import Md3

/// Within-page progressive load: placeholder first, then create `sourceComponent`.
/// Honors Md3Theme.progressiveContent (default on). Set forceImmediate to always load now.
Item {
    id: root

    property Component sourceComponent: null
    /// Delay before arming when progressiveContent is on (ms). 0 = next event-loop tick.
    property int delayMs: 0
    /// Height reserved while empty / loading (also used as Layout.preferredHeight hint).
    property real preferredHeight: 120
    /// Prefer sync create to avoid "destroyed during incubation" on fast page switches.
    property bool asynchronous: false
    /// Ignore Md3Theme.progressiveContent and load immediately.
    property bool forceImmediate: false

    readonly property bool progressive: Md3Theme.progressiveContent && !forceImmediate
    readonly property bool ready: loader.status === Loader.Ready
    readonly property Item item: loader.item

    property bool _armed: !progressive

    Layout.fillWidth: true
    Layout.preferredHeight: preferredHeight
    implicitWidth: parent ? parent.width : preferredHeight
    implicitHeight: preferredHeight
    height: preferredHeight
    width: parent ? parent.width : implicitWidth
    clip: true

    function arm() {
        _armed = true
    }

    onProgressiveChanged: {
        if (!progressive)
            _armed = true
    }

    Timer {
        id: deferTimer
        interval: Math.max(0, root.delayMs)
        running: root.progressive && !root._armed
        repeat: false
        onTriggered: root._armed = true
    }

    Loader {
        id: loader
        anchors.fill: parent
        active: root._armed && !!root.sourceComponent
        asynchronous: root.asynchronous
        sourceComponent: root.sourceComponent
        onLoaded: {
            if (!item)
                return
            item.width = Qt.binding(function () { return loader.width })
        }
    }

    // Soft placeholder while deferred / incubating
    Rectangle {
        anchors.fill: parent
        visible: !root.ready
        radius: 8
        color: Md3Theme.colorScheme.surfaceContainerHighest
        opacity: 0.45
    }
}

import QtQuick
import QtQuick.Layouts
import Md3

/// Within-page progressive load: placeholder first, then create `sourceComponent`.
/// Honors Md3Theme.progressiveContent (default on). Set forceImmediate to always load now.
/// When `unloadWhenPageInactive`, disarms while ancestor `md3PageActive` is false (PageHost injects).
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
    /// When progressive, also wait until near a parent Flickable viewport.
    property bool requireNearViewport: true
    /// Extra pixels around the viewport before arming.
    property real viewportMargin: 240
    /// Drop Loader while page is off-display (keep preferredHeight shell).
    property bool unloadWhenPageInactive: true

    readonly property bool progressive: Md3Theme.progressiveContent && !forceImmediate
    readonly property bool ready: loader.status === Loader.Ready
    readonly property Item item: loader.item

    property bool _armed: !progressive
    property bool _delayElapsed: !progressive
    property bool _nearViewport: true
    property var _flickable: null
    property var _pageRoot: null
    property bool _pageActive: true

    Layout.fillWidth: true
    Layout.preferredHeight: preferredHeight
    implicitWidth: parent ? parent.width : preferredHeight
    implicitHeight: preferredHeight
    height: preferredHeight
    width: parent ? parent.width : implicitWidth
    clip: true

    function arm() {
        _armed = true
        _delayElapsed = true
        _nearViewport = true
    }

    /// Destroy heavy Loader item; keep placeholder height.
    function disarm() {
        _armed = false
    }

    /// Re-arm after page return — delay already satisfied; viewport gate still applies.
    function rearm() {
        if (!_pageActive && unloadWhenPageInactive)
            return
        if (!progressive) {
            _armed = true
            return
        }
        _delayElapsed = true
        _hookFlickable()
        _updateNearViewport()
        _tryArm()
    }

    function _findPageRoot() {
        let p = parent
        while (p) {
            try {
                const v = p.md3PageActive
                if (typeof v === "boolean")
                    return p
            } catch (e) { /* not declared */ }
            p = p.parent
        }
        return null
    }

    function _resolvePageRoot() {
        const p = _findPageRoot()
        if (p === _pageRoot)
            return
        _pageRoot = p
        _syncPageActive()
    }

    function _syncPageActive() {
        const next = _pageRoot ? !!_pageRoot.md3PageActive : true
        if (next === _pageActive)
            return
        _pageActive = next
        if (!unloadWhenPageInactive)
            return
        if (!_pageActive)
            disarm()
        else
            rearm()
    }

    function _findFlickable() {
        let p = parent
        while (p) {
            if (p.contentY !== undefined && p.height !== undefined
                    && p.contentHeight !== undefined)
                return p
            p = p.parent
        }
        return null
    }

    function _hookFlickable() {
        const f = _findFlickable()
        if (f === _flickable)
            return
        if (_flickable) {
            try {
                _flickable.contentYChanged.disconnect(_updateNearViewport)
                _flickable.heightChanged.disconnect(_updateNearViewport)
            } catch (e) { /* gone */ }
        }
        _flickable = f
        if (_flickable) {
            _flickable.contentYChanged.connect(_updateNearViewport)
            _flickable.heightChanged.connect(_updateNearViewport)
        }
        _updateNearViewport()
    }

    function _updateNearViewport() {
        if (!requireNearViewport || !progressive || _armed) {
            _nearViewport = true
            return
        }
        const f = _flickable || _findFlickable()
        if (!f) {
            _nearViewport = true
            return
        }
        let itemY = 0
        try {
            itemY = f.contentItem ? mapToItem(f.contentItem, 0, 0).y
                                  : mapToItem(f, 0, 0).y + f.contentY
        } catch (e) {
            _nearViewport = true
            return
        }
        const visibleTop = f.contentY - viewportMargin
        const visibleBottom = f.contentY + f.height + viewportMargin
        _nearViewport = (itemY + height) >= visibleTop && itemY <= visibleBottom
    }

    function _tryArm() {
        if (_armed)
            return
        if (unloadWhenPageInactive && !_pageActive)
            return
        if (!progressive) {
            _armed = true
            return
        }
        if (_delayElapsed && _nearViewport)
            _armed = true
    }

    onProgressiveChanged: {
        if (!progressive) {
            _delayElapsed = true
            _nearViewport = true
            if (!unloadWhenPageInactive || _pageActive)
                _armed = true
        }
    }

    onUnloadWhenPageInactiveChanged: {
        if (!unloadWhenPageInactive && !_armed)
            rearm()
        else if (unloadWhenPageInactive && !_pageActive)
            disarm()
    }

    on_DelayElapsedChanged: _tryArm()
    on_NearViewportChanged: _tryArm()
    onParentChanged: {
        Qt.callLater(_hookFlickable)
        Qt.callLater(_resolvePageRoot)
    }
    Component.onCompleted: {
        Qt.callLater(_hookFlickable)
        Qt.callLater(_resolvePageRoot)
        if (!progressive && (!unloadWhenPageInactive || _pageActive))
            _armed = true
    }
    Component.onDestruction: {
        if (_flickable) {
            try {
                _flickable.contentYChanged.disconnect(_updateNearViewport)
                _flickable.heightChanged.disconnect(_updateNearViewport)
            } catch (e) { /* gone */ }
        }
    }

    Connections {
        target: root._pageRoot
        function onMd3PageActiveChanged() { root._syncPageActive() }
    }

    Timer {
        id: deferTimer
        interval: Math.max(0, root.delayMs)
        running: root.progressive && !root._delayElapsed
                && (!root.unloadWhenPageInactive || root._pageActive)
        repeat: false
        onTriggered: root._delayElapsed = true
    }

    // Sparse check until armed (layout that moves us into view without contentY).
    Timer {
        interval: 160
        running: root.progressive && !root._armed && root.visible && root.requireNearViewport
                && (!root.unloadWhenPageInactive || root._pageActive)
        repeat: true
        onTriggered: {
            root._hookFlickable()
            root._resolvePageRoot()
            root._updateNearViewport()
            root._tryArm()
        }
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

    Rectangle {
        anchors.fill: parent
        visible: !root.ready
        radius: 8
        color: Md3Theme.colorScheme.surfaceContainerHighest
        opacity: 0.45
    }
}

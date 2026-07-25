import QtQuick
import QtQuick.Window

/*
  Instant navigation host:
  - Revisit: visibility flip only (no reload)
  - Cold open: keep previous page visible until target Ready (no blank hitch)
  - cacheMode: "none" | "one" | "lru" | "all"
  - LRU keeps last cacheLimit pages warm
*/
Item {
    id: root

    property var model: []
    property int currentIndex: 0
    /// Index actually shown (may lag currentIndex while loading)
    property int displayedIndex: 0
    property string cacheMode: "lru"
    property int cacheLimit: 8
    property real contentPadding: 20
    property bool asynchronous: true
    property bool prefetchNeighbors: true
    property bool warmStart: false
    property bool showBusyIndicator: false
    property url sourceBase: ""

    readonly property var currentItem: {
        const ldr = _loaderAt(displayedIndex)
        return ldr && ldr.item ? ldr.item : null
    }
    readonly property bool loading: {
        const ldr = _loaderAt(currentIndex)
        return currentIndex !== displayedIndex
                || !!(ldr && ldr.status === Loader.Loading)
    }

    property var keepFlags: []   // bool[] — pages allowed to stay loaded
    property var lruOrder: []    // oldest → newest indices
    property int generation: 0

    function entryAt(index) {
        if (!model || index < 0 || index >= model.length)
            return null
        return model[index]
    }

    function resolveSource(src) {
        if (src === undefined || src === null || src === "")
            return ""
        const s = String(src)
        if (s.indexOf(":/") >= 0 || s.indexOf("qrc:") === 0 || s.indexOf("file:") === 0
                || s.indexOf("https:") === 0 || s.indexOf("http:") === 0)
            return s
        const base = String(root.sourceBase)
        if (base.length > 0) {
            let dir = base
            if (!dir.endsWith("/")) {
                const slash = Math.max(dir.lastIndexOf("/"), dir.lastIndexOf("\\"))
                dir = slash >= 0 ? dir.substring(0, slash + 1) : dir + "/"
            }
            return dir + s.replace(/^\.\//, "")
        }
        return Qt.resolvedUrl(s).toString()
    }

    function _loaderAt(index) {
        return pageRepeater.itemAt(index)
    }

    function _ensureKeepArray() {
        const n = model ? model.length : 0
        if (keepFlags.length === n)
            return
        const next = []
        for (let i = 0; i < n; ++i)
            next.push(i === displayedIndex || i === currentIndex)
        keepFlags = next
        generation++
    }

    function _setKeep(index, on) {
        if (index < 0 || !model || index >= model.length)
            return
        _ensureKeepArray()
        if (keepFlags[index] === on)
            return
        const next = keepFlags.slice()
        next[index] = on
        keepFlags = next
        generation++
    }

    function _touchLru(index) {
        if (index < 0)
            return
        const next = []
        for (let i = 0; i < lruOrder.length; ++i) {
            if (lruOrder[i] !== index)
                next.push(lruOrder[i])
        }
        next.push(index)
        lruOrder = next
    }

    function _shouldKeep(index) {
        root.generation
        if (index === displayedIndex || index === currentIndex)
            return true
        if (index < 0 || index >= keepFlags.length)
            return false
        if (!keepFlags[index])
            return false
        if (cacheMode === "all")
            return true
        if (cacheMode === "one")
            return false // only current/displayed via early return
        if (cacheMode === "lru")
            return true // keepFlags already pruned
        return false // none
    }

    function _evict() {
        if (cacheMode === "all" || cacheMode === "none")
            return
        if (cacheMode === "one") {
            for (let i = 0; i < keepFlags.length; ++i) {
                if (i !== displayedIndex && i !== currentIndex && keepFlags[i])
                    _setKeep(i, false)
            }
            return
        }
        // lru
        const protectedIdx = {}
        protectedIdx[displayedIndex] = true
        protectedIdx[currentIndex] = true
        let kept = 0
        const order = lruOrder.slice()
        for (let i = order.length - 1; i >= 0; --i) {
            const idx = order[i]
            if (protectedIdx[idx]) {
                kept++
                continue
            }
            if (kept < root.cacheLimit) {
                kept++
                continue
            }
            _setKeep(idx, false)
            // remove from lru
            const pruned = []
            for (let j = 0; j < lruOrder.length; ++j) {
                if (lruOrder[j] !== idx)
                    pruned.push(lruOrder[j])
            }
            lruOrder = pruned
        }
    }

    function _urlFor(index) {
        const e = entryAt(index)
        if (!e || e.source === undefined || e.source === null || e.source === "")
            return ""
        return resolveSource(e.source)
    }

    function _compFor(index) {
        const e = entryAt(index)
        if (!e || (e.source !== undefined && e.source !== null && e.source !== ""))
            return null
        return e.component !== undefined ? e.component : null
    }

    function _fillLoader(loader, index) {
        if (!loader)
            return
        const comp = _compFor(index)
        if (comp) {
            if (loader.source !== "")
                loader.source = ""
            if (loader.sourceComponent !== comp)
                loader.sourceComponent = comp
            return
        }
        const url = _urlFor(index)
        if (loader.sourceComponent !== null)
            loader.sourceComponent = null
        if (String(loader.source) !== url)
            loader.source = url
    }

    function _tryShow(index) {
        const ldr = _loaderAt(index)
        if (!ldr)
            return false
        if (ldr.status === Loader.Ready && ldr.item) {
            if (displayedIndex !== index)
                displayedIndex = index
            return true
        }
        return false
    }

    function navigateTo(index) {
        if (!model || index < 0 || index >= model.length)
            return

        currentIndex = index
        _touchLru(index)
        _setKeep(index, true)

        // Hot path: already Ready → instant swap
        if (_tryShow(index)) {
            _evict()
            if (prefetchNeighbors)
                Qt.callLater(_prefetchAround, index)
            return
        }

        // Cold path: load async, keep previous page on screen
        const ldr = _loaderAt(index)
        if (ldr && ldr.active)
            _fillLoader(ldr, index)
        generation++
        _evict()
        if (prefetchNeighbors)
            Qt.callLater(_prefetchAround, index)
    }

    function _prefetchAround(center) {
        if (!model)
            return
        const pair = [center - 1, center + 1]
        for (let i = 0; i < pair.length; ++i) {
            const n = pair[i]
            if (n < 0 || n >= model.length)
                continue
            _touchLru(n)
            _setKeep(n, true)
        }
        _evict()
    }

    function _warmAll() {
        if (!model || cacheMode === "none")
            return
        warmTimer.cursor = 0
        warmTimer.start()
    }

    Timer {
        id: warmTimer
        property int cursor: 0
        interval: 64
        repeat: true
        onTriggered: {
            if (!root.model) {
                stop()
                return
            }
            if (cursor < root.model.length) {
                root._touchLru(cursor)
                root._setKeep(cursor, true)
                cursor++
                root._evict()
            }
            if (cursor >= root.model.length)
                stop()
        }
    }

    Component.onCompleted: {
        _ensureKeepArray()
        _setKeep(currentIndex, true)
        _touchLru(currentIndex)
        displayedIndex = currentIndex
        generation++
        if (warmStart)
            Qt.callLater(_warmAll)
        else if (prefetchNeighbors)
            Qt.callLater(_prefetchAround, currentIndex)
    }

    onModelChanged: {
        lruOrder = []
        keepFlags = []
        if (model && currentIndex >= model.length)
            currentIndex = 0
        displayedIndex = currentIndex
        _ensureKeepArray()
        _setKeep(currentIndex, true)
        _touchLru(currentIndex)
        if (warmStart)
            Qt.callLater(_warmAll)
        else if (prefetchNeighbors)
            Qt.callLater(_prefetchAround, currentIndex)
    }

    onCacheModeChanged: _evict()
    onCacheLimitChanged: _evict()

    Rectangle {
        anchors.fill: parent
        color: {
            const w = Window.window
            if (w && w.usesSystemBackdrop) {
                const t = w.backdropContentTint !== undefined ? w.backdropContentTint : 0.42
                return Qt.alpha(Md3Theme.colorScheme.surface, t)
            }
            return Md3Theme.colorScheme.surface
        }
    }

    Repeater {
        id: pageRepeater
        model: root.model ? root.model.length : 0

        delegate: Loader {
            id: pageLoader
            required property int index

            anchors.fill: parent
            anchors.margins: root.contentPadding

            readonly property bool keep: root._shouldKeep(index)
            readonly property bool isDisplayed: index === root.displayedIndex
            readonly property bool isTarget: index === root.currentIndex

            active: keep
            visible: keep && isDisplayed
            enabled: visible
            // Always async — never block UI thread on QML compile
            asynchronous: true
            z: isDisplayed ? 2 : (isTarget ? 1 : 0)

            onActiveChanged: {
                if (active)
                    root._fillLoader(pageLoader, index)
                else {
                    source = ""
                    sourceComponent = null
                }
            }

            onKeepChanged: {
                if (keep && active)
                    root._fillLoader(pageLoader, index)
            }

            onLoaded: {
                if (item) {
                    item.width = Qt.binding(function () { return pageLoader.width })
                    item.height = Qt.binding(function () { return pageLoader.height })
                }
                if (index === root.currentIndex)
                    root._tryShow(index)
            }

            onStatusChanged: {
                if (status === Loader.Ready && index === root.currentIndex)
                    root._tryShow(index)
                if (status === Loader.Error)
                    console.warn("Md3PageHost: failed to load", source)
            }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: root.showBusyIndicator && root.loading && root.displayedIndex === root.currentIndex
        text: qsTr("Loading…")
        color: Md3Theme.colorScheme.colorOnSurfaceVariant
        font.family: Md3Theme.typography.fontFamily
        font.pixelSize: Md3Theme.typography.bodyMedium.size
        z: 10
    }

    Text {
        anchors.centerIn: parent
        width: parent.width - 48
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        visible: {
            const ldr = root._loaderAt(root.currentIndex)
            return !!(ldr && ldr.status === Loader.Error)
        }
        text: {
            const ldr = root._loaderAt(root.currentIndex)
            return qsTr("Failed to load page:\n%1").arg(ldr ? String(ldr.source) : "")
        }
        color: Md3Theme.colorScheme.error
        font.family: Md3Theme.typography.fontFamily
        font.pixelSize: Md3Theme.typography.bodyMedium.size
        z: 10
    }
}

import QtQuick
import QtQuick.Window

/*
  Instant navigation host with MD3 page transitions + skeleton loading:
  - Revisit: animated swap (or instant if pageTransition === "none")
  - Cold open: keep previous page, skeleton overlays as the incoming-page
    placeholder until Ready, then animate previous → next
  - cacheMode: "none" | "one" | "lru" | "all" | "adaptive"
    adaptive: keep more pages while the user is active; trim to 1 after idle
*/
Item {
    id: root

    property var model: []
    property int currentIndex: 0
    property int displayedIndex: 0
    property string cacheMode: "lru"
    property int cacheLimit: 4
    /// Adaptive: milliseconds without navigation before trimming to one page
    property int idleTrimMs: 45000
    /// Adaptive: minimum / starting resident pages while idle
    property int adaptiveCacheMin: 1
    property int _liveCacheLimit: 1
    property bool _adaptivePrefetch: false
    property real contentPadding: 20
    property bool asynchronous: true
    property bool prefetchNeighbors: false
    property bool warmStart: false
    property bool showBusyIndicator: false
    property bool showSkeleton: true
    property string skeletonLayout: "page"
    /// "none" | "fade" | "slide" | "slideUp" | "fadeThrough" | "scale"
    property string pageTransition: "fadeThrough"
    property int pageTransitionDuration: Md3Motion.spatialDuration
    property url sourceBase: ""

    readonly property var currentItem: {
        const ldr = _loaderAt(displayedIndex)
        return ldr && ldr.item ? ldr.item : null
    }
    readonly property bool loading: {
        const ldr = _loaderAt(currentIndex)
        return currentIndex !== displayedIndex
                || !!(ldr && ldr.status === Loader.Loading)
                || transitioning
    }
    /// True while the destination page is loading and not yet Ready.
    readonly property bool awaitingTarget: {
        if (currentIndex === displayedIndex || transitioning)
            return false
        const ldr = _loaderAt(currentIndex)
        return !ldr || ldr.status !== Loader.Ready || !ldr.item
    }

    property var keepFlags: []
    property var lruOrder: []
    property int generation: 0

    property bool transitioning: false
    property int transitionFrom: -1
    property int transitionTo: -1
    property int transitionDir: 1
    property real transitionProgress: 1

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

    function noteActivity() {
        if (cacheMode !== "adaptive")
            return
        // Grow toward cacheLimit while the user keeps navigating
        _liveCacheLimit = Math.min(cacheLimit, Math.max(adaptiveCacheMin, _liveCacheLimit + 1))
        _adaptivePrefetch = _liveCacheLimit >= 2
        idleTrimTimer.interval = Math.max(5000, idleTrimMs)
        idleTrimTimer.restart()
        generation++
        _evict()
        if (_adaptivePrefetch)
            Qt.callLater(_prefetchAround, currentIndex)
    }

    function _trimForIdle() {
        if (cacheMode !== "adaptive")
            return
        _liveCacheLimit = adaptiveCacheMin
        _adaptivePrefetch = false
        generation++
        _evict()
    }

    function _effectiveLimit() {
        if (cacheMode === "adaptive")
            return Math.max(1, _liveCacheLimit)
        return cacheLimit
    }

    function _shouldKeep(index) {
        root.generation
        if (index === displayedIndex || index === currentIndex)
            return true
        if (transitioning && (index === transitionFrom || index === transitionTo))
            return true
        if (index < 0 || index >= keepFlags.length)
            return false
        if (!keepFlags[index])
            return false
        if (cacheMode === "all")
            return true
        if (cacheMode === "one")
            return false
        if (cacheMode === "lru" || cacheMode === "adaptive")
            return true
        return false
    }

    function _evict() {
        if (cacheMode === "all" || cacheMode === "none")
            return
        if (cacheMode === "one"
                || (cacheMode === "adaptive" && _effectiveLimit() <= 1)) {
            for (let i = 0; i < keepFlags.length; ++i) {
                if (i !== displayedIndex && i !== currentIndex
                        && !(transitioning && (i === transitionFrom || i === transitionTo))
                        && keepFlags[i])
                    _setKeep(i, false)
            }
            return
        }
        const limit = _effectiveLimit()
        const protectedIdx = {}
        protectedIdx[displayedIndex] = true
        protectedIdx[currentIndex] = true
        if (transitioning) {
            protectedIdx[transitionFrom] = true
            protectedIdx[transitionTo] = true
        }
        let kept = 0
        const order = lruOrder.slice()
        for (let i = order.length - 1; i >= 0; --i) {
            const idx = order[i]
            if (protectedIdx[idx]) {
                kept++
                continue
            }
            if (kept < limit) {
                kept++
                continue
            }
            _setKeep(idx, false)
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

    function _finishTransition() {
        if (transitionTo >= 0)
            displayedIndex = transitionTo
        transitioning = false
        transitionFrom = -1
        transitionTo = -1
        transitionProgress = 1
        generation++
        _evict()
        if (prefetchNeighbors)
            Qt.callLater(_prefetchAround, displayedIndex)
    }

    function _startTransition(fromIndex, toIndex) {
        // onLoaded + onStatusChanged both call _tryShow — ignore duplicate
        if (transitioning && transitionTo === toIndex)
            return
        if (pageAnim.running) {
            pageAnim.stop()
            if (transitionTo >= 0)
                displayedIndex = transitionTo
            transitioning = false
            transitionFrom = -1
            transitionTo = -1
            transitionProgress = 1
            fromIndex = displayedIndex
        }
        if (pageTransition === "none" || fromIndex === toIndex) {
            displayedIndex = toIndex
            transitioning = false
            transitionProgress = 1
            _evict()
            return
        }
        // fromIndex < 0 → enter-only (initial / no previous page)

        transitionFrom = fromIndex
        transitionTo = toIndex
        transitionDir = (fromIndex < 0 || toIndex >= fromIndex) ? 1 : -1
        transitioning = true
        transitionProgress = 0
        if (fromIndex >= 0)
            _setKeep(fromIndex, true)
        _setKeep(toIndex, true)
        generation++
        pageAnim.start()
    }

    function _tryShow(index) {
        const ldr = _loaderAt(index)
        if (!ldr)
            return false
        if (ldr.status === Loader.Ready && ldr.item) {
            if (displayedIndex !== index)
                _startTransition(displayedIndex, index)
            return true
        }
        return false
    }

    function navigateTo(index) {
        if (!model || index < 0 || index >= model.length)
            return
        if (transitioning && index === transitionTo)
            return

        currentIndex = index
        _touchLru(index)
        _setKeep(index, true)
        noteActivity()

        // Hot path: already Ready → transition (or instant)
        if (_tryShow(index)) {
            if (!transitioning)
                _evict()
            if (prefetchNeighbors || _adaptivePrefetch)
                Qt.callLater(_prefetchAround, index)
            return
        }

        // Cold path: keep previous page visible; skeleton sits on top as the
        // incoming-page placeholder until Ready, then full leave→enter transition.
        if (pageAnim.running) {
            pageAnim.stop()
            if (transitionTo >= 0 && transitionTo !== index)
                displayedIndex = transitionTo
            transitioning = false
            transitionFrom = -1
            transitionTo = -1
            transitionProgress = 1
        }
        generation++

        const ldr = _loaderAt(index)
        if (ldr && ldr.active)
            _fillLoader(ldr, index)
        else if (ldr)
            _setKeep(index, true)
        _evict()
        if (prefetchNeighbors || _adaptivePrefetch)
            Qt.callLater(_prefetchAround, index)
    }

    function _prefetchAround(center) {
        if (!model)
            return
        if (!(prefetchNeighbors || _adaptivePrefetch))
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
        id: idleTrimTimer
        interval: Math.max(5000, root.idleTrimMs)
        repeat: false
        onTriggered: root._trimForIdle()
    }

    NumberAnimation {
        id: pageAnim
        target: root
        property: "transitionProgress"
        from: 0
        to: 1
        duration: root.pageTransitionDuration
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Md3Motion.emphasized
        onFinished: root._finishTransition()
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
        if (cacheMode === "adaptive") {
            _liveCacheLimit = adaptiveCacheMin
            idleTrimTimer.restart()
        }
        if (warmStart)
            Qt.callLater(_warmAll)
        else if (prefetchNeighbors || _adaptivePrefetch)
            Qt.callLater(_prefetchAround, currentIndex)
    }

    onModelChanged: {
        if (pageAnim.running)
            pageAnim.stop()
        transitioning = false
        lruOrder = []
        keepFlags = []
        if (model && currentIndex >= model.length)
            currentIndex = 0
        displayedIndex = currentIndex
        _ensureKeepArray()
        _setKeep(currentIndex, true)
        _touchLru(currentIndex)
        if (cacheMode === "adaptive")
            _liveCacheLimit = adaptiveCacheMin
        if (warmStart)
            Qt.callLater(_warmAll)
        else if (prefetchNeighbors || _adaptivePrefetch)
            Qt.callLater(_prefetchAround, currentIndex)
    }

    onCacheModeChanged: {
        if (cacheMode === "adaptive") {
            _liveCacheLimit = adaptiveCacheMin
            idleTrimTimer.restart()
        }
        _evict()
    }
    onCacheLimitChanged: _evict()
    onIdleTrimMsChanged: {
        idleTrimTimer.interval = Math.max(5000, idleTrimMs)
    }

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
            readonly property bool isLeaving: root.transitioning && index === root.transitionFrom
            readonly property bool isEntering: root.transitioning && index === root.transitionTo
            readonly property real t: root.transitionProgress
            readonly property string mode: root.pageTransition
            readonly property int dir: root.transitionDir

            active: keep
            enabled: (isDisplayed && !root.transitioning) || isEntering
            asynchronous: true
            z: isEntering ? 3 : (isLeaving ? 2 : (isDisplayed ? 1 : 0))

            opacity: {
                if (isEntering) {
                    if (mode === "fadeThrough")
                        return t < 0.35 ? 0 : (t - 0.35) / 0.65
                    return t
                }
                if (isLeaving) {
                    if (mode === "fadeThrough")
                        return t < 0.35 ? (1 - t / 0.35) : 0
                    return 1 - t
                }
                if (isDisplayed && !root.transitioning)
                    return 1
                return 0
            }

            transform: [
                Translate {
                    x: {
                        if (mode !== "slide")
                            return 0
                        const w = pageLoader.width
                        if (isEntering)
                            return (1 - pageLoader.t) * w * pageLoader.dir
                        if (isLeaving)
                            return pageLoader.t * w * (-pageLoader.dir)
                        return 0
                    }
                    y: {
                        if (mode !== "slideUp")
                            return 0
                        const h = pageLoader.height
                        if (isEntering)
                            return (1 - pageLoader.t) * h * 0.08
                        if (isLeaving)
                            return pageLoader.t * h * (-0.04)
                        return 0
                    }
                },
                Scale {
                    origin.x: pageLoader.width / 2
                    origin.y: pageLoader.height / 2
                    xScale: {
                        if (mode !== "scale" && mode !== "fadeThrough")
                            return 1
                        if (isEntering) {
                            if (mode === "fadeThrough")
                                return 0.92 + 0.08 * pageLoader.t
                            return 0.94 + 0.06 * pageLoader.t
                        }
                        if (isLeaving) {
                            if (mode === "fadeThrough")
                                return 1 - 0.04 * pageLoader.t
                            return 1 - 0.06 * pageLoader.t
                        }
                        return 1
                    }
                    yScale: {
                        if (mode !== "scale" && mode !== "fadeThrough")
                            return 1
                        if (isEntering) {
                            if (mode === "fadeThrough")
                                return 0.92 + 0.08 * pageLoader.t
                            return 0.94 + 0.06 * pageLoader.t
                        }
                        if (isLeaving) {
                            if (mode === "fadeThrough")
                                return 1 - 0.04 * pageLoader.t
                            return 1 - 0.06 * pageLoader.t
                        }
                        return 1
                    }
                }
            ]

            visible: keep && (opacity > 0.01 || isDisplayed || isEntering || isLeaving)

            onActiveChanged: {
                if (active) {
                    root._fillLoader(pageLoader, index)
                } else {
                    // Drop compiled tree promptly to reclaim memory
                    source = ""
                    sourceComponent = null
                    if (typeof setSource === "function")
                        setSource("")
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

    // Incoming-page placeholder: stacked above the still-visible previous page
    Rectangle {
        id: skeletonHost
        anchors.fill: parent
        anchors.margins: root.contentPadding
        z: 8
        radius: Md3Theme.shape.large
        color: {
            const w = Window.window
            if (w && w.usesSystemBackdrop) {
                const t = w.backdropContentTint !== undefined ? w.backdropContentTint : 0.42
                return Qt.alpha(Md3Theme.colorScheme.surface, Math.max(0.92, t))
            }
            return Md3Theme.colorScheme.surface
        }
        readonly property bool show: root.showSkeleton && root.awaitingTarget
        visible: opacity > 0.01
        opacity: show ? 1 : 0
        scale: show ? 1 : 0.98
        transformOrigin: Item.Center

        Behavior on opacity {
            NumberAnimation {
                duration: Md3Motion.short3
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: Md3Motion.short3
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasizedDecelerate
            }
        }

        Md3SkeletonPane {
            anchors.fill: parent
            layout: root.skeletonLayout
            active: skeletonHost.show
        }
    }

    Text {
        anchors.centerIn: parent
        visible: root.showBusyIndicator && root.awaitingTarget && !root.showSkeleton
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

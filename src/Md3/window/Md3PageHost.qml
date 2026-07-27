import QtQuick
import QtQuick.Effects
import QtQuick.Window

/*
  Instant navigation host with MD3 / WinUI-style page transitions:
  - Revisit (L1 cached): animated swap (or instant if pageTransition === "none")
  - Cold open: sync/async Loader; optional L2 QQmlComponent reuse
  - cacheMode: "none" | "one" | "lru" | "all" | "adaptive" | "arc"
    adaptive: grow toward cacheLimit while active; trim after idle (ARC victims)
    arc: ARC (recency+frequency+ghost) + cost-aware victim pick; optional idle trim
  - L2: keep compiled Component after Item teardown (cheap warm re-open)
  - Prefetch: ±1 neighbors, Markov next-hop, rail hover hint
  Defaults tuned for snappy switch + low RSS (L1=1, no full L2 warm-all).
*/
Item {
    id: root
    enum LaunchIntensity { Subtle, Normal, Premium }

    property var model: []
    property int currentIndex: 0
    property int displayedIndex: 0
    property string cacheMode: "arc"
    /// Resident Item pages — keep at 1 for low memory (current only after idle trim)
    property int cacheLimit: 1
    /// Adaptive / arc: ms without navigation before trimming to adaptiveCacheMin
    property int idleTrimMs: 4000
    property int adaptiveCacheMin: 1
    property int _liveCacheLimit: 1
    property bool _adaptivePrefetch: false
    property real contentPadding: 20
    property bool asynchronous: false
    property bool prefetchNeighbors: false
    property bool l2Components: true
    /// Few compiled Components — enough for back/forward, not every destination
    property int l2CacheLimit: 1
    /// If true, only warm L2 for current ±1 + Markov (never full destination list)
    property bool l2WarmIdle: false
    property bool predictPrefetch: false
    /// Off by default: ShaderEffectSource holds a full-size GPU texture
    property bool leaveSnapshot: false
    property bool warmStart: false
    property bool showBusyIndicator: false
    property bool showSkeleton: false
    property string skeletonLayout: "page"
    /// "none" | "fade" | "slide" | "slideUp" | "fadeThrough" | "scale" | "launch"
    property string pageTransition: "fade"
    property int pageTransitionDuration: 100
    /// Duration used by nonlinear tap-origin launch transition.
    property int launchTransitionDuration: Md3Motion.long2
    /// Subtle/Normal/Premium controls launch spring feel and visual strength.
    property int launchIntensity: Md3PageHost.Normal
    /// Keep X/Y motion progression proportional to travel distance.
    property bool launchAxisProportional: true
    property bool launchRememberLastSource: true
    property var lastLaunchSourceRect: Qt.rect(0, 0, 0, 0)
    property real lastLaunchSourceRadius: 0
    property int lastLaunchSourceIndex: -1
    property int lastLaunchTargetIndex: -1
    property url sourceBase: ""
    clip: true

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

    // --- ARC directory (indices only; ghosts hold no Item / Component) ---
    property var _arcT1: []
    property var _arcT2: []
    property var _arcB1: []
    property var _arcB2: []
    property real _arcP: 0

    // --- L2 Component map (url string → Component) ---
    property var _l2Map: ({})
    property var _l2Order: []

    // --- Markov transitions: fromIndex → { toIndex: count } ---
    property var _markov: ({})
    property int _navPrev: -1
    property int _hoverHint: -1

    property bool transitioning: false
    property int transitionFrom: -1
    property int transitionTo: -1
    property int transitionDir: 1
    property string transitionModeActive: pageTransition
    property real transitionProgress: 1
    property var _pendingNavOpts: ({})
    property bool launchReturning: false
    property rect launchStartRect: Qt.rect(0, 0, 0, 0)
    property rect launchEndRect: Qt.rect(0, 0, 0, 0)
    property real launchStartRadius: 16
    property real launchEndRadius: Md3Theme.shape.large
    property var launchCurveX: [0.0, 0.0, 0.2, 1.0]
    property var launchCurveY: Md3Motion.emphasizedDecelerate
    property real launchWeightX: 0.5
    property real launchWeightY: 0.5
    /// Defer enter transition after Loader.Ready (unused; kept for API stability).
    property int _pendingShowIndex: -1
    property int _pendingShowPasses: 0

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

    function _contentRect() {
        const w = Math.max(1, width - contentPadding * 2)
        const h = Math.max(1, height - contentPadding * 2)
        return Qt.rect(contentPadding, contentPadding, w, h)
    }

    function _clampRect(rect, fallback) {
        const f = fallback || _contentRect()
        if (!rect || rect.width <= 1 || rect.height <= 1)
            return f
        const x = Math.max(f.x, Math.min(rect.x, f.x + f.width - 1))
        const y = Math.max(f.y, Math.min(rect.y, f.y + f.height - 1))
        const rw = Math.max(1, Math.min(rect.width, f.width))
        const rh = Math.max(1, Math.min(rect.height, f.height))
        return Qt.rect(x, y, rw, rh)
    }

    function _bezierAt(t, curve) {
        const c = curve || Md3Motion.emphasized
        const p1x = Number(c[0]), p1y = Number(c[1]), p2x = Number(c[2]), p2y = Number(c[3])
        const u = Math.max(0, Math.min(1, t))
        // Use parametric cubic in time-space as a cheap, smooth approximation.
        const inv = 1 - u
        const y = 3 * inv * inv * u * p1y
                + 3 * inv * u * u * p2y
                + u * u * u
        return Math.max(0, Math.min(1, y))
    }

    function _launchProgressX(t) {
        const base = _bezierAt(t, launchCurveX)
        if (!launchAxisProportional)
            return base
        const ratio = 0.72 + 0.56 * launchWeightX
        return Math.pow(base, 1 / Math.max(0.35, ratio))
    }

    function _launchProgressY(t) {
        const base = _bezierAt(t, launchCurveY)
        if (!launchAxisProportional)
            return base
        const ratio = 0.72 + 0.56 * launchWeightY
        return Math.pow(base, 1 / Math.max(0.35, ratio))
    }

    function _launchBlend(start, end, p) {
        return start + (end - start) * p
    }

    function _launchPulse(t) {
        const p = Math.max(0, Math.min(1, t))
        const amp = launchIntensity === Md3PageHost.Premium ? 1
                  : (launchIntensity === Md3PageHost.Subtle ? 0.45 : 0.7)
        if (p < 0.10)
            return 1.0 - 0.05 * amp * (p / 0.10)
        if (p < 0.24)
            return 1.0 - 0.05 * amp + 0.10 * amp * ((p - 0.10) / 0.14)
        if (p < 0.40)
            return 1.0 + 0.05 * amp - 0.05 * amp * ((p - 0.24) / 0.16)
        return 1.0
    }

    function _launchBackdropOpacity() {
        if (transitionModeActive !== "launch" || !transitioning)
            return 0
        const k = launchIntensity === Md3PageHost.Premium ? 1.0
                : (launchIntensity === Md3PageHost.Subtle ? 0.62 : 0.8)
        return launchReturning
                ? Math.max(0, 0.30 * k * (1 - transitionProgress))
                : Math.max(0, 0.55 * k * (1 - transitionProgress))
    }

    function _launchBackdropBlur() {
        if (transitionModeActive !== "launch" || !transitioning)
            return 0
        const k = launchIntensity === Md3PageHost.Premium ? 1.0
                : (launchIntensity === Md3PageHost.Subtle ? 0.62 : 0.8)
        return launchReturning
                ? Math.max(0, 0.18 * k * (1 - transitionProgress))
                : Math.min(0.35 * k, 0.08 * k + transitionProgress * 0.27 * k)
    }

    function _usesArc() {
        return cacheMode === "arc" || cacheMode === "adaptive"
    }

    function _pageCost(index) {
        const e = entryAt(index)
        if (!e)
            return 1
        if (e.cacheCost !== undefined && e.cacheCost !== null)
            return Math.max(0.25, Number(e.cacheCost))
        const src = String(e.source || "")
        const title = String(e.title || e.label || "")
        if (/Charts|chart/i.test(src) || /图表/.test(title))
            return 3
        if (/scenes\//i.test(src) || /Scene|场景/.test(title))
            return 2.5
        if (/Theme|Motion|Extras|Containment/i.test(src))
            return 1.5
        return 1
    }

    function _isPinned(index) {
        const e = entryAt(index)
        return !!(e && e.cachePin)
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
        // Avoid tearing down a page mid-incubation (async Loader) — wait until Ready/Error.
        if (!on) {
            const loader = pageRepeater.itemAt(index)
            if (loader && loader.status === Loader.Loading) {
                loader.pendingUnload = true
                if (!loader.awaitUnload) {
                    loader.awaitUnload = true
                    const finish = function () {
                        if (loader.status === Loader.Loading)
                            return
                        loader.statusChanged.disconnect(finish)
                        loader.awaitUnload = false
                        const wantUnload = !!loader.pendingUnload
                        loader.pendingUnload = false
                        if (!wantUnload)
                            return
                        if (index === root.currentIndex || index === root.displayedIndex)
                            return
                        root._setKeep(index, false)
                    }
                    loader.statusChanged.connect(finish)
                }
                return
            }
        } else {
            const loader = pageRepeater.itemAt(index)
            if (loader)
                loader.pendingUnload = false
        }
        const next = keepFlags.slice()
        next[index] = on
        keepFlags = next
        generation++
    }

    function _listRemove(list, value) {
        const out = []
        for (let i = 0; i < list.length; ++i) {
            if (list[i] !== value)
                out.push(list[i])
        }
        return out
    }

    function _listContains(list, value) {
        for (let i = 0; i < list.length; ++i) {
            if (list[i] === value)
                return true
        }
        return false
    }

    function _listPushMru(list, value) {
        const out = _listRemove(list, value)
        out.push(value)
        return out
    }

    function _listTakeLru(list) {
        if (!list.length)
            return { list: list, value: -1 }
        return { list: list.slice(1), value: list[0] }
    }

    function _listTakeCostVictim(list) {
        // Prefer highest cacheCost near the LRU end (scan up to 4 LRU candidates)
        if (!list.length)
            return { list: list, value: -1 }
        const scan = Math.min(4, list.length)
        let bestPos = 0
        let bestCost = -1
        for (let i = 0; i < scan; ++i) {
            const idx = list[i]
            if (_isPinned(idx) || idx === displayedIndex || idx === currentIndex)
                continue
            if (transitioning && (idx === transitionFrom || idx === transitionTo))
                continue
            const c = _pageCost(idx)
            if (c > bestCost) {
                bestCost = c
                bestPos = i
            }
        }
        // If all scanned were protected, fall through to classic LRU skip-protected
        if (bestCost < 0) {
            for (let j = 0; j < list.length; ++j) {
                const idx = list[j]
                if (_isPinned(idx) || idx === displayedIndex || idx === currentIndex)
                    continue
                if (transitioning && (idx === transitionFrom || idx === transitionTo))
                    continue
                bestPos = j
                bestCost = 0
                break
            }
        }
        if (bestCost < 0)
            return { list: list, value: -1 }
        const victim = list[bestPos]
        const out = list.slice(0, bestPos).concat(list.slice(bestPos + 1))
        return { list: out, value: victim }
    }

    function _touchLru(index) {
        if (index < 0)
            return
        lruOrder = _listPushMru(lruOrder, index)
    }

    function _recordMarkov(from, to) {
        if (from < 0 || to < 0 || from === to)
            return
        const key = String(from)
        const row = Object.assign({}, _markov[key] || {})
        const tk = String(to)
        row[tk] = (row[tk] || 0) + 1
        const next = Object.assign({}, _markov)
        next[key] = row
        _markov = next
    }

    function _markovPredict(from) {
        if (from < 0)
            return -1
        const row = _markov[String(from)]
        if (!row)
            return -1
        let best = -1
        let bestC = 0
        for (const k in row) {
            const c = row[k]
            if (c > bestC) {
                bestC = c
                best = Number(k)
            }
        }
        return best
    }

    function noteActivity() {
        if (cacheMode !== "adaptive" && cacheMode !== "arc")
            return
        _liveCacheLimit = Math.min(cacheLimit, Math.max(adaptiveCacheMin, _liveCacheLimit + 1))
        // Do not auto-inflate L1 neighbors — only explicit prefetchNeighbors.
        _adaptivePrefetch = false
        idleTrimTimer.interval = Math.max(2000, idleTrimMs)
        idleTrimTimer.restart()
        generation++
        _evict()
        Qt.callLater(_prefetchSmart, currentIndex)
    }

    function _trimForIdle() {
        if (cacheMode !== "adaptive" && cacheMode !== "arc")
            return
        _liveCacheLimit = adaptiveCacheMin
        _adaptivePrefetch = false
        generation++
        _evict()
        _trimL2()
        _dismissLeaveSnapshot(true)
    }

    function _armLeaveSnapshot() {
        if (!leaveSnapshot)
            return
        const ldr = _loaderAt(displayedIndex)
        if (!ldr || !ldr.item)
            return
        leaveSnapFade.stop()
        // Half-res texture: enough for a brief hold, ~4× less GPU memory
        leaveSnap.textureSize = Qt.size(
                    Math.max(1, Math.floor(width / 2)),
                    Math.max(1, Math.floor(height / 2)))
        leaveSnap.sourceItem = ldr
        leaveSnap.scheduleUpdate()
        leaveSnap.opacity = 1
    }

    function _dismissLeaveSnapshot(immediate) {
        if (!leaveSnap.sourceItem && leaveSnap.opacity < 0.01)
            return
        if (immediate) {
            leaveSnapFade.stop()
            leaveSnap.opacity = 0
            leaveSnap.sourceItem = null
            return
        }
        leaveSnapFade.start()
    }

    function _effectiveLimit() {
        if (cacheMode === "adaptive" || cacheMode === "arc")
            return Math.max(1, _liveCacheLimit)
        return cacheLimit
    }

    function _shouldKeep(index) {
        root.generation
        if (index === displayedIndex || index === currentIndex)
            return true
        if (transitioning && (index === transitionFrom || index === transitionTo))
            return true
        if (_isPinned(index) && keepFlags.length > index && keepFlags[index])
            return true
        if (index < 0 || index >= keepFlags.length)
            return false
        if (!keepFlags[index])
            return false
        if (cacheMode === "all")
            return true
        if (cacheMode === "one")
            return false
        if (cacheMode === "lru" || cacheMode === "adaptive" || cacheMode === "arc")
            return true
        return false
    }

    function _protectedSet() {
        const p = {}
        p[displayedIndex] = true
        p[currentIndex] = true
        if (transitioning) {
            p[transitionFrom] = true
            p[transitionTo] = true
        }
        // cachePin: never evict once resident — do not force-load unvisited pins
        if (model && keepFlags.length === model.length) {
            for (let i = 0; i < model.length; ++i) {
                if (_isPinned(i) && keepFlags[i])
                    p[i] = true
            }
        }
        return p
    }

    function _syncKeepFromArc() {
        const inArc = {}
        for (let i = 0; i < _arcT1.length; ++i)
            inArc[_arcT1[i]] = true
        for (let j = 0; j < _arcT2.length; ++j)
            inArc[_arcT2[j]] = true
        const prot = _protectedSet()
        _ensureKeepArray()
        const next = keepFlags.slice()
        for (let k = 0; k < next.length; ++k)
            next[k] = !!(inArc[k] || prot[k])
        keepFlags = next
        generation++
    }

    function _arcReplaceToward(xInB2) {
        const c = _effectiveLimit()
        const p = Math.min(c, Math.max(0, _arcP))
        const t1Len = _arcT1.length
        let victim = -1
        if (t1Len >= 1 && (t1Len > p || (xInB2 && t1Len === Math.floor(p)))) {
            const r = _listTakeCostVictim(_arcT1)
            _arcT1 = r.list
            victim = r.value
            if (victim >= 0)
                _arcB1 = _listPushMru(_arcB1, victim)
        } else {
            const r = _listTakeCostVictim(_arcT2)
            _arcT2 = r.list
            victim = r.value
            if (victim >= 0)
                _arcB2 = _listPushMru(_arcB2, victim)
        }
        if (victim >= 0)
            _ensureL2(victim) // demote Item → keep Component
        return victim
    }

    function _arcGhostTrim() {
        const c = _effectiveLimit()
        const maxGhost = Math.max(c, 1)
        while (_arcB1.length > maxGhost)
            _arcB1 = _arcB1.slice(1)
        while (_arcB2.length > maxGhost)
            _arcB2 = _arcB2.slice(1)
        const total = _arcT1.length + _arcT2.length + _arcB1.length + _arcB2.length
        if (total > 2 * c && _arcB2.length)
            _arcB2 = _arcB2.slice(1)
    }

    /// ARC request: updates T1/T2/B1/B2 and L1 keepFlags.
    function _arcRequest(index) {
        if (index < 0 || !model || index >= model.length)
            return
        const c = Math.max(1, _effectiveLimit())
        const inT1 = _listContains(_arcT1, index)
        const inT2 = _listContains(_arcT2, index)
        if (inT1 || inT2) {
            _arcT1 = _listRemove(_arcT1, index)
            _arcT2 = _listPushMru(_arcT2, index)
            _syncKeepFromArc()
            return
        }

        const inB1 = _listContains(_arcB1, index)
        const inB2 = _listContains(_arcB2, index)
        if (inB1) {
            const delta = Math.max(1, Math.floor((_arcB2.length || 1) / Math.max(1, _arcB1.length)))
            _arcP = Math.min(c, _arcP + delta)
            if (_arcT1.length + _arcT2.length >= c)
                _arcReplaceToward(false)
            _arcB1 = _listRemove(_arcB1, index)
            _arcT2 = _listPushMru(_arcT2, index)
        } else if (inB2) {
            const delta = Math.max(1, Math.floor((_arcB1.length || 1) / Math.max(1, _arcB2.length)))
            _arcP = Math.max(0, _arcP - delta)
            if (_arcT1.length + _arcT2.length >= c)
                _arcReplaceToward(true)
            _arcB2 = _listRemove(_arcB2, index)
            _arcT2 = _listPushMru(_arcT2, index)
        } else {
            if (_arcT1.length + _arcT2.length >= c) {
                _arcReplaceToward(false)
            } else if (_arcT1.length + _arcT2.length + _arcB1.length + _arcB2.length >= c) {
                if (_arcT1.length + _arcT2.length + _arcB1.length + _arcB2.length >= 2 * c
                        && _arcB2.length)
                    _arcB2 = _arcB2.slice(1)
                if (_arcB1.length)
                    _arcB1 = _arcB1.slice(1)
            }
            _arcT1 = _listPushMru(_arcT1, index)
        }
        _arcGhostTrim()
        _syncKeepFromArc()
    }

    function _evictLru() {
        const limit = _effectiveLimit()
        const protectedIdx = _protectedSet()
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
            _ensureL2(idx)
            _setKeep(idx, false)
            lruOrder = _listRemove(lruOrder, idx)
        }
    }

    function _evict() {
        if (cacheMode === "all" || cacheMode === "none")
            return
        if (cacheMode === "one"
                || ((cacheMode === "adaptive" || cacheMode === "arc")
                    && _effectiveLimit() <= 1)) {
            for (let i = 0; i < keepFlags.length; ++i) {
                if (!_protectedSet()[i] && keepFlags[i]) {
                    _ensureL2(i)
                    _setKeep(i, false)
                }
            }
            if (_usesArc()) {
                // Keep only protected (+ pinned) in ARC directories
                const prot = _protectedSet()
                const filter = function (list) {
                    const out = []
                    for (let i = 0; i < list.length; ++i) {
                        if (prot[list[i]])
                            out.push(list[i])
                    }
                    return out
                }
                _arcT1 = filter(_arcT1)
                _arcT2 = filter(_arcT2)
            }
            return
        }
        if (_usesArc()) {
            // Shrink T1∪T2 down to limit via ARC replace
            let guard = 0
            while (_arcT1.length + _arcT2.length > _effectiveLimit() && guard++ < 64)
                _arcReplaceToward(false)
            _syncKeepFromArc()
            return
        }
        _evictLru()
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

    function _ensureL2(index) {
        if (!l2Components || index < 0)
            return null
        const inline = _compFor(index)
        if (inline)
            return inline
        const url = _urlFor(index)
        if (!url)
            return null
        let comp = _l2Map[url]
        if (comp && (comp.status === Component.Ready || comp.status === Component.Loading)) {
            _l2Order = _listPushMru(_l2Order, url)
            return comp
        }
        comp = Qt.createComponent(url)
        if (!comp)
            return null
        const next = Object.assign({}, _l2Map)
        next[url] = comp
        _l2Map = next
        _l2Order = _listPushMru(_l2Order, url)
        _trimL2()
        return comp
    }

    function _trimL2() {
        if (!l2Components)
            return
        const limit = Math.max(0, l2CacheLimit)
        const liveUrls = {}
        if (model) {
            for (let i = 0; i < model.length; ++i) {
                if (keepFlags.length > i && keepFlags[i]) {
                    const u = _urlFor(i)
                    if (u)
                        liveUrls[u] = true
                }
            }
        }
        while (_l2Order.length > limit) {
            let dropped = false
            for (let j = 0; j < _l2Order.length; ++j) {
                const url = _l2Order[j]
                if (liveUrls[url])
                    continue
                _l2Order = _listRemove(_l2Order, url)
                const doomed = _l2Map[url]
                const next = Object.assign({}, _l2Map)
                delete next[url]
                _l2Map = next
                if (doomed && typeof doomed.destroy === "function")
                    doomed.destroy()
                dropped = true
                break
            }
            if (!dropped)
                break
        }
    }

    function _fillLoader(loader, index) {
        if (!loader)
            return
        const inline = _compFor(index)
        if (inline) {
            if (loader.source !== "")
                loader.source = ""
            if (loader.sourceComponent !== inline)
                loader.sourceComponent = inline
            return
        }
        const l2 = _ensureL2(index)
        if (l2 && l2.status === Component.Ready) {
            if (loader.source !== "")
                loader.source = ""
            if (loader.sourceComponent !== l2)
                loader.sourceComponent = l2
            return
        }
        const url = _urlFor(index)
        if (loader.sourceComponent !== null)
            loader.sourceComponent = null
        if (String(loader.source) !== url)
            loader.source = url
    }

    /// Soft-warm: L2 only unless allowL1; never inflates beyond cacheLimit.
    function _warmPage(index, allowL1) {
        if (!model || index < 0 || index >= model.length)
            return
        _ensureL2(index)
        if (!allowL1)
            return
        if (_usesArc())
            _arcRequest(index)
        else {
            _touchLru(index)
            _setKeep(index, true)
            _evict()
        }
    }

    function prefetchHint(index) {
        if (!predictPrefetch)
            return
        if (!model || index < 0 || index >= model.length)
            return
        _hoverHint = index
        hoverPrefetchTimer.restart()
    }

    function clearPrefetchHint(index) {
        if (_hoverHint === index)
            _hoverHint = -1
    }

    function _finishTransition() {
        if (transitionTo >= 0)
            displayedIndex = transitionTo
        transitioning = false
        transitionFrom = -1
        transitionTo = -1
        transitionModeActive = pageTransition
        transitionProgress = 1
        launchReturning = false
        generation++
        _dismissLeaveSnapshot(false)
        _evict()
        Qt.callLater(_prefetchSmart, displayedIndex)
    }

    function _prepareLaunchTransition(fromIndex, toIndex, opts) {
        const content = _contentRect()
        const seed = launchIntensity === Md3PageHost.Premium ? 10
                   : (launchIntensity === Md3PageHost.Subtle ? 20 : 14)
        let src = Qt.rect(content.x + content.width * 0.5 - seed / 2,
                          content.y + content.height * 0.5 - seed / 2, seed, seed)
        let srcRadius = Math.min(src.width, src.height) / 2
        const wantReturn = !!(opts && opts.returnToSource)
        if (wantReturn) {
            launchReturning = true
            const remembered = lastLaunchSourceRect && lastLaunchSourceRect.width > 1
                             ? lastLaunchSourceRect
                             : src
            const r = opts && opts.sourceRect ? opts.sourceRect : remembered
            src = _clampRect(r, content)
            srcRadius = Number(opts && opts.sourceRadius !== undefined
                               ? opts.sourceRadius
                               : lastLaunchSourceRadius)
            if (!(srcRadius > 0))
                srcRadius = Math.min(src.width, src.height) / 2
            launchStartRect = content
            launchEndRect = src
            launchStartRadius = Md3Theme.shape.large
            launchEndRadius = srcRadius
            return
        }

        launchReturning = false
        if (opts && opts.sourcePoint && opts.sourcePoint.x !== undefined && opts.sourcePoint.y !== undefined) {
            const px = Number(opts.sourcePoint.x)
            const py = Number(opts.sourcePoint.y)
            src = _clampRect(Qt.rect(px - seed / 2, py - seed / 2, seed, seed), content)
        } else if (opts && opts.sourceRect)
            src = _clampRect(opts.sourceRect, content)
        srcRadius = Number(opts && opts.sourceRadius !== undefined
                           ? opts.sourceRadius
                           : Math.min(src.width, src.height) / 2)
        if (!(srcRadius >= 0))
            srcRadius = Math.min(src.width, src.height) / 2
        launchStartRect = src
        launchEndRect = content
        launchStartRadius = srcRadius
        launchEndRadius = Md3Theme.shape.large
        const sx = src.x + src.width / 2
        const sy = src.y + src.height / 2
        const ex = content.x + content.width / 2
        const ey = content.y + content.height / 2
        const dx = Math.abs(ex - sx) + Math.abs(content.width - src.width) * 0.35
        const dy = Math.abs(ey - sy) + Math.abs(content.height - src.height) * 0.35
        const sum = Math.max(1, dx + dy)
        launchWeightX = dx / sum
        launchWeightY = dy / sum
        if (launchIntensity === Md3PageHost.Premium) {
            launchCurveX = [0.0, 0.0, 0.18, 1.0]
            launchCurveY = Md3Motion.emphasizedDecelerate
        } else if (launchIntensity === Md3PageHost.Subtle) {
            launchCurveX = Md3Motion.standard
            launchCurveY = Md3Motion.standardDecelerate
        } else {
            launchCurveX = [0.0, 0.0, 0.2, 1.0]
            launchCurveY = Md3Motion.emphasizedDecelerate
        }
        if ((opts && opts.rememberSource !== false) || (!opts && launchRememberLastSource)) {
            lastLaunchSourceRect = src
            lastLaunchSourceRadius = srcRadius
            lastLaunchSourceIndex = fromIndex
            lastLaunchTargetIndex = toIndex
        }
    }

    function _startTransition(fromIndex, toIndex) {
        const opts = _pendingNavOpts || ({})
        const mode = (opts && opts.transitionMode !== undefined && opts.transitionMode !== null
                      && String(opts.transitionMode).length > 0)
                ? String(opts.transitionMode)
                : pageTransition
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
            transitionModeActive = pageTransition
            transitionProgress = 1
            fromIndex = displayedIndex
        }
        if (mode === "none" || fromIndex === toIndex) {
            displayedIndex = toIndex
            transitioning = false
            transitionModeActive = pageTransition
            transitionProgress = 1
            _dismissLeaveSnapshot(true)
            _evict()
            return
        }
        // fromIndex < 0 → enter-only (initial / no previous page)

        transitionFrom = fromIndex
        transitionTo = toIndex
        transitionDir = (fromIndex < 0 || toIndex >= fromIndex) ? 1 : -1
        transitionModeActive = mode
        transitioning = true
        transitionProgress = 0
        if (mode === "launch")
            _prepareLaunchTransition(fromIndex, toIndex, opts)
        if (fromIndex >= 0)
            _setKeep(fromIndex, true)
        _setKeep(toIndex, true)
        generation++
        pageAnim.start()
        _pendingNavOpts = ({})
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

    function navigateTo(index, opts) {
        if (!model || index < 0 || index >= model.length)
            return
        if (transitioning && index === transitionTo)
            return
        _pendingNavOpts = opts || ({})

        if (_navPrev >= 0 && _navPrev !== index)
            _recordMarkov(_navPrev, index)
        _navPrev = index

        currentIndex = index
        _pendingShowIndex = -1
        _touchLru(index)
        noteActivity()
        if (_usesArc())
            _arcRequest(index)
        else {
            _setKeep(index, true)
            _evict()
        }

        if ((_pendingNavOpts && _pendingNavOpts.transitionMode === "launch")
                || pageTransition === "launch")
            _armLeaveSnapshot()

        if (_tryShow(index)) {
            const keepLaunchSnapshot = (_pendingNavOpts && _pendingNavOpts.transitionMode === "launch")
                    || pageTransition === "launch"
            if (!keepLaunchSnapshot)
                _dismissLeaveSnapshot(true)
            if (!transitioning)
                _evict()
            Qt.callLater(_prefetchSmart, index)
            return
        }

        _armLeaveSnapshot()
        if (pageAnim.running) {
            pageAnim.stop()
            if (transitionTo >= 0 && transitionTo !== index)
                displayedIndex = transitionTo
            transitioning = false
            transitionFrom = -1
            transitionTo = -1
            transitionModeActive = pageTransition
            transitionProgress = 1
            launchReturning = false
        }
        generation++

        const ldr = _loaderAt(index)
        if (ldr && ldr.active)
            _fillLoader(ldr, index)
        else if (ldr)
            _setKeep(index, true)
        // Drop previous Item ASAP on cold path (keep only target + optional snapshot)
        _evict()
        Qt.callLater(_prefetchSmart, index)
    }

    function _prefetchAround(center) {
        if (!model)
            return
        const pair = [center - 1, center + 1]
        for (let i = 0; i < pair.length; ++i) {
            const n = pair[i]
            if (n < 0 || n >= model.length)
                continue
            _warmPage(n, true)
        }
    }

    function _prefetchSmart(center) {
        if (!model)
            return
        const doNeighbors = prefetchNeighbors
        const doPredict = predictPrefetch
        if (!doNeighbors && !doPredict && !l2Components)
            return

        // Best combo: neighbors optional L1; predict/hover are L2-only.
        if (doNeighbors)
            _prefetchAround(center)

        if (doPredict) {
            const next = _markovPredict(center)
            if (next >= 0 && next !== center)
                _ensureL2(next)
            if (_hoverHint >= 0 && _hoverHint !== center)
                _ensureL2(_hoverHint)
        }
        _trimL2()
    }

    function _warmAll() {
        if (!model || cacheMode === "none")
            return
        warmTimer.cursor = 0
        warmTimer.start()
    }

    function _warmAllL2() {
        // Never compile every destination — only nearby + Markov (bounded by l2CacheLimit).
        if (!l2Components || !model || cacheMode === "none")
            return
        _prefetchSmart(currentIndex)
    }

    Timer {
        id: idleTrimTimer
        interval: Math.max(2000, root.idleTrimMs)
        repeat: false
        onTriggered: root._trimForIdle()
    }

    Timer {
        id: hoverPrefetchTimer
        interval: 90
        repeat: false
        onTriggered: {
            if (root._hoverHint < 0)
                return
            root._warmPage(root._hoverHint, root.prefetchNeighbors)
        }
    }

    Timer {
        id: l2WarmDelay
        interval: 1200
        repeat: false
        onTriggered: root._warmAllL2()
    }

    Timer {
        id: l2WarmTimer
        property int cursor: 0
        interval: 28
        repeat: true
        running: false
        onTriggered: stop()
    }

    NumberAnimation {
        id: leaveSnapFade
        target: leaveSnap
        property: "opacity"
        to: 0
        duration: Md3Motion.short3
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Md3Motion.standard
        onFinished: leaveSnap.sourceItem = null
    }

    NumberAnimation {
        id: pageAnim
        target: root
        property: "transitionProgress"
        from: 0
        to: 1
        duration: root.transitionModeActive === "launch"
                  ? Math.max(root.pageTransitionDuration, root.launchTransitionDuration)
                  : root.pageTransitionDuration
        easing.type: Easing.BezierSpline
        easing.bezierCurve: root.transitionModeActive === "launch"
                            ? Md3Motion.standard
                            : (root.transitionModeActive === "slide"
                            ? Md3Motion.emphasizedDecelerate
                            : Md3Motion.emphasized)
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
                root._ensureL2(cursor)
                root._warmPage(cursor, true)
                cursor++
            }
            if (cursor >= root.model.length)
                stop()
        }
    }

    Component.onCompleted: {
        _ensureKeepArray()
        _setKeep(currentIndex, true)
        _touchLru(currentIndex)
        if (_usesArc())
            _arcRequest(currentIndex)
        displayedIndex = currentIndex
        _navPrev = currentIndex
        generation++
        if (cacheMode === "adaptive" || cacheMode === "arc") {
            _liveCacheLimit = adaptiveCacheMin
            idleTrimTimer.restart()
        }
        if (warmStart)
            Qt.callLater(_warmAll)
        else
            Qt.callLater(_prefetchSmart, currentIndex)
        if (l2WarmIdle && l2Components)
            l2WarmDelay.start()
    }

    onModelChanged: {
        if (pageAnim.running)
            pageAnim.stop()
        transitioning = false
        lruOrder = []
        keepFlags = []
        _arcT1 = []
        _arcT2 = []
        _arcB1 = []
        _arcB2 = []
        _arcP = 0
        _markov = ({})
        _navPrev = -1
        _hoverHint = -1
        _l2Map = ({})
        _l2Order = []
        if (model && currentIndex >= model.length)
            currentIndex = 0
        displayedIndex = currentIndex
        _ensureKeepArray()
        _setKeep(currentIndex, true)
        _touchLru(currentIndex)
        if (_usesArc())
            _arcRequest(currentIndex)
        if (cacheMode === "adaptive" || cacheMode === "arc")
            _liveCacheLimit = adaptiveCacheMin
        if (warmStart)
            Qt.callLater(_warmAll)
        else
            Qt.callLater(_prefetchSmart, currentIndex)
        if (l2WarmIdle && l2Components)
            l2WarmDelay.restart()
    }

    onCacheModeChanged: {
        if (cacheMode === "adaptive" || cacheMode === "arc") {
            _liveCacheLimit = adaptiveCacheMin
            idleTrimTimer.restart()
        }
        _evict()
    }
    onCacheLimitChanged: _evict()
    onIdleTrimMsChanged: {
        idleTrimTimer.interval = Math.max(2000, idleTrimMs)
    }

    Rectangle {
        anchors.fill: parent
        color: {
            const w = Window.window
            if (w && w.usesSystemBackdrop) {
                const t = w.backdropContentTint !== undefined ? w.backdropContentTint : 0.18
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
            property bool pendingUnload: false
            property bool awaitUnload: false

            anchors.fill: parent
            anchors.margins: root.contentPadding

            readonly property bool keep: root._shouldKeep(index)
            readonly property bool isDisplayed: index === root.displayedIndex
            readonly property bool isTarget: index === root.currentIndex
            readonly property bool isLeaving: root.transitioning && index === root.transitionFrom
            readonly property bool isEntering: root.transitioning && index === root.transitionTo
            readonly property real t: root.transitionProgress
            readonly property string mode: root.transitionModeActive
            readonly property int dir: root.transitionDir

            active: keep
            enabled: (isDisplayed && !root.transitioning) || isEntering
            asynchronous: root.asynchronous
            z: isEntering ? 3 : (isLeaving ? 2 : (isDisplayed ? 1 : 0))

            opacity: {
                // WinUI SlideNavigationTransition keeps both pages opaque while sliding.
                if (mode === "slide") {
                    if (isEntering || isLeaving || (isDisplayed && !root.transitioning))
                        return 1
                    return 0
                }
                if (isEntering) {
                    if (mode === "launch") {
                        return 1
                    }
                    if (mode === "fadeThrough")
                        return t < 0.35 ? 0 : (t - 0.35) / 0.65
                    return t
                }
                if (isLeaving) {
                    if (mode === "launch") {
                        if (root.launchReturning)
                            return 1 - Math.max(0, (t - 0.28) / 0.72)
                        return 1 - Math.max(0, (t - 0.72) / 0.28)
                    }
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
                        if (mode === "launch") {
                            const base = root._contentRect()
                            const start = root.launchStartRect
                            const end = root.launchEndRect
                            const sx = root._launchProgressX(pageLoader.t)
                            const ex = root._launchProgressX(pageLoader.t)
                            const sCx = start.x + start.width / 2
                            const eCx = end.x + end.width / 2
                            const bCx = base.x + base.width / 2
                            if (isEntering && !root.launchReturning) {
                                const cx = root._launchBlend(sCx, eCx, sx)
                                return cx - bCx
                            }
                            if (isLeaving && root.launchReturning) {
                                const cx = root._launchBlend(eCx, sCx, ex)
                                return cx - bCx
                            }
                            return 0
                        }
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
                        if (mode === "launch") {
                            const base = root._contentRect()
                            const start = root.launchStartRect
                            const end = root.launchEndRect
                            const sy = root._launchProgressY(pageLoader.t)
                            const ey = root._launchProgressY(pageLoader.t)
                            const sCy = start.y + start.height / 2
                            const eCy = end.y + end.height / 2
                            const bCy = base.y + base.height / 2
                            if (isEntering && !root.launchReturning) {
                                const cy = root._launchBlend(sCy, eCy, sy)
                                return cy - bCy
                            }
                            if (isLeaving && root.launchReturning) {
                                const cy = root._launchBlend(eCy, sCy, ey)
                                return cy - bCy
                            }
                            return 0
                        }
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
                        if (mode === "launch") {
                            const base = root._contentRect()
                            const start = root.launchStartRect
                            const end = root.launchEndRect
                            const sx = root._launchProgressX(pageLoader.t)
                            const sy = root._launchProgressY(pageLoader.t)
                            if (isEntering && !root.launchReturning) {
                                const from = Math.max(0.018, start.width / Math.max(1, base.width))
                                const to = Math.max(0.08, end.width / Math.max(1, base.width))
                                return root._launchBlend(from, to, sx) * root._launchPulse(pageLoader.t)
                            }
                            if (isLeaving && root.launchReturning) {
                                const from = Math.max(0.08, end.width / Math.max(1, base.width))
                                const to = Math.max(0.08, start.width / Math.max(1, base.width))
                                return root._launchBlend(from, to, sx)
                            }
                            return 1
                        }
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
                        if (mode === "launch") {
                            const base = root._contentRect()
                            const start = root.launchStartRect
                            const end = root.launchEndRect
                            const sy = root._launchProgressY(pageLoader.t)
                            if (isEntering && !root.launchReturning) {
                                const from = Math.max(0.018, start.height / Math.max(1, base.height))
                                const to = Math.max(0.08, end.height / Math.max(1, base.height))
                                return root._launchBlend(from, to, sy) * root._launchPulse(pageLoader.t)
                            }
                            if (isLeaving && root.launchReturning) {
                                const from = Math.max(0.08, end.height / Math.max(1, base.height))
                                const to = Math.max(0.08, start.height / Math.max(1, base.height))
                                return root._launchBlend(from, to, sy)
                            }
                            return 1
                        }
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
                // Defer side-effects so `keep` ↔ `active` does not form a binding loop
                // (active change → fill/clear → generation/keepFlags → keep re-eval).
                const on = active
                const ldr = pageLoader
                const idx = index
                Qt.callLater(function () {
                    if (!ldr)
                        return
                    if (on) {
                        root._fillLoader(ldr, idx)
                    } else {
                        if (root.l2Components)
                            root._ensureL2(idx)
                        if (ldr.status === Loader.Loading)
                            ldr.asynchronous = false
                        ldr.source = ""
                        ldr.sourceComponent = null
                        if (typeof ldr.setSource === "function")
                            ldr.setSource("")
                    }
                })
            }

            onKeepChanged: {
                if (keep && active) {
                    const ldr = pageLoader
                    const idx = index
                    Qt.callLater(function () {
                        if (ldr && ldr.active)
                            root._fillLoader(ldr, idx)
                    })
                }
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
    // Leave snapshot: frozen texture while cold target loads (survives L1 eviction)
    ShaderEffectSource {
        id: leaveSnap
        anchors.fill: parent
        anchors.margins: root.contentPadding
        z: 7
        live: false
        hideSource: false
        smooth: false
        mipmap: false
        visible: opacity > 0.01
        opacity: 0
    }

    MultiEffect {
        id: launchBlur
        anchors.fill: leaveSnap
        z: 7.5
        visible: opacity > 0.01
        source: leaveSnap
        blurEnabled: true
        blurMax: 48
        blurMultiplier: 1.0
        blur: root._launchBackdropBlur()
        opacity: root._launchBackdropOpacity()
        saturation: 0.92
        brightness: -0.02
    }

    Rectangle {
        id: skeletonHost
        anchors.fill: parent
        anchors.margins: root.contentPadding
        z: 8
        radius: Md3Theme.shape.large
        color: {
            const w = Window.window
            if (w && w.usesSystemBackdrop) {
                const t = w.backdropContentTint !== undefined ? w.backdropContentTint : 0.18
                return Qt.alpha(Md3Theme.colorScheme.surface, Math.max(0.55, t))
            }
            return Md3Theme.colorScheme.surface
        }
        // Prefer leave snapshot over skeleton when both would show.
        readonly property bool show: root.showSkeleton && root.awaitingTarget
                                    && leaveSnap.opacity < 0.2
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

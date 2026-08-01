import QtQuick
import QtQuick.Effects
import QtQuick.Window
import Md3

/*
  Instant navigation host with MD3 / WinUI-style page transitions:
  - Revisit (L1 cached): animated swap (or instant if pageTransition === "none")
  - Cold open: sync/async Loader; optional L2 QQmlComponent reuse
  - cacheMode: "none" | "one" | "lru" | "all" | "adaptive" | "arc"
    adaptive: grow toward cacheLimit while active; trim after idle (ARC victims)
    arc: ARC (recency+frequency+ghost) + cost-aware victim pick; optional idle trim
  - L2: keep compiled Component after Item teardown (cheap warm re-open)
  - Prefetch: ±1 neighbors, Markov next-hop, rail hover hint
  - l2WarmIdle: after delay, pace-compile ALL destination Components (L2 only — no Item RSS)
  Defaults: low L1; enable pageL2Warm for “any page” cold-open without fat Item caches.
*/
Item {
    id: root
    enum LaunchIntensity { Subtle, Normal, Premium }
    /// Dim = dark scrim. Frosted = 毛玻璃 (light blur + surface tint). Blur = stronger blur.
    enum LaunchBackdrop { Dim, Frosted, Blur }

    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Page host")
    focus: true
    /// Left-edge swipe back (phone / compact demos). Esc also goes back when canGoBack.
    property bool edgeSwipeBackEnabled: true
    /// Rubber-band / damping factor while dragging from the left edge (0–1 applied to raw dx).
    property real edgeSwipeDamping: 0.55
    /// Release distance (logical px) after damping to commit goBack.
    property real edgeSwipeCommitPx: 48
    /// When revisiting an L1-resident page, prefer a short fade instead of a heavy transition.
    property bool lightFadeOnCacheHit: true
    property int cacheHitFadeMs: 90
    property int _transitionDurationOverride: -1
    property real _edgeDragOffset: 0

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape && root.canGoBack) {
            root.goBack()
            event.accepted = true
        }
    }

    Item {
        id: edgeBackCatcher
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 28
        z: 50
        visible: root.edgeSwipeBackEnabled && root.canGoBack
        property real _startX: 0
        MouseArea {
            anchors.fill: parent
            enabled: parent.visible
            onPressed: function (mouse) {
                edgeBackCatcher._startX = mouse.x
                root._edgeDragOffset = 0
            }
            onPositionChanged: function (mouse) {
                const raw = Math.max(0, mouse.x - edgeBackCatcher._startX)
                // Damped pull with soft clamp so the gesture feels rubber-banded.
                const damped = raw * root.edgeSwipeDamping
                root._edgeDragOffset = Math.min(72, damped)
            }
            onReleased: function (mouse) {
                const raw = mouse.x - edgeBackCatcher._startX
                const damped = Math.max(0, raw) * root.edgeSwipeDamping
                if (damped >= root.edgeSwipeCommitPx || raw > 72)
                    root.goBack()
                root._edgeDragOffset = 0
            }
            onCanceled: root._edgeDragOffset = 0
        }
    }

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
    /// When prefetchNeighbors is on: true = L1 warm neighbors; false = L2 Component only.
    property bool prefetchNeighborsL1: true
    property bool l2Components: true
    /// Few compiled Components — enough for back/forward, not every destination
    property int l2CacheLimit: 1
    /// If true, after idle delay pace-compile every destination Component (L2 only).
    property bool l2WarmIdle: false
    property bool predictPrefetch: false
    /// Off by default: ShaderEffectSource holds a full-size GPU texture
    property bool leaveSnapshot: false
    property real leaveSnapOpacity: 0
    /// Full-res leave snapshot during launch (avoids chroma fringing on blurred text).
    property bool leaveSnapHiRes: false
    property bool warmStart: false
    /// Above this destination count (and cacheMode !== "all"), only live/kept pages get Item slots.
    property int sparseSlotThreshold: 40
    readonly property bool useSparseSlots: {
        if (!model || cacheMode === "all")
            return false
        return model.length > sparseSlotThreshold
    }
    property bool showBusyIndicator: false
    property bool showSkeleton: false
    property string skeletonLayout: "page"
    /// Optional override bones; when empty, uses destination.skeletonBones / skeletonLayout
    property var skeletonBones: []
    /// "none" | "fade" | "slide" | "slideUp" | "fadeThrough" | "scale" | "launch"
    property string pageTransition: "fade"
    property int pageTransitionDuration: 100
    /// Duration used by nonlinear tap-origin launch transition.
    property int launchTransitionDuration: Md3Motion.long2
    /// Subtle/Normal/Premium controls launch spring feel and visual strength.
    property int launchIntensity: Md3PageHost.Normal
    /// Backdrop while launch runs — default 毛玻璃 (Frosted).
    property int launchBackdropEffect: Md3PageHost.Frosted
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

    readonly property var activeDestination: entryAt(currentIndex)

    readonly property var effectiveSkeletonBones: {
        if (skeletonBones && skeletonBones.length > 0)
            return skeletonBones
        const d = activeDestination
        if (d && d.skeletonBones && d.skeletonBones.length > 0)
            return d.skeletonBones
        return []
    }

    readonly property string effectiveSkeletonLayout: {
        const d = activeDestination
        if (d && d.skeletonLayout !== undefined && String(d.skeletonLayout).length > 0)
            return String(d.skeletonLayout)
        return skeletonLayout
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

    // --- Multi-level navigation (back stack) ---
    property var navStack: []
    property var routeParams: ({})
    property int sectionRootIndex: -1
    property var _lastNavOpts: ({})
    /// Top-level rail / index switches (separate from pushRoute hierarchical stack).
    property var browseHistory: []
    property int browseHistoryLimit: 32

    readonly property bool canGoBack: navStack.length > 0 || browseHistory.length > 0
    readonly property int navDepth: navStack.length + browseHistory.length

    function _clonePlainObject(obj) {
        if (!obj || typeof obj !== "object")
            return ({})
        const out = ({})
        for (const k in obj)
            out[k] = obj[k]
        return out
    }

    function resetNavStack() {
        navStack = []
        sectionRootIndex = -1
        routeParams = ({})
    }

    function resetBrowseHistory() {
        browseHistory = []
    }

    function _pushBrowseHistory(fromIndex) {
        if (fromIndex < 0 || !model || fromIndex >= model.length)
            return
        const hist = browseHistory.slice()
        if (hist.length > 0 && hist[hist.length - 1] === fromIndex)
            return
        hist.push(fromIndex)
        while (hist.length > browseHistoryLimit)
            hist.shift()
        browseHistory = hist
    }

    function pushRoute(index, params, opts) {
        if (!model || index < 0 || index >= model.length)
            return false
        const entry = {
            index: currentIndex,
            params: _clonePlainObject(routeParams),
            forwardOpts: _clonePlainObject(opts),
            sectionRoot: sectionRootIndex >= 0 ? sectionRootIndex : currentIndex
        }
        navStack = navStack.concat([entry])
        if (sectionRootIndex < 0)
            sectionRootIndex = currentIndex
        routeParams = _clonePlainObject(params)
        const navOpts = Object.assign({}, opts || ({}), { _stackOp: true })
        navigateTo(index, navOpts)
        return true
    }

    function replaceRoute(index, params, opts) {
        if (!model || index < 0 || index >= model.length)
            return false
        routeParams = _clonePlainObject(params)
        const navOpts = Object.assign({}, opts || ({}), { _stackOp: true })
        navigateTo(index, navOpts)
        return true
    }

    function goBack(opts) {
        // Hierarchical routes first (list→detail), then rail browse history.
        if (navStack.length > 0) {
            const prev = navStack[navStack.length - 1]
            navStack = navStack.slice(0, navStack.length - 1)
            sectionRootIndex = navStack.length > 0 ? prev.sectionRoot : -1
            routeParams = _clonePlainObject(prev.params)
            const backOpts = Object.assign({}, opts || ({}), { _stackOp: true })
            if (backOpts.transitionMode === undefined && backOpts.returnToSource === undefined) {
                if (_isLaunchNav(prev.forwardOpts)) {
                    backOpts.transitionMode = "launch"
                    backOpts.returnToSource = true
                }
            }
            navigateTo(prev.index, backOpts)
            return true
        }
        if (browseHistory.length === 0)
            return false
        const prevIndex = browseHistory[browseHistory.length - 1]
        browseHistory = browseHistory.slice(0, browseHistory.length - 1)
        const browseOpts = Object.assign({}, opts || ({}), { _browseBack: true })
        navigateTo(prevIndex, browseOpts)
        return true
    }

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
    /// Tap origin in page-loader local coordinates (for scale pivot).
    property real launchPivotX: 0
    property real launchPivotY: 0
    /// Defer enter transition after Loader.Ready (unused; kept for API stability).
    property int _pendingShowIndex: -1
    property int _pendingShowPasses: 0

    function entryAt(index) {
        if (!model || index < 0 || index >= model.length)
            return null
        return model[index]
    }

    /// Clear current page Loader and reopen (used by hot reload).
    function reloadCurrent() {
        const idx = currentIndex
        if (idx < 0 || !model || idx >= model.length)
            return
        const ldr = _loaderAt(idx)
        if (!ldr)
            return
        const e = entryAt(idx) || {}
        const url = resolveSource(e.source)
        if (url && _l2Map[String(url)]) {
            const m = Object.assign({}, _l2Map)
            delete m[String(url)]
            _l2Map = m
            const order = (_l2Order || []).slice()
            const oi = order.indexOf(String(url))
            if (oi >= 0) {
                order.splice(oi, 1)
                _l2Order = order
            }
        }
        const prevDisplayed = displayedIndex
        ldr.sourceComponent = undefined
        ldr.source = ""
        if (Array.isArray(keepFlags)) {
            const kf = keepFlags.slice()
            while (kf.length <= idx)
                kf.push(false)
            kf[idx] = false
            keepFlags = kf
        }
        generation++
        displayedIndex = -1
        Qt.callLater(function () {
            root.navigateTo(idx)
            if (prevDisplayed === idx)
                displayedIndex = idx
        })
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

    function _pageSlotAt(index) {
        // Dense path: slots are ordered by pageIndex === repeater index.
        if (!useSparseSlots) {
            const ordered = pageRepeater.itemAt(index)
            if (ordered && ordered.pageIndex === index)
                return ordered
        }
        for (let i = 0; i < pageRepeater.count; ++i) {
            const slot = pageRepeater.itemAt(i)
            if (slot && slot.pageIndex === index)
                return slot
        }
        return null
    }

    function _loaderAt(index) {
        const slot = _pageSlotAt(index)
        return slot ? slot.pageLoader : null
    }

    function _sparseHas(pageIndex) {
        for (let i = 0; i < sparseSlotModel.count; ++i) {
            if (Number(sparseSlotModel.get(i).pageIndex) === pageIndex)
                return true
        }
        return false
    }

    function _sparseEnsure(pageIndex) {
        if (pageIndex < 0 || !model || pageIndex >= model.length)
            return
        if (_sparseHas(pageIndex))
            return
        sparseSlotModel.append({ pageIndex: pageIndex })
    }

    /// Keep `sparseSlotModel` in sync. Dense catalogs: one entry per page index.
    /// Sparse catalogs (large N): only kept / current / transition pages.
    function _syncSparseSlots() {
        if (!model || model.length === 0) {
            if (sparseSlotModel.count > 0)
                sparseSlotModel.clear()
            return
        }
        if (!useSparseSlots) {
            const n = model.length
            while (sparseSlotModel.count > n)
                sparseSlotModel.remove(sparseSlotModel.count - 1)
            for (let i = sparseSlotModel.count; i < n; ++i)
                sparseSlotModel.append({ pageIndex: i })
            for (let i = 0; i < n; ++i) {
                if (Number(sparseSlotModel.get(i).pageIndex) !== i)
                    sparseSlotModel.setProperty(i, "pageIndex", i)
            }
            return
        }
        const want = ({})
        function add(i) {
            if (i >= 0 && i < model.length)
                want[i] = true
        }
        add(currentIndex)
        add(displayedIndex)
        add(transitionFrom)
        add(transitionTo)
        _ensureKeepArray()
        for (let i = 0; i < keepFlags.length; ++i) {
            if (keepFlags[i] || _isPinned(i))
                add(i)
        }
        for (let i = sparseSlotModel.count - 1; i >= 0; --i) {
            const pi = Number(sparseSlotModel.get(i).pageIndex)
            if (!want[pi])
                sparseSlotModel.remove(i)
        }
        for (const k in want)
            _sparseEnsure(Number(k))
    }

    ListModel {
        id: sparseSlotModel
    }

    onUseSparseSlotsChanged: Qt.callLater(_syncSparseSlots)
    onDisplayedIndexChanged: {
        _sparseEnsure(displayedIndex)
        Qt.callLater(_syncSparseSlots)
        Qt.callLater(_syncAllPageActivity)
    }
    onTransitioningChanged: {
        Qt.callLater(_syncSparseSlots)
        Qt.callLater(_syncAllPageActivity)
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

    function _cubicAt(t, a, b, c, d) {
        const u = 1 - t
        return u * u * u * a + 3 * u * u * t * b + 3 * u * t * t * c + t * t * t * d
    }

    function _bezierPoint(t, seg) {
        return {
            x: _cubicAt(t, seg.x0, seg.x1, seg.x2, seg.x3),
            y: _cubicAt(t, seg.y0, seg.y1, seg.y2, seg.y3)
        }
    }

    // Android ActivityLaunchAnimator.createPositionXInterpolator() path.
    function _launchPositionXProgress(linearT) {
        const x = Math.max(0, Math.min(1, linearT))
        if (x <= 0)
            return 0
        if (x >= 1)
            return 1
        const segments = [
            { x0: 0, y0: 0, x1: 0.1217, y1: 0.0462, x2: 0.15, y2: 0.4686, x3: 0.1667, y3: 0.66 },
            { x0: 0.1667, y0: 0.66, x1: 0.1834, y1: 0.8878, x2: 0.1667, y2: 1.0, x3: 1.0, y3: 1.0 }
        ]
        function invert(seg, targetX) {
            let lo = 0
            let hi = 1
            for (let i = 0; i < 24; ++i) {
                const mid = (lo + hi) * 0.5
                if (_bezierPoint(mid, seg).x < targetX)
                    lo = mid
                else
                    hi = mid
            }
            return (lo + hi) * 0.5
        }
        const seg = x <= 0.1667 ? segments[0] : segments[1]
        const param = invert(seg, x)
        return _bezierPoint(param, seg).y
    }

    function _launchTotalDuration() {
        if (launchIntensity === Md3PageHost.Premium)
            return 550
        if (launchIntensity === Md3PageHost.Subtle)
            return 400
        return 500
    }

    function _launchSubProgress(linearT, delayMs, durationMs) {
        const total = Math.max(1, _launchTotalDuration())
        return Math.max(0, Math.min(1, (linearT * total - delayMs) / Math.max(1, durationMs)))
    }

    // Y/width/height use emphasized; time itself stays linear (Android LaunchAnimator).
    function _launchPositionProgress(linearT) {
        const curve = launchCurveY || Md3Motion.emphasized
        return _bezierAt(linearT, curve)
    }

    function _launchBlend(start, end, p) {
        return start + (end - start) * p
    }

    function _launchBoundsAt(linearT, fromRect, toRect) {
        const p = _launchPositionProgress(linearT)
        const xp = launchAxisProportional
                ? _launchPositionXProgress(linearT)
                : p
        const sCx = fromRect.x + fromRect.width / 2
        const eCx = toRect.x + toRect.width / 2
        const cx = _launchBlend(sCx, eCx, xp)
        const halfW = _launchBlend(fromRect.width, toRect.width, p) / 2
        const top = _launchBlend(fromRect.y, toRect.y, p)
        const height = _launchBlend(fromRect.height, toRect.height, p)
        return {
            left: cx - halfW,
            top: top,
            width: halfW * 2,
            height: height,
            cx: cx,
            cy: top + height / 2
        }
    }

    function _launchMaskRect(linearT) {
        const base = _contentRect()
        const bounds = _launchBoundsAt(linearT, launchStartRect, launchEndRect)
        const shapeP = Math.min(1, _launchPositionProgress(linearT) / 0.75)
        return {
            x: bounds.left - base.x,
            y: bounds.top - base.y,
            width: Math.max(1, bounds.width),
            height: Math.max(1, bounds.height),
            radius: Math.max(0, _launchBlend(launchStartRadius, launchEndRadius, shapeP))
        }
    }

    function _launchPageTransform(linearT, fromRect, toRect) {
        const base = _contentRect()
        const bounds = _launchBoundsAt(linearT, fromRect, toRect)
        const ox = launchPivotX
        const oy = launchPivotY
        const sx = bounds.width / Math.max(1, base.width)
        const sy = bounds.height / Math.max(1, base.height)
        const leftLocal = bounds.left - base.x
        const topLocal = bounds.top - base.y
        return {
            ox: ox,
            oy: oy,
            dx: leftLocal - ox * (1 - sx),
            dy: topLocal - oy * (1 - sy),
            scaleX: sx,
            scaleY: sy
        }
    }

    function _resolveNavMode(opts) {
        const o = opts || ({})
        let mode = pageTransition
        if (o.returnToSource) {
            if (o.transitionMode !== undefined && o.transitionMode !== null
                    && String(o.transitionMode).length > 0
                    && String(o.transitionMode) !== "launch")
                mode = String(o.transitionMode)
            else
                mode = pageTransition === "launch" ? "slide" : pageTransition
        } else if (o.transitionMode !== undefined && o.transitionMode !== null
                   && String(o.transitionMode).length > 0) {
            mode = String(o.transitionMode)
        }
        // Instant path: explicit none, reduceMotion, or zero-duration non-launch
        // (duration 0 + fade still ran pageAnim with t=0 → one blank frame).
        if (mode === "none")
            return "none"
        if (Md3Theme && Md3Theme.reduceMotion)
            return "none"
        if (Md3Theme && Md3Theme.effectsPageMotion === false)
            return "none"
        // duration 0 ⇒ instant (avoids fade at t=0 blank frame)
        if (mode !== "launch" && pageTransitionDuration <= 0)
            return "none"
        return mode
    }

    function _isLaunchNav(opts) {
        const o = opts || ({})
        if (o.returnToSource)
            return false
        return o.transitionMode === "launch" || pageTransition === "launch"
    }

    function _launchLeaveFadeOpacity(linearT, returning) {
        const total = _launchTotalDuration()
        if (returning) {
            const fadeStart = 0.55
            if (linearT <= fadeStart)
                return 1
            return Math.max(0, 1 - (linearT - fadeStart) / (1 - fadeStart))
        }
        const fadeOut = _launchSubProgress(linearT, 0, Math.round(total * 0.30))
        return 1 - _bezierAt(fadeOut, Md3Motion.standardAccelerate)
    }

    function _launchBackdropStrength() {
        if (launchIntensity === Md3PageHost.Premium)
            return 1.0
        if (launchIntensity === Md3PageHost.Subtle)
            return 0.75
        return 0.9
    }

    function _launchBackdropActive() {
        return transitionModeActive === "launch" && transitioning && !launchReturning
    }

    function _launchBackdropFade() {
        if (!_launchBackdropActive())
            return 0
        const k = _launchBackdropStrength()
        const t = transitionProgress
        return Math.max(0, (1 - t * 0.68) * k)
    }

    function _launchBackdropSnapshotOpacity() {
        return _launchBackdropFade()
    }

    function _launchGlassOverlayOpacity() {
        if (!_launchBackdropActive())
            return 0
        const fade = _launchBackdropFade()
        if (launchBackdropEffect === Md3PageHost.Dim)
            return fade * 0.54
        if (launchBackdropEffect === Md3PageHost.Blur)
            return fade * 0.24
        return fade * 0.78
    }

    function _launchBackdropOpacity() {
        return _launchBackdropSnapshotOpacity()
    }

    function _launchBackdropBlur() {
        if (!_launchBackdropActive() || launchBackdropEffect === Md3PageHost.Dim)
            return 0
        const k = _launchBackdropStrength()
        const t = transitionProgress
        const peak = launchBackdropEffect === Md3PageHost.Frosted ? 0.16
                : 0.40
        return Math.max(0.06 * k, peak * k * (1 - _bezierAt(t, Md3Motion.emphasizedDecelerate) * 0.45))
    }

    function _launchGlassOverlayColor() {
        if (launchBackdropEffect === Md3PageHost.Dim)
            return Md3Theme.colorScheme.scrim
        if (launchBackdropEffect === Md3PageHost.Frosted)
            return Qt.alpha(Md3Theme.colorScheme.surface, 0.94)
        return Qt.alpha(Md3Theme.colorScheme.surfaceContainerHigh, 0.88)
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
            const loader = _loaderAt(index)
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
            const loader = _loaderAt(index)
            if (loader)
                loader.pendingUnload = false
        }
        const next = keepFlags.slice()
        next[index] = on
        keepFlags = next
        generation++
        if (on)
            _sparseEnsure(index)
        Qt.callLater(_syncSparseSlots)
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

    property int _prefetchCenter: -1

    function _schedulePrefetch(center) {
        if (center === undefined || center === null)
            return
        _prefetchCenter = Number(center)
        prefetchDebounce.restart()
    }

    Timer {
        id: prefetchDebounce
        interval: 120
        repeat: false
        onTriggered: {
            if (root._prefetchCenter < 0)
                return
            root._prefetchSmart(root._prefetchCenter)
        }
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
        _schedulePrefetch(currentIndex)
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

    function _armLeaveSnapshot(forLaunch) {
        if (!leaveSnapshot && !forLaunch)
            return
        const ldr = _loaderAt(displayedIndex)
        if (!ldr || !ldr.item)
            return
        leaveSnapFade.stop()
        root.leaveSnapHiRes = !!forLaunch
        const cw = Math.max(1, Math.floor(width - contentPadding * 2))
        const ch = Math.max(1, Math.floor(height - contentPadding * 2))
        if (forLaunch) {
            leaveSnap.textureSize = Qt.size(cw, ch)
        } else {
            leaveSnap.textureSize = Qt.size(
                        Math.max(1, Math.floor(cw / 2)),
                        Math.max(1, Math.floor(ch / 2)))
        }
        leaveSnap.sourceItem = ldr
        leaveSnap.scheduleUpdate()
        root.leaveSnapOpacity = 1
    }

    function _leaveSnapShownOpacity() {
        if (_launchBackdropActive())
            return _launchBackdropSnapshotOpacity()
        return leaveSnapOpacity
    }

    function _dismissLeaveSnapshot(immediate) {
        if (!leaveSnap.sourceItem && _leaveSnapShownOpacity() < 0.01)
            return
        if (immediate) {
            leaveSnapFade.stop()
            root.leaveSnapOpacity = 0
            root.leaveSnapHiRes = false
            leaveSnap.sourceItem = null
            return
        }
        root.leaveSnapOpacity = _leaveSnapShownOpacity()
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
        // Idle full-catalog warm must keep room for every destination Component.
        const limit = Math.max(0, l2CacheLimit)
        const effective = (l2WarmIdle && model && model.length)
                         ? Math.max(limit, model.length)
                         : limit
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
        while (_l2Order.length > effective) {
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

    function _trySetPageProp(obj, name, value) {
        if (!obj)
            return
        try {
            obj[name] = value
        } catch (e) {
            // Page did not declare this property.
        }
    }

    /// Inject shell context so pages need not walk parents / duck-type Window.
    function _syncPageContext(item, pageIndex) {
        if (!item)
            return
        const win = Window.window
        const host = root
        const idx = pageIndex === undefined ? -1 : Number(pageIndex)
        _trySetPageProp(item, "md3HostWindow", win)
        _trySetPageProp(item, "md3RouteParams", routeParams)
        _trySetPageProp(item, "routeParams", routeParams)
        _trySetPageProp(item, "md3NavDepth", navDepth)
        _trySetPageProp(item, "navDepth", navDepth)
        _trySetPageProp(item, "md3GoBack", function (opts) {
            return host.goBack(opts)
        })
        _trySetPageProp(item, "md3PushRoute", function (index, params, opts) {
            return host.pushRoute(index, params, opts)
        })
        if (idx >= 0)
            _trySetPageProp(item, "md3PageActive", _pageSlotIsActive(idx))
    }

    function _pageSlotIsActive(index) {
        if (index < 0)
            return false
        if (transitioning)
            return index === transitionFrom || index === transitionTo
                    || index === displayedIndex || index === currentIndex
        return index === displayedIndex
    }

    /// Keep shell in L1; pages opt into unloading DeferredSection via md3PageActive.
    function _syncAllPageActivity() {
        if (!model)
            return
        for (let i = 0; i < model.length; ++i) {
            const ldr = _loaderAt(i)
            if (!ldr || !ldr.item)
                continue
            _trySetPageProp(ldr.item, "md3PageActive", _pageSlotIsActive(i))
        }
    }

    function _syncCurrentPageContext() {
        const ldr = _loaderAt(currentIndex)
        if (ldr && ldr.item)
            _syncPageContext(ldr.item, currentIndex)
    }

    onRouteParamsChanged: Qt.callLater(_syncCurrentPageContext)
    onNavDepthChanged: Qt.callLater(_syncCurrentPageContext)
    onCurrentIndexChanged: {
        _sparseEnsure(currentIndex)
        Qt.callLater(_syncSparseSlots)
        Qt.callLater(_syncCurrentPageContext)
        Qt.callLater(_syncAllPageActivity)
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

    /// Drop pending hover / predict warm work (e.g. rail flick started).
    function clearAllPrefetchHints() {
        _hoverHint = -1
        if (hoverPrefetchTimer.running)
            hoverPrefetchTimer.stop()
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
        _transitionDurationOverride = -1
        generation++
        _dismissLeaveSnapshot(false)
        _evict()
        _schedulePrefetch(displayedIndex)
        Qt.callLater(_syncAllPageActivity)
    }

    function _applyLaunchIntensityProfile() {
        if (launchIntensity === Md3PageHost.Premium) {
            launchCurveX = [0.0, 0.0, 0.18, 1.0]
            launchCurveY = Md3Motion.emphasized
            launchTransitionDuration = 550
        } else if (launchIntensity === Md3PageHost.Subtle) {
            launchCurveX = Md3Motion.standard
            launchCurveY = Md3Motion.standardDecelerate
            launchTransitionDuration = 400
        } else {
            launchCurveX = [0.0, 0.0, 0.2, 1.0]
            launchCurveY = Md3Motion.emphasized
            launchTransitionDuration = 500
        }
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
            _applyLaunchIntensityProfile()
            return
        }

        launchReturning = false
        let pivotX = content.x + content.width / 2
        let pivotY = content.y + content.height / 2
        if (opts && opts.sourcePoint && opts.sourcePoint.x !== undefined && opts.sourcePoint.y !== undefined) {
            const px = Number(opts.sourcePoint.x)
            const py = Number(opts.sourcePoint.y)
            pivotX = px
            pivotY = py
            src = _clampRect(Qt.rect(px - seed / 2, py - seed / 2, seed, seed), content)
        } else if (opts && opts.sourceRect) {
            src = _clampRect(opts.sourceRect, content)
            pivotX = src.x + src.width / 2
            pivotY = src.y + src.height / 2
        }
        launchPivotX = Math.max(0, Math.min(content.width, pivotX - content.x))
        launchPivotY = Math.max(0, Math.min(content.height, pivotY - content.y))
        srcRadius = Number(opts && opts.sourceRadius !== undefined
                           ? opts.sourceRadius
                           : Math.min(src.width, src.height) / 2)
        if (!(srcRadius >= 0))
            srcRadius = Math.min(src.width, src.height) / 2
        launchStartRect = src
        launchEndRect = content
        launchStartRadius = srcRadius
        launchEndRadius = Md3Theme.shape.large
        _applyLaunchIntensityProfile()
        if ((opts && opts.rememberSource !== false) || (!opts && launchRememberLastSource)) {
            lastLaunchSourceRect = src
            lastLaunchSourceRadius = srcRadius
            lastLaunchSourceIndex = fromIndex
            lastLaunchTargetIndex = toIndex
        }
    }

    function _startTransition(fromIndex, toIndex) {
        const opts = _pendingNavOpts || ({})
        const mode = _resolveNavMode(opts)
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
            transitionFrom = -1
            transitionTo = -1
            transitionModeActive = "none"
            transitionProgress = 1
            launchReturning = false
            generation++
            _pendingNavOpts = ({})
            _dismissLeaveSnapshot(true)
            _evict()
            _schedulePrefetch(displayedIndex)
            Qt.callLater(_syncAllPageActivity)
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
        opts = opts || ({})
        // Sparse catalogs: create the destination slot before probing the Loader.
        _sparseEnsure(index)
        if (useSparseSlots)
            _syncSparseSlots()
        const targetLdr = _loaderAt(index)
        const cacheHit = !!(targetLdr && targetLdr.status === Loader.Ready && targetLdr.item)
        if (cacheHit && lightFadeOnCacheHit
                && opts.transitionMode === undefined
                && opts.returnToSource !== true
                && !_isLaunchNav(opts)) {
            opts = Object.assign({}, opts, {
                transitionMode: "fade",
                _cacheHitFade: true
            })
        }
        if (!opts._stackOp) {
            resetNavStack()
            if (opts.params !== undefined)
                routeParams = _clonePlainObject(opts.params)
            // Record rail / top-level page switches for title-bar Back.
            if (!opts._browseBack && currentIndex >= 0 && currentIndex !== index)
                _pushBrowseHistory(currentIndex)
        }
        _lastNavOpts = opts
        _pendingNavOpts = opts
        _transitionDurationOverride = (opts && opts._cacheHitFade) ? cacheHitFadeMs : -1

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

        if ((_pendingNavOpts && _isLaunchNav(_pendingNavOpts))
                || (pageTransition === "launch" && !(_pendingNavOpts && _pendingNavOpts.returnToSource)))
            _armLeaveSnapshot(true)

        if (_tryShow(index)) {
            const keepLaunchSnapshot = _isLaunchNav(_pendingNavOpts)
                    || (pageTransition === "launch" && !(_pendingNavOpts && _pendingNavOpts.returnToSource))
            if (!keepLaunchSnapshot)
                _dismissLeaveSnapshot(true)
            if (!transitioning)
                _evict()
            _schedulePrefetch(index)
            return
        }

        _armLeaveSnapshot(_isLaunchNav(_pendingNavOpts))
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
        _schedulePrefetch(index)
    }

    function _prefetchAround(center) {
        if (!model)
            return
        const pair = [center - 1, center + 1]
        for (let i = 0; i < pair.length; ++i) {
            const n = pair[i]
            if (n < 0 || n >= model.length)
                continue
            _warmPage(n, root.prefetchNeighborsL1)
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
        // Pace-compile every destination Component (L2 only — no Item instantiation).
        if (!l2Components || !model || cacheMode === "none")
            return
        l2WarmTimer.cursor = 0
        if (!l2WarmTimer.running)
            l2WarmTimer.start()
    }

    Timer {
        id: idleTrimTimer
        interval: Math.max(2000, root.idleTrimMs)
        repeat: false
        onTriggered: root._trimForIdle()
    }

    Timer {
        id: hoverPrefetchTimer
        interval: 120
        repeat: false
        onTriggered: {
            if (root._hoverHint < 0)
                return
            root._warmPage(root._hoverHint, root.prefetchNeighbors && root.prefetchNeighborsL1)
        }
    }

    Timer {
        id: l2WarmDelay
        interval: 900
        repeat: false
        onTriggered: root._warmAllL2()
    }

    Timer {
        id: l2WarmTimer
        property int cursor: 0
        interval: 48
        repeat: true
        running: false
        onTriggered: {
            if (!root.l2Components || !root.model || root.cacheMode === "none") {
                stop()
                return
            }
            const n = root.model.length
            if (cursor < n) {
                root._ensureL2(cursor)
                cursor++
                return
            }
            stop()
        }
    }

    NumberAnimation {
        id: leaveSnapFade
        target: root
        property: "leaveSnapOpacity"
        to: 0
        duration: Md3Motion.short3
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Md3Motion.standard
        onFinished: {
            root.leaveSnapHiRes = false
            leaveSnap.sourceItem = null
        }
    }

    NumberAnimation {
        id: pageAnim
        target: root
        property: "transitionProgress"
        from: 0
        to: 1
        duration: root._transitionDurationOverride >= 0
                  ? root._transitionDurationOverride
                  : (root.transitionModeActive === "launch"
                  ? Math.max(root.pageTransitionDuration, root.launchTransitionDuration)
                  : root.pageTransitionDuration)
        easing.type: Easing.BezierSpline
        easing.bezierCurve: root.transitionModeActive === "launch"
                            ? [0.0, 0.0, 1.0, 1.0]
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
        _syncSparseSlots()
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
            _schedulePrefetch(currentIndex)
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
        _syncSparseSlots()
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
            _schedulePrefetch(currentIndex)
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

    // Leave snapshot + backdrop — z=1, below entering pages (z=10).
    Item {
        id: launchBackdropHost
        anchors.fill: parent
        z: 1

        ShaderEffectSource {
            id: leaveSnap
            anchors.fill: parent
            anchors.margins: root.contentPadding
            live: false
            hideSource: false
            smooth: root.leaveSnapHiRes
            mipmap: false
            visible: root._leaveSnapShownOpacity() > 0.01
            opacity: root._leaveSnapShownOpacity()
        }

        MultiEffect {
            id: launchBackdropTreat
            anchors.fill: leaveSnap
            visible: root._leaveSnapShownOpacity() > 0.01 && root._launchBackdropActive()
            source: leaveSnap
            blurEnabled: root.launchBackdropEffect !== Md3PageHost.Dim
                         && root._launchBackdropBlur() > 0.005
            blurMax: root.launchBackdropEffect === Md3PageHost.Frosted ? 24 : 72
            blurMultiplier: root.launchBackdropEffect === Md3PageHost.Frosted ? 0.75 : 1.8
            blur: root._launchBackdropBlur()
            saturation: root.launchBackdropEffect === Md3PageHost.Dim ? 0.88
                        : (root.launchBackdropEffect === Md3PageHost.Frosted ? 0.72 : 0.9)
            brightness: root.launchBackdropEffect === Md3PageHost.Dim ? -0.05
                        : (root.launchBackdropEffect === Md3PageHost.Frosted ? 0.06 : -0.02)
        }

        Rectangle {
            anchors.fill: leaveSnap
            visible: root._launchGlassOverlayOpacity() > 0.01
            radius: Md3Theme.shape.large
            color: root._launchGlassOverlayColor()
            opacity: root._launchGlassOverlayOpacity()
        }
    }

    Repeater {
        id: pageRepeater
        model: sparseSlotModel

        delegate: Item {
            id: pageSlot
            required property int index
            required property int pageIndex
            property alias pageLoader: pageLoader

            anchors.fill: parent
            anchors.margins: root.contentPadding

            readonly property bool keep: root._shouldKeep(pageIndex)
            readonly property bool isDisplayed: pageIndex === root.displayedIndex
            readonly property bool isTarget: pageIndex === root.currentIndex
            readonly property bool isLeaving: root.transitioning && pageIndex === root.transitionFrom
            readonly property bool isEntering: root.transitioning && pageIndex === root.transitionTo
            readonly property real t: root.transitionProgress
            readonly property string mode: root.transitionModeActive
            readonly property int dir: root.transitionDir
            readonly property bool launchClipActive: mode === "launch" && isEntering && !root.launchReturning
            // Single geometry snapshot while launching — idle slots skip alloc entirely.
            readonly property var _launchGeom: launchClipActive ? root._launchMaskRect(t) : null
            readonly property real launchMaskX: _launchGeom ? _launchGeom.x : 0
            readonly property real launchMaskY: _launchGeom ? _launchGeom.y : 0
            readonly property real launchMaskW: _launchGeom ? _launchGeom.width : width
            readonly property real launchMaskH: _launchGeom ? _launchGeom.height : height
            readonly property real launchMaskR: _launchGeom ? _launchGeom.radius : Md3Theme.shape.large

            z: isEntering ? 10 : (isLeaving ? 2 : (isDisplayed ? 1 : 0))

            layer.enabled: launchClipActive
            layer.smooth: true
            layer.effect: MultiEffect {
                maskEnabled: pageSlot.launchClipActive
                maskSource: morphMaskHost
            }

            Item {
                id: morphMaskHost
                width: pageSlot.width
                height: pageSlot.height
                // Full-size FBO only during launch morph (N destinations × always-on was costly).
                layer.enabled: pageSlot.launchClipActive
                visible: false

                Rectangle {
                    x: pageSlot.launchMaskX
                    y: pageSlot.launchMaskY
                    width: pageSlot.launchMaskW
                    height: pageSlot.launchMaskH
                    radius: Math.min(pageSlot.launchMaskR,
                                     Math.min(width, height) / 2)
                    color: "#ffffff"
                }
            }

            opacity: {
                // Instant swap: never interpolate (avoids t=0 blank frame).
                if (mode === "none" || !root.transitioning) {
                    if (isDisplayed)
                        return 1
                    return 0
                }
                if (mode === "slide") {
                    if (isEntering || isLeaving || isDisplayed)
                        return 1
                    return 0
                }
                if (isEntering) {
                    if (mode === "launch")
                        return 1
                    if (mode === "fadeThrough")
                        return t < 0.35 ? 0 : (t - 0.35) / 0.65
                    return t
                }
                if (isLeaving) {
                    if (mode === "launch")
                        return root._launchLeaveFadeOpacity(t, root.launchReturning)
                    if (mode === "fadeThrough")
                        return t < 0.35 ? (1 - t / 0.35) : 0
                    return 1 - t
                }
                if (isDisplayed)
                    return 1
                return 0
            }

            visible: keep && (opacity > 0.01 || isDisplayed || isEntering || isLeaving)

            Loader {
                id: pageLoader
                property bool pendingUnload: false
                property bool awaitUnload: false

                anchors.fill: parent

                active: pageSlot.keep
                enabled: (pageSlot.isDisplayed && !root.transitioning) || pageSlot.isEntering
                asynchronous: root.asynchronous

                transform: [
                    Translate {
                        x: {
                            if (mode !== "slide")
                                return 0
                            const w = pageLoader.width
                            if (isEntering)
                                return (1 - pageSlot.t) * w * pageSlot.dir
                            if (isLeaving)
                                return pageSlot.t * w * (-pageSlot.dir)
                            return 0
                        }
                        y: {
                            if (mode !== "slideUp")
                                return 0
                            const h = pageLoader.height
                            if (isEntering)
                                return (1 - pageSlot.t) * h * 0.08
                            if (isLeaving)
                                return pageSlot.t * h * (-0.04)
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
                                    return 0.92 + 0.08 * pageSlot.t
                                return 0.94 + 0.06 * pageSlot.t
                            }
                            if (isLeaving) {
                                if (mode === "fadeThrough")
                                    return 1 - 0.04 * pageSlot.t
                                return 1 - 0.06 * pageSlot.t
                            }
                            return 1
                        }
                        yScale: {
                            if (mode !== "scale" && mode !== "fadeThrough")
                                return 1
                            if (isEntering) {
                                if (mode === "fadeThrough")
                                    return 0.92 + 0.08 * pageSlot.t
                                return 0.94 + 0.06 * pageSlot.t
                            }
                            if (isLeaving) {
                                if (mode === "fadeThrough")
                                    return 1 - 0.04 * pageSlot.t
                                return 1 - 0.06 * pageSlot.t
                            }
                            return 1
                        }
                    }
                ]

                onActiveChanged: {
                    const on = active
                    const ldr = pageLoader
                    const idx = pageSlot.pageIndex
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

                onLoaded: {
                    if (item) {
                        item.width = Qt.binding(function () { return pageLoader.width })
                        item.height = Qt.binding(function () { return pageLoader.height })
                        root._syncPageContext(item, pageSlot.pageIndex)
                    }
                    if (pageSlot.pageIndex === root.currentIndex)
                        root._tryShow(pageSlot.pageIndex)
                }

                onStatusChanged: {
                    if (status === Loader.Ready && pageSlot.pageIndex === root.currentIndex)
                        root._tryShow(pageSlot.pageIndex)
                    if (status === Loader.Error)
                        console.warn("Md3PageHost: failed to load", source)
                }
            }

            onKeepChanged: {
                if (keep && pageLoader.active) {
                    const ldr = pageLoader
                    const idx = pageSlot.pageIndex
                    Qt.callLater(function () {
                        if (ldr && ldr.active)
                            root._fillLoader(ldr, idx)
                    })
                }
            }
        }
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
                                    && root._leaveSnapShownOpacity() < 0.2
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
            layout: root.effectiveSkeletonLayout
            bones: root.effectiveSkeletonBones
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

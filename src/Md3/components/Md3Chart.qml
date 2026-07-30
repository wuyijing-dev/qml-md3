import QtQuick
import QtQuick.Window
import Md3

/// Base for all Md3 charts — shared plot metrics, theme resolve, pause/rebuild API.
Item {
    id: root

    property var values: []
    property var series: []
    property var seriesColors: []

    /// When true, unresolved colors read Md3Theme at rebuild (no per-role bindings).
    property bool followTheme: true
    /// Explicit colors (alpha > 0) override theme.
    property color lineColor: "transparent"
    property color fillColor: "transparent"
    property color gridColor: "transparent"
    property color axisLabelColor: "transparent"
    property color backgroundColor: "transparent"
    property color surfaceColor: "transparent"

    property real lineWidth: 2.5
    property bool showArea: true
    /// 0–1 multiplier on theme/default area fill (higher = stronger area emphasis).
    property real areaOpacity: 0.28
    property bool areaEmphasis: false
    property bool showDots: false
    property bool showGrid: true
    property bool showYLabels: true
    property bool showXLabels: false
    property bool smooth: true
    property real minY: Number.NaN
    property real maxY: Number.NaN
    property int horizontalGridLines: 4
    property real contentPadding: 8
    property real labelWidth: showYLabels ? 36 : 0
    property real dotRadius: 3
    property string yUnit: ""
    property int valueDecimals: 0
    property int smoothMaxPoints: 400
    property int dotsMaxPoints: 80
    /// Category labels for probe / axes (optional, length ≈ values).
    property var labels: []
    property string probeTitle: qsTr("Point")

    /// Wheel zoom + drag pan + inertia (X window over data). Default on.
    property bool interactive: true
    /// Hover/tap nearest-point readout.
    property bool showProbe: true
    /// Visible window in normalized data space [0, 1].
    property real viewStart: 0
    property real viewSpan: 1
    property real minViewSpan: 0.04
    /// Inertia decay per second after pan release (0 = hard stop). Overridden by effects level.
    property real panInertia: Md3Theme.effectsChartInertia ? 0.92 : 0
    property int probeIndex: -1
    property real probePixelX: 0
    property real probePixelY: 0
    property bool probeActive: false
    /// [{ label, value, color }]
    property var probeSeries: []
    /// True while user is dragging / wheeling — charts should skip heavy work.
    property bool gestureActive: false
    property real _panVelocity: 0
    property bool _viewDirty: false
    /// True while dragging or coasting — skip Catmull / async Shape to avoid release flicker.
    readonly property bool viewMoving: gestureActive || Math.abs(_panVelocity) > 1e-5

    property bool paused: false
    /// Only block when minimized/hidden/suspended — never for theme reveal.
    readonly property bool interactionBlocked: {
        const w = Window.window
        if (!w)
            return false
        if (w.visibility === Window.Minimized || w.visibility === Window.Hidden)
            return true
        if (Qt.application.state === Qt.ApplicationSuspended
                || Qt.application.state === Qt.ApplicationHidden)
            return true
        return false
    }
    /// Walk ancestors — PageHost hides cached pages via parent opacity/visible.
    readonly property bool effectivelyShown: {
        let p = root
        while (p) {
            if (!p.visible || p.opacity < 0.01)
                return false
            p = p.parent
        }
        return true
    }
    /// Page/window visibility only — no per-scroll mapToItem (that starved the UI thread / rail).
    readonly property bool chartActive: !paused && !interactionBlocked && enabled
                                        && effectivelyShown

    property int renderedPointCount: 0

    signal cleared()
    signal rebuilt()

    implicitWidth: 280
    implicitHeight: 160

    readonly property real plotLeft: contentPadding + labelWidth
    readonly property real plotRight: width - contentPadding
    readonly property real plotTop: contentPadding + 4
    readonly property real plotBottom: height - contentPadding - (showXLabels ? 16 : 0)
    readonly property real plotWidth: Math.max(1, plotRight - plotLeft)
    readonly property real plotHeight: Math.max(1, plotBottom - plotTop)

    function resolvedLineColor() {
        return lineColor.a > 0.01 ? lineColor : Md3Theme.colorScheme.primary
    }
    function resolvedFillColor() {
        if (fillColor.a > 0.01)
            return fillColor
        const a = areaEmphasis ? Math.min(0.55, areaOpacity * 1.6) : areaOpacity
        return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, a)
    }
    function resolvedGridColor() {
        return gridColor.a > 0.01 ? gridColor : Md3Theme.colorScheme.outlineVariant
    }
    function resolvedAxisLabelColor() {
        return axisLabelColor.a > 0.01 ? axisLabelColor
             : Md3Theme.colorScheme.colorOnSurfaceVariant
    }
    function resolvedSurfaceColor() {
        return surfaceColor.a > 0.01 ? surfaceColor : Md3Theme.colorScheme.surface
    }

    function colorAt(index) {
        if (seriesColors && index < seriesColors.length)
            return seriesColors[index]
        if (index === 0)
            return resolvedLineColor()
        const roles = [
            Md3Theme.colorScheme.primary,
            Md3Theme.colorScheme.secondary,
            Md3Theme.colorScheme.tertiary,
            Md3Theme.colorScheme.error
        ]
        return roles[index % roles.length]
    }

    function asNumber(v) {
        if (v === undefined || v === null)
            return Number.NaN
        if (typeof v === "number")
            return v
        if (typeof v === "object" && v.y !== undefined)
            return Number(v.y)
        return Number(v)
    }

    function seriesNums(s) {
        if (!s || s.length === undefined)
            return []
        const n = s.length
        if (n === 0)
            return []
        if (typeof s[0] === "number") {
            const out = new Array(n)
            for (let i = 0; i < n; ++i)
                out[i] = s[i]
            return out
        }
        const out = []
        for (let i = 0; i < n; ++i) {
            const v = asNumber(s[i])
            if (!isNaN(v))
                out.push(v)
        }
        return out
    }

    function rangeFromSeries(all) {
        let lo = minY
        let hi = maxY
        if (!isNaN(lo) && !isNaN(hi) && hi > lo)
            return { min: lo, max: hi }
        lo = Infinity
        hi = -Infinity
        let found = false
        for (let s = 0; s < all.length; ++s) {
            const nums = seriesNums(all[s])
            for (let i = 0; i < nums.length; ++i) {
                found = true
                if (nums[i] < lo) lo = nums[i]
                if (nums[i] > hi) hi = nums[i]
            }
        }
        if (!found)
            return { min: 0, max: 1 }
        if (hi <= lo) {
            lo -= 1
            hi += 1
        }
        const pad = (hi - lo) * 0.08
        return { min: lo - pad, max: hi + pad }
    }

    function rebuild() { rebuilt() }

    function requestRebuild() {
        rebuildTimer.restart()
    }

    function pause() { paused = true }
    function resume() { paused = false }
    function clear() {
        values = []
        series = []
        cleared()
        requestRebuild()
    }
    function fitY() {
        minY = Number.NaN
        maxY = Number.NaN
        requestRebuild()
    }
    function setValues(list) {
        values = list
        series = []
        requestRebuild()
    }
    function resetView() {
        _panVelocity = 0
        gestureActive = false
        viewStart = 0
        viewSpan = 1
        rebuild()
    }
    function clampView() {
        viewSpan = Math.min(1, Math.max(minViewSpan, viewSpan))
        viewStart = Math.min(Math.max(0, viewStart), Math.max(0, 1 - viewSpan))
    }
    function beginGesture() {
        if (!interactive)
            return
        gestureActive = true
        _panVelocity = 0
        rebuildTimer.stop()
    }
    function endGesture() {
        gestureActive = false
        if (!Md3Theme.effectsChartInertia)
            _panVelocity = 0
        // Coasting: keep raw paths; do not smooth-rebuild here (that was the release flicker).
        if (Math.abs(_panVelocity) > 1e-5)
            return
        _panVelocity = 0
        if (_viewDirty) {
            _viewDirty = false
            rebuild()
        }
    }
    function _markViewDirty() {
        _viewDirty = true
        if (!viewSync.running)
            viewSync.start()
    }
    /// Zoom centered on frac in [0,1] of plot width (0=left).
    function zoomAt(frac, factor) {
        if (!interactive)
            return
        frac = Math.min(1, Math.max(0, frac))
        const center = viewStart + viewSpan * frac
        let next = viewSpan * factor
        next = Math.min(1, Math.max(minViewSpan, next))
        viewStart = center - next * frac
        viewSpan = next
        clampView()
        _panVelocity = 0
        _markViewDirty()
    }
    function panByFrac(delta, trackVelocity) {
        if (!interactive)
            return
        viewStart += delta
        clampView()
        if (trackVelocity)
            _panVelocity = delta
        _markViewDirty()
    }
    function setProbe(index, pixelX, seriesInfo, pixelY) {
        probeIndex = index
        probePixelX = pixelX
        if (pixelY !== undefined && pixelY !== null)
            probePixelY = pixelY
        probeSeries = seriesInfo || []
        probeActive = index >= 0
    }
    function clearProbe() {
        probeIndex = -1
        probeSeries = []
        probeActive = false
    }
    function categoryLabel(index) {
        if (labels && index >= 0 && index < labels.length
                && labels[index] !== undefined && labels[index] !== null
                && String(labels[index]).length)
            return String(labels[index])
        return qsTr("#%1").arg(index)
    }
    /// Visible sample window for length-n series under viewStart/viewSpan.
    function windowIndices(n) {
        if (n <= 1)
            return { i0: 0, i1: 0, start: 0, end: 0 }
        const start = viewStart * (n - 1)
        const end = Math.min(n - 1, (viewStart + viewSpan) * (n - 1))
        const i0 = Math.max(0, Math.floor(start))
        const i1 = Math.min(n - 1, Math.ceil(end))
        return { i0: i0, i1: i1, start: start, end: Math.max(start + 1e-6, end) }
    }
    function indexAtPlotX(px, n) {
        if (n <= 0)
            return -1
        if (n === 1)
            return 0
        const win = windowIndices(n)
        const t = (px - plotLeft) / Math.max(1, plotWidth)
        const idx = Math.round(win.start + t * (win.end - win.start))
        return Math.min(n - 1, Math.max(0, idx))
    }
    function plotXForIndex(index, n) {
        if (n <= 1)
            return plotLeft + plotWidth / 2
        const win = windowIndices(n)
        const denom = Math.max(1e-6, win.end - win.start)
        return plotLeft + plotWidth * (index - win.start) / denom
    }

    Timer {
        id: rebuildTimer
        interval: 16
        onTriggered: root.rebuild()
    }
    /// Coalesce pan/zoom to one rebuild per frame (smoother than every mouse move).
    Timer {
        id: viewSync
        interval: 0
        repeat: false
        onTriggered: {
            if (!root._viewDirty)
                return
            root._viewDirty = false
            root.rebuild()
        }
    }
    FrameAnimation {
        running: root.interactive && root.chartActive && Md3Theme.effectsChartInertia
                 && !root.gestureActive && Math.abs(root._panVelocity) > 1e-5
        onTriggered: {
            root.viewStart += root._panVelocity
            root.clampView()
            root._panVelocity *= Math.pow(root.panInertia, Math.max(1, frameTime * 60))
            if (root.viewStart <= 0 || root.viewStart >= 1 - root.viewSpan)
                root._panVelocity = 0
            if (Math.abs(root._panVelocity) < 1e-5) {
                root._panVelocity = 0
                root._viewDirty = false
                root.rebuild()
            } else {
                root._markViewDirty()
            }
        }
    }
    Timer {
        id: themeDebounce
        interval: 50
        onTriggered: root.requestRebuild()
    }
    Connections {
        target: Md3Theme
        enabled: root.followTheme
        function onDarkChanged() {
            // Reveal: hole shows live content — must switch to NEW theme immediately.
            root.requestRebuild()
        }
        function onSeedChanged() { themeDebounce.restart() }
    }

    onWidthChanged: requestRebuild()
    onHeightChanged: requestRebuild()
    onValuesChanged: requestRebuild()
    onSeriesChanged: requestRebuild()
    onSeriesColorsChanged: requestRebuild()
    onShowAreaChanged: requestRebuild()
    onAreaOpacityChanged: requestRebuild()
    onAreaEmphasisChanged: requestRebuild()
    onShowDotsChanged: requestRebuild()
    onShowGridChanged: requestRebuild()
    onSmoothChanged: requestRebuild()
    onMinYChanged: requestRebuild()
    onMaxYChanged: requestRebuild()
    onHorizontalGridLinesChanged: requestRebuild()
    onLineWidthChanged: requestRebuild()
    // viewStart / viewSpan: callers (zoom/pan/reset) invoke requestRebuild()
    onLineColorChanged: themeDebounce.restart()
    onFillColorChanged: themeDebounce.restart()
    onGridColorChanged: themeDebounce.restart()
    onAxisLabelColorChanged: themeDebounce.restart()
    onSurfaceColorChanged: themeDebounce.restart()

    Component.onCompleted: rebuild()
}

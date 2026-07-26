import QtQuick
import QtQuick.Window

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

    property bool paused: false
    /// Only block when minimized/hidden — never for theme reveal.
    readonly property bool interactionBlocked: {
        const w = Window.window
        if (!w)
            return false
        if (w.visibility === Window.Minimized || w.visibility === Window.Hidden)
            return true
        return false
    }
    readonly property bool chartActive: !paused && !interactionBlocked && enabled

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
        return fillColor.a > 0.01 ? fillColor
             : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.20)
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

    Timer {
        id: rebuildTimer
        interval: 16
        onTriggered: root.rebuild()
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
    onShowDotsChanged: requestRebuild()
    onShowGridChanged: requestRebuild()
    onSmoothChanged: requestRebuild()
    onMinYChanged: requestRebuild()
    onMaxYChanged: requestRebuild()
    onHorizontalGridLinesChanged: requestRebuild()
    onLineWidthChanged: requestRebuild()
    onLineColorChanged: themeDebounce.restart()
    onFillColorChanged: themeDebounce.restart()
    onGridColorChanged: themeDebounce.restart()
    onAxisLabelColorChanged: themeDebounce.restart()
    onSurfaceColorChanged: themeDebounce.restart()

    Component.onCompleted: rebuild()
}

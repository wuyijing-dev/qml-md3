pragma Singleton
import QtQuick

/// Runtime Qt kit facts + Md3 behavior policy so 6.5 / 6.8 / 6.10 look the same.
/// Link differences (QuickEffects public vs Private) stay in CMake; QML always uses
/// the strict layout path (Column/Flickable consume height, not implicit-only).
QtObject {
    id: root

    readonly property int qtMajor: 6
    /// Best-effort parse of Qt.uiLanguage / platform; prefer compile-time docs for gates.
    readonly property string qtVersion: typeof Qt !== "undefined" && Qt.version
                                        ? String(Qt.version) : "6.x"
    readonly property int qtMinor: {
        const parts = String(qtVersion).split(".")
        const n = parts.length > 1 ? Number(parts[1]) : 0
        return Number.isFinite(n) ? n : 0
    }

    /// Always true: Md3 layout shells sync height←implicitHeight (Qt 6.8 Column semantics).
    readonly property bool strictColumnHeight: true
    /// Prefer contentHeight: item.implicitHeight on Flickables (stable across kits).
    readonly property bool flickableUsesImplicitHeight: true
    /// DataTable must not bind bodyHeight to height while height tracks implicitHeight.
    readonly property bool dataTableAvoidHeightLoop: true

    readonly property bool atLeast68: qtMinor >= 8
    readonly property bool atLeast610: qtMinor >= 10

    function widthFromImplicit(item) {
        if (!item)
            return 0
        const w = Number(item.width) || 0
        const iw = Number(item.implicitWidth) || 0
        return Math.max(w, iw, 0)
    }

    function heightFromImplicit(item) {
        if (!item)
            return 0
        const h = Number(item.height) || 0
        const ih = Number(item.implicitHeight) || 0
        return Math.max(h, ih, 0)
    }
}

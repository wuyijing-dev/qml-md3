import QtQuick
import Md3

/// Lightweight spacer. Use `size` for fixed gaps, or `expand: true` inside
/// Md3HStack / Md3VStack to absorb remaining space (SwiftUI-style).
Item {
    id: root

    property real size: 0
    property real spacerWidth: size
    property real spacerHeight: size
    /// When true, parent Md3HStack/Md3VStack stretches this item to fill leftover space.
    property bool expand: false

    implicitWidth: expand ? 1 : spacerWidth
    implicitHeight: expand ? 1 : spacerHeight
}

import QtQuick
import Md3

Rectangle {
    id: root

    enum Variant { Full, Inset, Middle }
    enum Orientation { Horizontal, Vertical }

    property int variant: Md3Divider.Full
    property int orientation: Md3Divider.Horizontal
    /// Toolbar convenience; when true, draws a vertical rule.
    property bool vertical: false
    property real inset: 16

    readonly property bool _vertical: vertical || orientation === Md3Divider.Vertical

    color: Md3Theme.colorScheme.outlineVariant
    implicitWidth: _vertical ? 1 : 100
    implicitHeight: _vertical ? 24 : 1
    height: _vertical ? implicitHeight : 1

    Binding on width {
        when: root._vertical
        value: 1
        restoreMode: Binding.RestoreNone
    }

    anchors.leftMargin: (!_vertical && variant !== Md3Divider.Full) ? inset : 0
    anchors.rightMargin: (!_vertical && variant === Md3Divider.Middle) ? inset : 0
    anchors.topMargin: (_vertical && variant !== Md3Divider.Full) ? inset : 0
    anchors.bottomMargin: (_vertical && variant === Md3Divider.Middle) ? inset : 0
}

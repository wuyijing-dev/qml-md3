import QtQuick
import Md3

Rectangle {
    id: root

    enum Variant { Full, Inset, Middle }

    property int variant: Md3Divider.Full
    property real inset: 16

    height: 1
    color: Md3Theme.colorScheme.outlineVariant
    anchors.leftMargin: variant === Md3Divider.Full ? 0 : inset
    anchors.rightMargin: variant === Md3Divider.Middle ? inset : 0
}

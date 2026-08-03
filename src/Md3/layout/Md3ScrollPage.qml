import QtQuick
import Md3

/// Reliable page scroller: measured VStack inside ``Md3ScrollView`` (Tab / Fit hosts).
Md3ScrollView {
    id: root

    property real pageSpacing: Md3Theme.spacingMd
    property real pagePadding: 0
    default property alias pageContent: column.data
    property alias column: column

    Md3VStack {
        id: column
        width: Math.max(1, root.contentAvailableWidth - root.pagePadding * 2)
        x: root.pagePadding
        spacing: root.pageSpacing
        fillWidth: true
    }
}

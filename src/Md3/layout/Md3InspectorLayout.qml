import QtQuick
import Md3

/// List + detail nested split (inspector pattern). Direct children: pane0 = list, pane1 = detail.
Md3SplitView {
    id: root

    orientation: Md3SplitView.Horizontal
    splitRatio: 0.38
    minPane1: 200
    minPane2: 280
}

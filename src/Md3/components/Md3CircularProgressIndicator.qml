import QtQuick

/// Theme-bound facade over Scene Graph node (Md3CircularProgressNode).
Item {
    id: root

    enum Style { Standard, Wavy, Lively, Soft }

    property real value: 0
    property bool indeterminate: true
    property int style: Md3CircularProgressIndicator.Standard
    property real strokeWidth: node.strokeWidth
    property real size: style === Md3CircularProgressIndicator.Standard ? 48 : 52
    property real amplitude: node.amplitude
    property int waveCount: node.waveCount
    property real waveSpeed: Math.PI * 2 / 1.8
    property color trackColor: Md3Theme.colorScheme.surfaceContainerHighest
    property color indicatorColor: Md3Theme.colorScheme.primary

    width: size
    height: size

    Md3CircularProgressNode {
        id: node
        anchors.fill: parent
        value: root.value
        indeterminate: root.indeterminate
        style: root.style
        waveSpeed: root.waveSpeed
        trackColor: root.trackColor
        indicatorColor: root.indicatorColor
        progressSpinMs: Md3Motion.progressSpin
        progressSweepMs: Md3Motion.progressSweep
        indicatorSize: root.size
    }
}

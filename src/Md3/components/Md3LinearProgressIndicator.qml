import QtQuick

/// Theme-bound facade over Scene Graph node (Md3LinearProgressNode).
Item {
    id: root

    enum Style { Standard, Wavy, Lively, Soft }

    property real value: 0
    property bool indeterminate: false
    property bool enabled: true
    property int style: Md3LinearProgressIndicator.Standard
    property bool showStopIndicator: true
    property real wavelength: node.wavelength
    property real amplitude: node.amplitude
    property real trackThickness: node.trackThickness
    property real waveSpeed: Math.PI * 2 / 1.8
    property color trackColor: Md3Theme.colorScheme.surfaceContainerHighest
    property color indicatorColor: Md3Theme.colorScheme.primary

    implicitWidth: 200
    implicitHeight: node.preferredHeight
    height: implicitHeight
    width: implicitWidth
    clip: true

    Md3LinearProgressNode {
        id: node
        anchors.fill: parent
        enabled: root.enabled
        value: root.value
        indeterminate: root.indeterminate
        style: root.style
        showStopIndicator: root.showStopIndicator
        waveSpeed: root.waveSpeed
        trackColor: root.trackColor
        indicatorColor: root.indicatorColor
        progressTravelMs: Md3Motion.progressTravel
    }
}

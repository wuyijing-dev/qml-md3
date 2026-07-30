import QtQuick

/// Bullet chart — qualitative ranges + measure + comparative marker.
Item {
    id: root

    property real value: 0
    property real comparative: Number.NaN
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: ""
    /// Sorted ascending qualitative thresholds, e.g. [50, 75, 100]
    property var ranges: [50, 75, 100]
    property var rangeColors: []
    property real barHeight: 18
    property real trackHeight: 28

    implicitWidth: 320
    implicitHeight: label.length ? 56 : 40
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        return Math.max(0, Math.min(1, (value - from) / span))
    }

    function _rangeColor(i) {
        if (rangeColors && rangeColors[i] !== undefined)
            return rangeColors[i]
        const base = Md3Theme.colorScheme.primary
        const alphas = [0.18, 0.32, 0.48, 0.62]
        return Qt.rgba(base.r, base.g, base.b, alphas[Math.min(i, alphas.length - 1)])
    }

    Column {
        anchors.fill: parent
        spacing: 4

        Text {
            visible: root.label.length > 0
            text: root.label + (root.unit.length ? (" (" + root.unit + ")") : "")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelMedium.size
        }

        Item {
            width: parent.width
            height: root.trackHeight

            // Qualitative bands
            Row {
                id: bands
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: root.trackHeight
                property var _thresh: {
                    const r = (root.ranges || []).slice()
                    r.sort(function (a, b) { return a - b })
                    return r
                }
                Repeater {
                    model: {
                        const t = bands._thresh
                        const out = []
                        let prev = root.from
                        for (let i = 0; i < t.length; ++i) {
                            out.push({ from: prev, to: t[i], index: i })
                            prev = t[i]
                        }
                        if (prev < root.to)
                            out.push({ from: prev, to: root.to, index: t.length })
                        return out
                    }
                    Rectangle {
                        required property var modelData
                        height: parent.height
                        width: {
                            const span = Math.max(1e-6, root.to - root.from)
                            return Math.max(0, (modelData.to - modelData.from) / span * bands.width)
                        }
                        color: root._rangeColor(modelData.index)
                    }
                }
            }

            // Measure bar
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height: root.barHeight
                width: Math.max(2, parent.width * root.progress)
                radius: 2
                color: Md3Theme.colorScheme.primary
            }

            // Comparative marker
            Rectangle {
                visible: !isNaN(root.comparative)
                anchors.verticalCenter: parent.verticalCenter
                width: 3
                height: root.trackHeight + 4
                radius: 1
                color: Md3Theme.colorScheme.error
                x: {
                    const span = Math.max(1e-6, root.to - root.from)
                    const t = Math.max(0, Math.min(1, (root.comparative - root.from) / span))
                    return parent.width * t - width / 2
                }
            }
        }
    }
}

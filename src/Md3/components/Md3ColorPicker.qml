import QtQuick
import QtQuick.Layouts
import Md3

/// Compact HSL color picker for theme seed / design tools.
Item {
    id: root

    property color color: Md3Theme.seed
    property bool showHex: true
    property bool showApplySeed: false

    signal colorEdited(color c)
    signal applySeedRequested(color c)

    property real _h: color.hslHue
    property real _s: Math.max(0.05, Math.min(1, color.hslSaturation))
    property real _l: Math.max(0.08, Math.min(0.92, color.hslLightness))

    implicitWidth: 280
    implicitHeight: col.implicitHeight

    Accessible.role: Accessible.ComboBox
    Accessible.name: qsTr("Color picker")

    function _emit() {
        const c = Qt.hsla(_h, _s, _l, 1)
        color = c
        colorEdited(c)
    }

    function setFromColor(c) {
        color = c
        _h = c.hslHue
        _s = Math.max(0.05, Math.min(1, c.hslSaturation))
        _l = Math.max(0.08, Math.min(0.92, c.hslLightness))
    }

    ColumnLayout {
        id: col
        width: parent.width
        spacing: 12

        RowLayout {
            spacing: 12
            Layout.fillWidth: true

            Rectangle {
                Layout.preferredWidth: 56
                Layout.preferredHeight: 56
                radius: Md3Theme.shape.medium
                color: root.color
                border.width: 1
                border.color: Md3Theme.colorScheme.outlineVariant
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                Text {
                    text: qsTr("Selected")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.labelMedium.size
                }
                Text {
                    visible: root.showHex
                    text: String(root.color)
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                }
            }
        }

        Text {
            text: qsTr("Hue")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelMedium.size
        }
        Md3Slider {
            Layout.fillWidth: true
            from: 0
            to: 1
            value: root._h
            onMoved: function (v) {
                root._h = v
                root._emit()
            }
        }

        Text {
            text: qsTr("Saturation")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelMedium.size
        }
        Md3Slider {
            Layout.fillWidth: true
            from: 0.05
            to: 1
            value: root._s
            onMoved: function (v) {
                root._s = v
                root._emit()
            }
        }

        Text {
            text: qsTr("Lightness")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelMedium.size
        }
        Md3Slider {
            Layout.fillWidth: true
            from: 0.08
            to: 0.92
            value: root._l
            onMoved: function (v) {
                root._l = v
                root._emit()
            }
        }

        // Quick seed-friendly presets
        Row {
            spacing: 8
            Repeater {
                model: [
                    "#6750A4", "#006A6A", "#8B5000", "#B3261E",
                    "#006E1C", "#1B6EF3", "#7B5800", "#9A4521"
                ]
                Rectangle {
                    required property string modelData
                    width: 28
                    height: 28
                    radius: 14
                    color: modelData
                    border.width: 1
                    border.color: Md3Theme.colorScheme.outlineVariant
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.setFromColor(Qt.color(modelData))
                    }
                }
            }
        }

        Md3Button {
            visible: root.showApplySeed
            text: qsTr("Apply as theme seed")
            Layout.fillWidth: true
            onClicked: {
                root.applySeedRequested(root.color)
                Md3Theme.applySeed(root.color)
            }
        }
    }

    onColorChanged: {
        // Keep HSV knobs in sync when set externally (avoid feedback loops on drag).
        if (Math.abs(_h - color.hslHue) > 0.001)
            _h = color.hslHue
        const s = Math.max(0.05, Math.min(1, color.hslSaturation))
        const l = Math.max(0.08, Math.min(0.92, color.hslLightness))
        if (Math.abs(_s - s) > 0.001)
            _s = s
        if (Math.abs(_l - l) > 0.001)
            _l = l
    }
}

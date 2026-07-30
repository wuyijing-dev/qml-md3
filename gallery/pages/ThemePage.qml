import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true

    LayoutMirroring.enabled: rtlSwitch.checked
    LayoutMirroring.childrenInherit: true

    // 20 Hz leading+trailing throttle for live seed drag
    property real _seedHue: Md3Theme.seed.hslHue
    property real _seedChroma: Math.max(0.15, Math.min(0.75, Md3Theme.seed.hslSaturation))
    property bool _seedPending: false
    readonly property int seedApplyIntervalMs: 50

    Timer {
        id: seedThrottle
        interval: root.seedApplyIntervalMs
        repeat: false
        onTriggered: {
            if (!root._seedPending)
                return
            root._seedPending = false
            Md3Theme.applySeed(Qt.hsla(root._seedHue, root._seedChroma, 0.40, 1))
            seedThrottle.start()
        }
    }

    function scheduleSeed(h, c) {
        _seedHue = h
        _seedChroma = c
        if (!seedThrottle.running) {
            Md3Theme.applySeed(Qt.hsla(h, c, 0.40, 1))
            seedThrottle.start()
        } else {
            _seedPending = true
        }
    }

    component Swatch: Rectangle {
        property string roleName: ""
        property color roleColor: "transparent"
        property color labelColor: Md3Theme.colorScheme.colorOnSurface
        Layout.fillWidth: true
        Layout.preferredHeight: 56
        radius: Md3Theme.shape.medium
        color: roleColor
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: roleName
            color: parent.labelColor
            font.pixelSize: Md3Theme.typography.labelLarge.size
            font.family: Md3Theme.typography.fontFamily
        }
    }

    ColumnLayout {
        id: column
        width: root.width
        spacing: 20

        Text {
            text: qsTr("Theme")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            text: qsTr("Dynamic color from seed (Material You tonal roles)")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }

        Md3WindowHelper { id: winNative }

        RowLayout {
            spacing: 12
            Md3Button {
                id: themeSwitchBtn
                text: Md3Theme.dark ? qsTr("Switch to light") : qsTr("Switch to dark")
                onClicked: {
                    const w = Window.window
                    if (w && typeof w.toggleThemeFrom === "function")
                        w.toggleThemeFrom(themeSwitchBtn)
                    else
                        Md3Theme.toggleDark()
                }
            }
            Md3Button {
                visible: winNative.systemAccentSupported
                text: qsTr("System accent")
                variant: Md3Button.FilledTonal
                onClicked: Md3Theme.applySeed(winNative.systemAccentColor())
            }
            Md3Button {
                visible: winNative.systemAccentSupported
                text: qsTr("From wallpaper")
                variant: Md3Button.Outlined
                onClicked: Md3Theme.applySeed(winNative.wallpaperSeedColor())
            }
        }

        Text {
            text: qsTr("Live hue / chroma")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        Md3ColorPicker {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            showApplySeed: true
            color: Md3Theme.seed
            onColorEdited: function (c) {
                root.scheduleSeed(c.hslHue, Math.max(0.15, Math.min(0.75, c.hslSaturation)))
            }
            onApplySeedRequested: function (c) {
                Md3Theme.applySeed(c)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Text {
                text: qsTr("Hue")
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
            }
            Md3Slider {
                id: hueSlider
                Layout.fillWidth: true
                from: 0
                to: 1
                value: Md3Theme.seed.hslHue
                showStopIndicator: false
                onMoved: function (v) {
                    root.scheduleSeed(v, chromaSlider.value)
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Text {
                text: qsTr("Chroma")
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
            }
            Md3Slider {
                id: chromaSlider
                Layout.fillWidth: true
                from: 0.15
                to: 0.75
                value: Math.max(0.15, Math.min(0.75, Md3Theme.seed.hslSaturation))
                showStopIndicator: false
                onMoved: function (v) {
                    root.scheduleSeed(hueSlider.value, v)
                }
            }
        }

        Text {
            text: qsTr("Seed presets")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        Flow {
            Layout.fillWidth: true
            spacing: 8
            Repeater {
                model: [
                    { label: qsTr("Purple"), color: "#6750A4" },
                    { label: qsTr("Teal"), color: "#006A6A" },
                    { label: qsTr("Orange"), color: "#8B5000" },
                    { label: qsTr("Blue"), color: "#195D9C" },
                    { label: qsTr("Green"), color: "#2E6B32" },
                    { label: qsTr("Rose"), color: "#A33B5A" },
                    { label: qsTr("Slate"), color: "#4A5C6A" }
                ]
                delegate: Md3Button {
                    required property var modelData
                    text: modelData.label
                    variant: Md3Button.Outlined
                    onClicked: Md3Theme.applySeed(modelData.color)
                }
            }
        }

        Text {
            text: qsTr("Live roles")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 8
            rowSpacing: 8

            Swatch {
                roleName: "primary"
                roleColor: Md3Theme.colorScheme.primary
                labelColor: Md3Theme.colorScheme.colorOnPrimary
            }
            Swatch {
                roleName: "primaryContainer"
                roleColor: Md3Theme.colorScheme.primaryContainer
                labelColor: Md3Theme.colorScheme.colorOnPrimaryContainer
            }
            Swatch {
                roleName: "secondary"
                roleColor: Md3Theme.colorScheme.secondary
                labelColor: Md3Theme.colorScheme.colorOnSecondary
            }
            Swatch {
                roleName: "secondaryContainer"
                roleColor: Md3Theme.colorScheme.secondaryContainer
                labelColor: Md3Theme.colorScheme.colorOnSecondaryContainer
            }
            Swatch {
                roleName: "tertiary"
                roleColor: Md3Theme.colorScheme.tertiary
                labelColor: Md3Theme.colorScheme.colorOnTertiary
            }
            Swatch {
                roleName: "tertiaryContainer"
                roleColor: Md3Theme.colorScheme.tertiaryContainer
                labelColor: Md3Theme.colorScheme.colorOnTertiaryContainer
            }
            Swatch {
                roleName: "surface"
                roleColor: Md3Theme.colorScheme.surface
                labelColor: Md3Theme.colorScheme.colorOnSurface
            }
            Swatch {
                roleName: "surfaceContainer"
                roleColor: Md3Theme.colorScheme.surfaceContainer
                labelColor: Md3Theme.colorScheme.colorOnSurface
            }
            Swatch {
                roleName: "error"
                roleColor: Md3Theme.colorScheme.error
                labelColor: Md3Theme.colorScheme.colorOnError
            }
            Swatch {
                roleName: "outline"
                roleColor: Md3Theme.colorScheme.outline
                labelColor: Md3Theme.colorScheme.colorOnPrimary
            }
        }

        Text {
            text: qsTr("Controls on dynamic scheme")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        RowLayout {
            spacing: 12
            Md3Button { text: qsTr("Filled") }
            Md3Button { text: qsTr("Tonal"); variant: Md3Button.FilledTonal }
            Md3Button { text: qsTr("Outlined"); variant: Md3Button.Outlined }
            Md3Fab { icon: "add" }
        }

        RowLayout {
            spacing: 16
            Md3Switch { }
            Md3Switch { checked: true }
            Md3Switch { checked: true; showIcon: true }
            Md3Checkbox { checked: true }
            Md3Checkbox { }
            Md3Radio { checked: true; accessibleName: "A" }
            Md3Radio { accessibleName: "B" }
        }

        Md3Slider {
            Layout.fillWidth: true
            from: 0
            to: 100
            value: 62
            trackHeight: 20
            handleWidth: 10
        }

        Md3FilterChip {
            text: qsTr("Filter chip")
            selected: true
        }

        RowLayout {
            spacing: 12
            Text {
                text: qsTr("Text scale")
                color: Md3Theme.colorScheme.colorOnSurface
            }
            Md3Button {
                text: "100%"
                variant: Md3Button.Text
                onClicked: Md3Theme.textScale = 1.0
            }
            Md3Button {
                text: "125%"
                variant: Md3Button.Text
                onClicked: Md3Theme.textScale = 1.25
            }
            Md3Button {
                text: "150%"
                variant: Md3Button.Text
                onClicked: Md3Theme.textScale = 1.5
            }
        }

        Text {
            text: qsTr("Accessibility")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleMedium.size
            font.family: Md3Theme.typography.fontFamily
            Layout.topMargin: 8
        }

        RowLayout {
            spacing: 12
            Layout.fillWidth: true
            Column {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    text: qsTr("特效等级")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                }
                Text {
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: qsTr("流畅：少阴影/无惯性平滑；均衡：默认；画质：曲线平滑与满帧实时图。可按设备性能切换。")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
            }
        }
        Md3SegmentedButton {
            id: effectsSeg
            Layout.fillWidth: true
            model: [
                { text: qsTr("流畅") },
                { text: qsTr("均衡") },
                { text: qsTr("画质") }
            ]
            currentIndex: Md3Theme.effectsLevel
            onSelectionChanged: {
                Md3Theme.setEffectsLevel(currentIndex)
                Md3Accessibility.announce(qsTr("特效等级：%1").arg(Md3Theme.effectsLevelLabel()))
            }
        }
        Connections {
            target: Md3Theme
            function onEffectsLevelChanged() {
                if (effectsSeg.currentIndex !== Md3Theme.effectsLevel)
                    effectsSeg.currentIndex = Md3Theme.effectsLevel
            }
        }

        RowLayout {
            spacing: 12
            Layout.fillWidth: true
            Column {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    text: qsTr("减弱动效")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                }
                Text {
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: qsTr("开启后所有 Md3Motion 时长≈1ms（涟漪/切换/页面过渡都会瞬间完成）")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
            }
            Md3Switch {
                checked: Md3Theme.reduceMotion
                accessibleName: qsTr("减弱动效")
                onToggled: function (on) {
                    Md3Theme.reduceMotion = on
                    Md3Accessibility.announce(on ? qsTr("已开启减弱动效") : qsTr("已关闭减弱动效"))
                }
            }
        }

        RowLayout {
            spacing: 12
            Layout.fillWidth: true
            Column {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    text: qsTr("动效倍速")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                }
                Text {
                    text: qsTr("当前 %1×（越大越慢；减弱动效开启时无效）")
                            .arg(Md3Motion.durationScale.toFixed(1))
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
            }
            Md3Slider {
                Layout.preferredWidth: 160
                from: 1
                to: 3
                value: Md3Motion.durationScale
                enabled: !Md3Theme.reduceMotion
                onMoved: function (v) { Md3Motion.durationScale = v }
            }
        }

        RowLayout {
            spacing: 12
            Layout.fillWidth: true
            Text {
                text: qsTr("高对比度")
                color: Md3Theme.colorScheme.colorOnSurface
                Layout.fillWidth: true
            }
            Md3Switch {
                checked: Md3Theme.highContrast
                accessibleName: qsTr("高对比度")
                onToggled: function (on) {
                    Md3Theme.highContrast = on
                    Md3Accessibility.announce(on ? qsTr("已开启高对比度") : qsTr("已关闭高对比度"))
                }
            }
        }

        RowLayout {
            spacing: 12
            Layout.fillWidth: true
            Text {
                text: qsTr("始终显示焦点环")
                color: Md3Theme.colorScheme.colorOnSurface
                Layout.fillWidth: true
            }
            Md3Switch {
                checked: Md3Accessibility.showFocusRings
                accessibleName: qsTr("始终显示焦点环")
                onToggled: function (on) {
                    Md3Accessibility.showFocusRings = on
                }
            }
        }

        RowLayout {
            spacing: 12
            Text {
                text: qsTr("RTL preview")
                color: Md3Theme.colorScheme.colorOnSurface
            }
            Md3Switch {
                id: rtlSwitch
            }
            Text {
                text: qsTr("LayoutMirroring on this page")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodySmall.size
            }
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("seed=%1  dark=%2  primary=%3")
                  .arg(Md3Theme.seed)
                  .arg(Md3Theme.dark)
                  .arg(Md3Theme.colorScheme.primary)
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }
    }
}

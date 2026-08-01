import QtQuick
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.implicitHeight
    clip: true

    /// Injected by Md3PageHost (Flickable root — declare injectables without Md3Page).
    property var md3HostWindow: null
    property bool md3PageActive: true

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
        height: 56
        radius: Md3Theme.shape.medium
        color: roleColor
        Md3Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: roleName
            role: Md3Text.LabelLarge
            tone: Md3Text.Custom
            customColor: parent.labelColor
        }
    }

    Md3VStack {
        id: column
        width: root.width
        spacing: 20

        Md3Text {
            text: qsTr("Theme")
            role: Md3Text.HeadlineMedium
        }

        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("Dynamic color from seed (Material You tonal roles)")
            role: Md3Text.BodyMedium
            tone: Md3Text.OnSurfaceVariant
        }

        Md3WindowHelper { id: winNative }

        Md3HStack {
            spacing: 12
            Md3Button {
                id: themeSwitchBtn
                text: Md3Theme.dark ? qsTr("Switch to light") : qsTr("Switch to dark")
                onClicked: {
                    const w = Md3OverlayHost.resolveWindow(root.md3HostWindow, root)
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

        Md3Text {
            text: qsTr("Live hue / chroma")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }

        Md3ColorPicker {
            width: Math.min(parent.width, 360)
            showApplySeed: true
            color: Md3Theme.seed
            onColorEdited: function (c) {
                root.scheduleSeed(c.hslHue, Math.max(0.15, Math.min(0.75, c.hslSaturation)))
            }
            onApplySeedRequested: function (c) {
                Md3Theme.applySeed(c)
            }
        }

        Md3Slider {
            id: hueSlider
            width: parent.width
            label: qsTr("Hue")
            from: 0
            to: 1
            value: Md3Theme.seed.hslHue
            showStopIndicator: false
            onMoved: function (v) {
                root.scheduleSeed(v, chromaSlider.value)
            }
        }

        Md3Slider {
            id: chromaSlider
            width: parent.width
            label: qsTr("Chroma")
            from: 0.15
            to: 0.75
            value: Math.max(0.15, Math.min(0.75, Md3Theme.seed.hslSaturation))
            showStopIndicator: false
            onMoved: function (v) {
                root.scheduleSeed(hueSlider.value, v)
            }
        }

        Md3Text {
            text: qsTr("Seed presets")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }

        Md3FlowLayout {
            width: parent.width
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

        Md3Text {
            text: qsTr("Live roles")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }

        Md3GridLayout {
            width: parent.width
            columns: 2
            spacing: 8
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

        Md3Text {
            text: qsTr("Controls on dynamic scheme")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }

        Md3HStack {
            spacing: 12
            Md3Button { text: qsTr("Filled") }
            Md3Button { text: qsTr("Tonal"); variant: Md3Button.FilledTonal }
            Md3Button { text: qsTr("Outlined"); variant: Md3Button.Outlined }
            Md3Fab { icon: "add" }
        }

        Md3HStack {
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
            width: parent.width
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

        Md3HStack {
            spacing: 12
            Md3Text { text: qsTr("Text scale"); role: Md3Text.LabelLarge }
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

        Item { width: 1; height: 8 }

        Md3Text {
            text: qsTr("Density")
            role: Md3Text.TitleMedium
        }
        Md3Text {
            width: parent.width
            wrapMode: Text.Wrap
            text: qsTr("舒适：默认桌面间距；紧凑：页边距/分段控件/表格行高随 Md3Theme.density 变化（当前 pagePadding=%1、controlHeight=%2）。")
                  .arg(Md3Theme.pagePadding).arg(Md3Theme.controlHeight)
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3SegmentedButton {
            id: densitySeg
            width: parent.width
            model: [
                { text: qsTr("舒适") },
                { text: qsTr("紧凑") }
            ]
            currentIndex: Md3Theme.density
            onSelectionChanged: {
                Md3Theme.setDensity(currentIndex)
                Md3Accessibility.announce(qsTr("密度：%1").arg(Md3Theme.densityLabel()))
            }
        }
        Connections {
            target: Md3Theme
            function onDensityChanged() {
                if (densitySeg.currentIndex !== Md3Theme.density)
                    densitySeg.currentIndex = Md3Theme.density
            }
        }

        Item { width: 1; height: 8 }

        Md3Text {
            text: qsTr("Accessibility")
            role: Md3Text.TitleMedium
        }

        Md3VStack {
            width: parent.width
            spacing: 2
            Md3Text {
                text: qsTr("特效等级")
                role: Md3Text.BodyLarge
            }
            Md3Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("三档过渡相同。流畅：圆角按压闪（无涟漪遮罩 FBO）；均衡/画质：圆角遮罩涟漪。强度调节反馈深浅。")
                role: Md3Text.BodySmall
                tone: Md3Text.OnSurfaceVariant
            }
        }
        Md3SegmentedButton {
            id: effectsSeg
            width: parent.width
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

        Md3HStack {
            width: parent.width
            spacing: 12
            Md3VStack {
                width: Math.max(120, parent.width - 180)
                spacing: 2
                Md3Text {
                    text: qsTr("特效强度")
                    role: Md3Text.BodyLarge
                }
                Md3Text {
                    text: qsTr("涟漪与悬停态透明度 ×%1（叠加在特效等级之上）")
                            .arg(Md3Theme.effectsIntensity.toFixed(2))
                    role: Md3Text.BodySmall
                    tone: Md3Text.OnSurfaceVariant
                }
            }
            Md3Slider {
                width: 160
                from: 0.35
                to: 1.35
                value: Md3Theme.effectsIntensity
                onMoved: function (v) { Md3Theme.setEffectsIntensity(v) }
            }
        }

        Md3HStack {
            width: parent.width
            spacing: 12
            Md3VStack {
                width: Math.max(120, parent.width - 80)
                spacing: 2
                Md3Text {
                    text: qsTr("减弱动效")
                    role: Md3Text.BodyLarge
                }
                Md3Text {
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: qsTr("开启后所有 Md3Motion 时长≈1ms（涟漪/切换/页面过渡都会瞬间完成）")
                    role: Md3Text.BodySmall
                    tone: Md3Text.OnSurfaceVariant
                }
            }
            Md3Switch {
                checked: Md3Theme.reduceMotion
                accessibleName: qsTr("减弱动效")
                onToggled: function (on) {
                    Md3Theme.reduceMotion = on
                    Md3AppSettings.setValue("a11y/reduceMotion", on)
                    Md3AppSettings.sync()
                    Md3Accessibility.announce(on ? qsTr("已开启减弱动效") : qsTr("已关闭减弱动效"))
                }
            }
        }

        Md3HStack {
            width: parent.width
            spacing: 12
            Md3VStack {
                width: Math.max(120, parent.width - 180)
                spacing: 2
                Md3Text {
                    text: qsTr("动效倍速")
                    role: Md3Text.BodyLarge
                }
                Md3Text {
                    text: qsTr("当前 %1×（越大越慢；减弱动效开启时无效）")
                            .arg(Md3Motion.durationScale.toFixed(1))
                    role: Md3Text.BodySmall
                    tone: Md3Text.OnSurfaceVariant
                }
            }
            Md3Slider {
                width: 160
                from: 1
                to: 3
                value: Md3Motion.durationScale
                enabled: !Md3Theme.reduceMotion
                onMoved: function (v) { Md3Motion.durationScale = v }
            }
        }

        Md3HStack {
            width: parent.width
            Md3Text { text: qsTr("高对比度"); role: Md3Text.BodyLarge }
            Md3Spacer { expand: true }
            Md3Switch {
                checked: Md3Theme.highContrast
                accessibleName: qsTr("高对比度")
                onToggled: function (on) {
                    Md3Theme.highContrast = on
                    Md3Accessibility.announce(on ? qsTr("已开启高对比度") : qsTr("已关闭高对比度"))
                }
            }
        }

        Md3HStack {
            width: parent.width
            Md3Text { text: qsTr("始终显示焦点环"); role: Md3Text.BodyLarge }
            Md3Spacer { expand: true }
            Md3Switch {
                checked: Md3Accessibility.showFocusRings
                accessibleName: qsTr("始终显示焦点环")
                onToggled: function (on) {
                    Md3Accessibility.showFocusRings = on
                }
            }
        }

        Md3HStack {
            spacing: 12
            Md3Text { text: qsTr("RTL preview"); role: Md3Text.BodyLarge }
            Md3Switch {
                id: rtlSwitch
            }
            Md3Text {
                text: qsTr("LayoutMirroring on this page")
                role: Md3Text.BodySmall
                tone: Md3Text.OnSurfaceVariant
            }
        }

        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("seed=%1  dark=%2  primary=%3")
                  .arg(Md3Theme.seed)
                  .arg(Md3Theme.dark)
                  .arg(Md3Theme.colorScheme.primary)
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }
    }
}

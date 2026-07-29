import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import QtMultimedia
import Md3

Item {
    id: root

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.height
        clip: true
        interactive: glassPlayground.dragCount === 0
        boundsBehavior: Flickable.StopAtBounds
        ColumnLayout {
            id: column
            width: root.width
            spacing: 16
            Text {
                text: "Containment"
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.headlineMedium.size
            }
            Md3Text {
                Layout.fillWidth: true
                text: qsTr("Md3 容器组件默认支持 `layoutMode`（Fit / Scroll）：内容可自适应高度，或在固定高度区域内滚动。`Md3AdaptiveContainer` 仍可用于独立列布局场景。")
                role: Md3Text.BodyMedium
                tone: Md3Text.OnSurfaceVariant
                wrapMode: Text.WordWrap
            }

            Md3PageSection {
                Layout.fillWidth: true
                title: qsTr("ScrollView")
                subtitle: qsTr("Themed Md3ScrollBar overlays on a Flickable.")

                Md3ScrollView {
                    width: parent.width
                    height: 160
                    Column {
                        width: parent.width
                        spacing: 8
                        Repeater {
                            model: 24
                            Text {
                                required property int index
                                text: qsTr("Scrollable row %1").arg(index + 1)
                                color: Md3Theme.colorScheme.colorOnSurface
                                font.pixelSize: Md3Theme.typography.bodyMedium.size
                            }
                        }
                    }
                }
            }

            Md3PageSection {
                Layout.fillWidth: true
                title: qsTr("布局组件（VStack / HStack / Flow / Grid）")
                subtitle: qsTr("对齐、padding、expand spacer、Card.title 等 API 减少样板代码。")

                Md3Card {
                    width: parent.width
                    variant: Md3Card.Outlined
                    Md3VStack {
                        width: parent.width
                        spacing: 12
                        Md3HStack {
                            spacing: 8
                            Md3Button { text: qsTr("确认") }
                            Md3Button { text: qsTr("取消"); variant: Md3Button.Outlined }
                            Md3Spacer { expand: true }
                            Md3Text {
                                text: qsTr("HStack + expand")
                                tone: Md3Text.OnSurfaceVariant
                            }
                        }
                        Md3FlowLayout {
                            spacing: 8
                            rowSpacing: 8
                            Repeater {
                                model: 6
                                delegate: Md3SuggestionChip {
                                    text: qsTr("Flow %1").arg(index + 1)
                                }
                            }
                        }
                        Md3GridLayout {
                            minCellWidth: 140
                            minCellHeight: 84
                            spacing: 8
                            Repeater {
                                model: 4
                                delegate: Md3Card {
                                    title: qsTr("Grid %1").arg(index + 1)
                                    variant: Md3Card.Filled
                                }
                            }
                        }
                    }
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                spacing: 12
                Md3Card {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    variant: Md3Card.Outlined
                    layoutMode: Md3ContainerBody.Fit
                    title: qsTr("Fit 模式")
                    subtitle: qsTr("容器高度跟随内容增长，适合卡片说明、设置面板和轻量表单。")
                    Md3AnimatedFlow {
                        width: parent.width
                        Repeater {
                            model: 6
                            delegate: Md3SuggestionChip {
                                text: qsTr("标签 %1").arg(index + 1)
                            }
                        }
                    }
                }
                Md3Card {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    variant: Md3Card.Outlined
                    layoutMode: Md3ContainerBody.Scroll
                    title: qsTr("Scroll 模式")
                    Column {
                        width: parent.width
                        spacing: 12
                        Repeater {
                            model: 10
                            delegate: Md3Text {
                                width: parent ? parent.width : 240
                                text: qsTr("第 %1 段内容：当容器高度固定时，内容超出区域会在容器内部滚动，而不是把外层页面撑大。").arg(index + 1)
                                tone: Md3Text.OnSurfaceVariant
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
            }
            Md3AnimatedFlow {
                Layout.fillWidth: true
                spacing: 12
                rowSpacing: 12
                Md3Card {
                    title: "Elevated"
                    variant: Md3Card.Elevated
                    width: 180
                    height: 100
                }
                Md3Card {
                    title: "Filled"
                    variant: Md3Card.Filled
                    width: 180
                    height: 100
                }
                Md3Card {
                    title: "Outlined"
                    variant: Md3Card.Outlined
                    width: 180
                    height: 100
                }
            }

            Text {
                text: qsTr("Liquid Glass")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            Text {
                Layout.fillWidth: true
                text: qsTr("Drag the cards. Add more blocks, switch image/video behind them.")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodySmall.size
                wrapMode: Text.Wrap
            }

            Md3AnimatedFlow {
                Layout.fillWidth: true
                spacing: 8
                rowSpacing: 8
                Md3Button {
                    text: qsTr("Gradient")
                    variant: Md3Button.Outlined
                    onClicked: glassBackdrop.clearBackdrop()
                }
                Md3Button {
                    text: qsTr("Photo A")
                    variant: Md3Button.Outlined
                    onClicked: glassBackdrop.setImage("https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=1200&q=80")
                }
                Md3Button {
                    text: qsTr("Photo B")
                    variant: Md3Button.Outlined
                    onClicked: glassBackdrop.setImage("https://images.unsplash.com/photo-1557683316-973635b79489?w=1200&q=80")
                }
                Md3Button {
                    text: qsTr("Sample video")
                    variant: Md3Button.Outlined
                    onClicked: glassBackdrop.setVideo("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")
                }
                Md3Button {
                    text: qsTr("Image…")
                    variant: Md3Button.Outlined
                    onClicked: backdropImageDialog.open()
                }
                Md3Button {
                    text: qsTr("Video…")
                    variant: Md3Button.Outlined
                    onClicked: backdropVideoDialog.open()
                }
                Md3Button {
                    text: qsTr("Add block")
                    onClicked: glassPlayground.addBlock()
                }
                Md3Button {
                    text: qsTr("Remove")
                    variant: Md3Button.Outlined
                    enabled: glassBlocks.count > 0
                    onClicked: glassPlayground.removeBlock()
                }
                Text {
                    text: qsTr("%1").arg(glassBlocks.count)
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
            }

            Item {
                id: glassPlayground
                Layout.fillWidth: true
                Layout.preferredHeight: glassBackdrop.fittedHeight
                clip: true

                property int dragCount: 0
                property int _seed: 0

                ListModel {
                    id: glassBlocks
                }

                function addBlock() {
                    const i = glassBlocks.count
                    const sizes = [
                        { w: 240, h: 140 },
                        { w: 180, h: 100 },
                        { w: 200, h: 160 },
                        { w: 160, h: 160 },
                        { w: 280, h: 120 }
                    ]
                    const s = sizes[i % sizes.length]
                    const maxX = Math.max(8, width - s.w - 8)
                    const maxY = Math.max(8, height - s.h - 8)
                    glassBlocks.append({
                        "bx": 24 + (i * 36) % Math.max(24, maxX),
                        "by": 36 + (i * 44) % Math.max(24, maxY),
                        "bw": s.w,
                        "bh": s.h,
                        "label": qsTr("Glass %1").arg(i + 1)
                    })
                    _seed++
                }

                function removeBlock() {
                    if (glassBlocks.count > 0)
                        glassBlocks.remove(glassBlocks.count - 1)
                }

                Component.onCompleted: Qt.callLater(function () {
                    if (glassBlocks.count === 0)
                        addBlock()
                })

                Item {
                    id: glassBackdrop
                    anchors.fill: parent

                    property url backgroundImage: ""
                    property url backgroundVideo: ""
                    property real contentAspect: 16 / 9
                    readonly property bool hasImage: backgroundImage.toString().length > 0
                    readonly property bool hasVideo: backgroundVideo.toString().length > 0
                    readonly property bool hasMedia: hasImage || hasVideo
                    readonly property int fittedHeight: {
                        const w = glassPlayground.width > 1 ? glassPlayground.width : 640
                        const h = Math.round(w / Math.max(0.4, contentAspect))
                        return Math.min(560, Math.max(220, h))
                    }

                    function clearBackdrop() {
                        backgroundImage = ""
                        backgroundVideo = ""
                        contentAspect = 16 / 9
                        backdropPlayer.stop()
                        backdropPlayer.source = ""
                    }
                    function setImage(url) {
                        backgroundVideo = ""
                        backdropPlayer.stop()
                        backdropPlayer.source = ""
                        backgroundImage = url
                    }
                    function setVideo(url) {
                        backgroundImage = ""
                        backgroundVideo = url
                        backdropPlayer.source = url
                        backdropPlayer.play()
                    }
                    function _applySize(w, h) {
                        if (w > 0 && h > 0)
                            contentAspect = w / h
                    }

                    layer.enabled: true
                    layer.smooth: true

                    Rectangle {
                        anchors.fill: parent
                        color: "#111827"
                        radius: Md3Theme.shape.large
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: Md3Theme.shape.large
                        visible: !glassBackdrop.hasMedia
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#3B82F6" }
                            GradientStop { position: 0.3; color: "#A855F7" }
                            GradientStop { position: 0.6; color: "#F43F5E" }
                            GradientStop { position: 1.0; color: "#F59E0B" }
                        }
                    }

                    Image {
                        id: backdropImageItem
                        anchors.fill: parent
                        visible: glassBackdrop.hasImage
                        source: glassBackdrop.backgroundImage
                        fillMode: Image.Stretch
                        asynchronous: true
                        cache: true
                        onStatusChanged: {
                            if (status === Image.Ready && sourceSize.width > 0 && sourceSize.height > 0)
                                glassBackdrop._applySize(sourceSize.width, sourceSize.height)
                        }
                    }

                    MediaPlayer {
                        id: backdropPlayer
                        videoOutput: backdropVideoOut
                        audioOutput: AudioOutput { muted: true }
                        loops: MediaPlayer.Infinite
                        onMetaDataChanged: {
                            const res = metaData.value(MediaMetaData.Resolution)
                            if (res && res.width > 0 && res.height > 0)
                                glassBackdrop._applySize(res.width, res.height)
                        }
                        onErrorOccurred: function(err, msg) {
                            console.warn("LiquidGlass backdrop video:", err, msg)
                        }
                    }

                    VideoOutput {
                        id: backdropVideoOut
                        anchors.fill: parent
                        visible: glassBackdrop.hasVideo
                        fillMode: VideoOutput.Stretch
                    }

                    Rectangle {
                        anchors.fill: parent
                        visible: glassBackdrop.hasMedia
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.12) }
                            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.28) }
                        }
                    }

                    Repeater {
                        model: !glassBackdrop.hasMedia ? [
                            { t: "Aa", x: 0.08, y: 0.18, s: 42 },
                            { t: "MD3", x: 0.42, y: 0.12, s: 36 },
                            { t: "液态", x: 0.70, y: 0.28, s: 34 },
                            { t: "Glass", x: 0.18, y: 0.58, s: 40 },
                            { t: "2026", x: 0.55, y: 0.62, s: 38 }
                        ] : []
                        delegate: Text {
                            required property var modelData
                            x: modelData.x * glassBackdrop.width
                            y: modelData.y * glassBackdrop.height
                            text: modelData.t
                            color: Qt.rgba(1, 1, 1, 0.92)
                            font.pixelSize: modelData.s
                            font.bold: true
                        }
                    }

                    Repeater {
                        model: !glassBackdrop.hasMedia ? 6 : 0
                        delegate: Rectangle {
                            required property int index
                            width: 56 + (index % 3) * 24
                            height: width
                            radius: width / 2
                            x: 30 + (index * 110) % Math.max(40, glassBackdrop.width - 90)
                            y: 30 + (index * 61) % Math.max(40, glassBackdrop.height - 90)
                            color: Qt.rgba(1, 1, 1, 0.16 + (index % 3) * 0.06)
                            border.width: 2
                            border.color: Qt.rgba(1, 1, 1, 0.35)
                        }
                    }
                }

                Repeater {
                    model: glassBlocks
                    delegate: Md3LiquidGlass {
                        id: glassBlock
                        required property int index
                        required property real bx
                        required property real by
                        required property real bw
                        required property real bh
                        required property string label

                        sourceItem: glassBackdrop
                        width: bw
                        height: bh
                        radius: radiusSlider.value
                        blurAmount: blurSlider.value
                        tintOpacity: tintSlider.value
                        refraction: refractionSlider.value
                        chromaticAberration: chromaSlider.value
                        edgeStrength: edgeSlider.value
                        elevation: elevSlider.value
                        adaptiveTint: adaptiveSlider.value
                        liquidDeform: deformSlider.value
                        squircleN: squircleSlider.value
                        quality: glassBlocks.count >= 5 ? 0
                                 : (glassBlocks.count >= 3 ? 1 : qualitySlider.value)
                        liveSampling: glassBackdrop.hasVideo

                        Component.onCompleted: {
                            x = bx
                            y = by
                        }

                        onDraggingChanged: {
                            if (dragging)
                                glassPlayground.dragCount++
                            else
                                glassPlayground.dragCount = Math.max(0, glassPlayground.dragCount - 1)
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            spacing: 4
                            Md3Text {
                                text: glassBlock.label
                                role: Md3Text.TitleMedium
                                tone: Md3Text.Custom
                                customColor: "#FFFFFF"
                                font.weight: Font.DemiBold
                            }
                            Md3Text {
                                width: parent.width
                                wrapMode: Text.Wrap
                                text: qsTr("Drag me")
                                role: Md3Text.BodyMedium
                                tone: Md3Text.Custom
                                customColor: Qt.rgba(1, 1, 1, 0.88)
                            }
                        }
                    }
                }
            }

            FileDialog {
                id: backdropImageDialog
                title: qsTr("Choose backdrop image")
                nameFilters: [ qsTr("Images (*.png *.jpg *.jpeg *.bmp *.webp *.gif)"), qsTr("All files (*)") ]
                onAccepted: glassBackdrop.setImage(selectedFile)
            }
            FileDialog {
                id: backdropVideoDialog
                title: qsTr("Choose backdrop video")
                nameFilters: [
                    qsTr("Videos (*.mp4 *.webm *.mkv *.mov *.avi *.wmv)"),
                    qsTr("All files (*)")
                ]
                onAccepted: glassBackdrop.setVideo(selectedFile)
            }

            component GlassParamRow: Md3Slider {
                Layout.fillWidth: true
                showValue: true
                from: 0
                to: 1
                value: 0.5
            }

            GlassParamRow {
                id: refractionSlider
                label: qsTr("Refraction (lens bend)")
                from: 0; to: 2.2; value: 1.15
            }
            GlassParamRow {
                id: chromaSlider
                label: qsTr("Chromatic aberration")
                from: 0; to: 1; value: 0.25
            }
            GlassParamRow {
                id: blurSlider
                label: qsTr("Frost / blur")
                from: 0; to: 1; value: 0.18
            }
            GlassParamRow {
                id: tintSlider
                label: qsTr("Tint opacity")
                from: 0; to: 0.55; value: 0.02
            }
            GlassParamRow {
                id: qualitySlider
                label: qsTr("Quality (0 low / 2 high)")
                from: 0; to: 2; value: 1
            }
            GlassParamRow {
                id: adaptiveSlider
                label: qsTr("Adaptive tint")
                from: 0; to: 1; value: 0.25
            }
            GlassParamRow {
                id: deformSlider
                label: qsTr("Liquid deform")
                from: 0; to: 1.5; value: 1
            }
            GlassParamRow {
                id: squircleSlider
                label: qsTr("Squircle N")
                from: 2.5; to: 8; value: 5
            }
            GlassParamRow {
                id: edgeSlider
                label: qsTr("Edge / rim")
                from: 0; to: 1; value: 1.0
            }
            GlassParamRow {
                id: radiusSlider
                label: qsTr("Corner radius")
                from: 8; to: 48; value: 28
            }
            GlassParamRow {
                id: elevSlider
                label: qsTr("Elevation")
                from: 0; to: 5; value: 2
            }

            Column {
                Layout.fillWidth: true
                width: root.width
                Md3ListTile { title: "One line"; leadingIcon: "person"; trailingIcon: "chevron_right"; showDivider: true }
                Md3ListTile { title: "Two line"; subtitle: "Supporting"; leadingIcon: "settings"; showDivider: true }
                Md3ListTile { title: "Three line"; subtitle: "Subtitle"; supportingText: "Extra supporting text."; leadingIcon: "info" }
                Md3ListTile {
                    title: qsTr("Alex Chen")
                    subtitle: qsTr("Design lead")
                    leadingAvatar: "AC"
                    trailingIcon: "chevron_right"
                    showDivider: true
                }
                Md3ListTile {
                    title: qsTr("Dark theme")
                    leadingIcon: "dark_mode"
                    showDivider: true
                    trailing: Md3Switch { checked: Md3Theme.dark }
                }
            }
            Md3Button { text: "Open dialog"; onClicked: dlg.open = true }
            Md3Button { text: "Open bottom sheet"; variant: Md3Button.Outlined; onClicked: sheet.open = true }
            Md3Button { text: qsTr("Open side sheet"); variant: Md3Button.FilledTonal; onClicked: sideSheet.open = true }
            Md3Button {
                text: "Open dialog window"
                variant: Md3Button.FilledTonal
                onClicked: winDlg.openDialog(Window.window)
            }
            Md3Button {
                text: "Open modeless window"
                variant: Md3Button.Outlined
                onClicked: modelessDlg.openDialog(Window.window)
            }
            Text {
                Layout.fillWidth: true
                text: "Dialog window = separate OS window (like QWidget::QDialog). Pin button keeps it always-on-top."
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodySmall.size
                wrapMode: Text.Wrap
            }
        }
    }

    Md3Dialog {
        id: dlg
        anchors.fill: parent
        title: "Dialog"
        text: "This is a Material 3 dialog."
        Md3Checkbox { text: qsTr("Don't show again") }
    }
    Md3BottomSheet {
        id: sheet
        anchors.fill: parent
        title: qsTr("Options")
        text: qsTr("Bottom sheet content")
        confirmText: qsTr("Done")
    }

    Md3SideSheet {
        id: sideSheet
        anchors.fill: parent
        title: qsTr("Side sheet")
        text: qsTr("Use side sheets for secondary detail without leaving the page.")
        edge: Md3SideSheet.End
        Md3Button {
            text: qsTr("Done")
            onClicked: sideSheet.dismiss()
        }
    }

    Md3DialogWindow {
        id: winDlg
        title: "Settings dialog"
        width: 520
        height: 380
        dialogText: "Separate top-level window with custom chrome, pin (always-on-top), and standard actions."
        windowIcon: Md3AppIcons.window
        onConfirmed: console.log("dialog window accepted")
        onDismissed: console.log("dialog window dismissed")

        Column {
            anchors.fill: parent
            spacing: 12
            Md3TextField {
                width: parent.width
                label: "Display name"
                text: "QML MD3"
            }
            Md3Switch {
                id: notifySwitch
                text: qsTr("Enable notifications")
                checked: true
            }
            Md3Slider {
                width: parent.width
                label: qsTr("Volume")
                showValue: true
                from: 0
                to: 100
                value: 42
            }
        }
    }

    Md3DialogWindow {
        id: modelessDlg
        title: "Inspector"
        width: 420
        height: 300
        dialogModality: Qt.NonModal
        showStandardButtons: false
        showMinimizeButton: true
        showMaximizeButton: true
        showPinButton: true
        dialogText: "Modeless secondary window — can stay open beside the main app."

        Text {
            anchors.fill: parent
            text: "Drag, resize, pin, or maximize like a normal tool window."
            color: Md3Theme.colorScheme.colorOnSurface
            wrapMode: Text.Wrap
            font.pixelSize: Md3Theme.typography.bodyMedium.size
        }
    }
}

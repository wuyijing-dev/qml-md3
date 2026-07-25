import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true

    // Resolve Md3ApplicationWindow (Window.window custom props can be fragile)
    readonly property var appWin: {
        let p = parent
        while (p) {
            if (p.systemBackdrop !== undefined && typeof p.flashTaskbar === "function")
                return p
            p = p.parent
        }
        const w = Window.window
        if (w && w.systemBackdrop !== undefined)
            return w
        return null
    }

    Md3WindowHelper { id: nativeHelper }
    property int _monitorIndex: 0

    function applyBackdrop(mode) {
        if (root.appWin && typeof root.appWin.setSystemBackdropMode === "function")
            root.appWin.setSystemBackdropMode(mode)
        else if (root.appWin) {
            root.appWin.systemBackdrop = mode
            nativeHelper.setSystemBackdrop(root.appWin, mode)
        }
    }

    function applyBorder(c) {
        if (root.appWin && typeof root.appWin.setNativeBorderColor === "function")
            root.appWin.setNativeBorderColor(c)
        else if (root.appWin) {
            const hex = root.appWin.toCssColor ? root.appWin.toCssColor(c) : String(c)
            root.appWin.nativeBorderColor = hex
            nativeHelper.setBorderColor(root.appWin, hex.length ? hex : "default")
        }
    }

    ColumnLayout {
        id: column
        width: root.width
        spacing: 16

        Text {
            text: qsTr("Application window")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Mica blurs the desktop wallpaper behind the window — use a colorful wallpaper and drag the window over busy areas to see it. Tint≈0 = almost pure material; raise Tint only if text is hard to read. Classic Win7 borders are suppressed via DWM.")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            text: qsTr("Page transition")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }
        Md3ButtonGroup {
            Layout.fillWidth: true
            layout: Md3ButtonGroup.Connected
            variant: Md3ButtonGroup.Outlined
            buttonHeight: 32
            fontSize: 11
            model: [
                { text: "Through" },
                { text: "Fade" },
                { text: "Slide" },
                { text: "Up" },
                { text: "Scale" },
                { text: "None" }
            ]
            onClicked: function (index) {
                if (!root.appWin)
                    return
                const modes = ["fadeThrough", "fade", "slide", "slideUp", "scale", "none"]
                root.appWin.pageTransition = modes[index]
            }
        }
        Row {
            spacing: 12
            Md3Switch {
                id: skeletonSwitch
                checked: root.appWin ? root.appWin.pageSkeleton : true
                accessibleName: qsTr("Page skeleton while loading")
                onToggled: function (on) {
                    if (root.appWin)
                        root.appWin.pageSkeleton = on
                }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Skeleton while loading")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: 12
            }
        }

        RowLayout {
            visible: Md3WindowCapabilities.isWindows && root.appWin
            Layout.fillWidth: true
            spacing: 12
            Text {
                text: qsTr("Tint")
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
            }
            Md3Slider {
                Layout.fillWidth: true
                from: 0
                to: 0.85
                value: root.appWin ? root.appWin.backdropTint : 0.08
                onMoved: {
                    if (root.appWin) {
                        root.appWin.backdropTint = value
                        root.appWin.backdropContentTint = Math.min(0.9, value + 0.1)
                        root.appWin.backdropTitleTint = Math.max(0, value * 0.6)
                    }
                }
            }
            Text {
                text: root.appWin ? root.appWin.backdropTint.toFixed(2) : "-"
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: 12
            }
        }

        Text {
            visible: Md3WindowCapabilities.isWindows
            text: qsTr("Windows native (live)")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Text {
            visible: Md3WindowCapabilities.isWindows
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: root.appWin
                  ? qsTr("Bound window OK — backdrop=%1 border=\"%2\"")
                        .arg(root.appWin.systemBackdrop)
                        .arg(root.appWin.nativeBorderColor)
                  : qsTr("Window not bound — controls disabled")
            color: root.appWin ? Md3Theme.colorScheme.primary : Md3Theme.colorScheme.error
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            visible: Md3WindowCapabilities.isWindows && root.appWin

            Md3Switch {
                checked: root.appWin.syncImmersiveDarkMode
                onToggled: function (isOn) {
                    root.appWin.syncImmersiveDarkMode = isOn
                }
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("syncImmersiveDarkMode (theme=%1)")
                      .arg(Md3Theme.dark ? "dark" : "light")
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyMedium.size
            }
        }

        Text {
            visible: Md3WindowCapabilities.isWindows
            text: qsTr("System backdrop (Win11)")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        Md3ButtonGroup {
            visible: Md3WindowCapabilities.isWindows
            Layout.fillWidth: true
            layout: Md3ButtonGroup.Connected
            variant: Md3ButtonGroup.Outlined
            buttonHeight: 36
            currentIndex: root.appWin ? Math.max(0, Math.min(4, root.appWin.systemBackdrop)) : 0
            model: [
                { text: "None" },
                { text: "Auto" },
                { text: "Mica" },
                { text: "Acrylic" },
                { text: "Tabbed" }
            ]
            onClicked: function (index) { root.applyBackdrop(index) }
        }

        Text {
            visible: Md3WindowCapabilities.isWindows
            text: qsTr("DWM border color")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        Flow {
            visible: Md3WindowCapabilities.isWindows
            Layout.fillWidth: true
            spacing: 8

            Repeater {
                model: [
                    { label: qsTr("Default"), color: "" },
                    { label: qsTr("None"), color: "none" },
                    { label: qsTr("Primary"), color: "primary" },
                    { label: qsTr("Error"), color: "error" },
                    { label: qsTr("Outline"), color: "outline" }
                ]
                delegate: Md3Button {
                    required property var modelData
                    text: modelData.label
                    variant: Md3Button.Outlined
                    onClicked: {
                        let c = modelData.color
                        if (c === "primary")
                            c = Md3Theme.colorScheme.primary
                        else if (c === "error")
                            c = Md3Theme.colorScheme.error
                        else if (c === "outline")
                            c = Md3Theme.colorScheme.outline
                        root.applyBorder(c)
                    }
                }
            }
        }

        Flow {
            visible: Md3WindowCapabilities.isWindows
            Layout.fillWidth: true
            spacing: 8

            Md3Button {
                text: qsTr("Flash taskbar")
                onClicked: {
                    if (root.appWin && typeof root.appWin.flashTaskbar === "function")
                        root.appWin.flashTaskbar(true)
                    else if (root.appWin)
                        nativeHelper.flashTaskbar(root.appWin, true)
                }
            }
            Md3Button {
                text: qsTr("Stop flash")
                variant: Md3Button.Outlined
                onClicked: {
                    if (root.appWin && typeof root.appWin.flashTaskbar === "function")
                        root.appWin.flashTaskbar(false)
                    else if (root.appWin)
                        nativeHelper.flashTaskbar(root.appWin, false)
                }
            }
            Md3Button {
                text: qsTr("System menu…")
                variant: Md3Button.Outlined
                onClicked: {
                    if (!root.appWin)
                        return
                    const g = mapToGlobal(width / 2, height)
                    if (root.appWin.titleBarItem
                            && typeof root.appWin.titleBarItem.openSystemMenu === "function")
                        root.appWin.titleBarItem.openSystemMenu(g.x, g.y)
                    else if (root.appWin.windowNative) {
                        root.appWin.windowNative.showSystemMenu(root.appWin, g.x, g.y)
                    } else {
                        nativeHelper.bindWindow(root.appWin)
                        nativeHelper.showSystemMenu(root.appWin, g.x, g.y)
                    }
                }
            }
        }

        Text {
            visible: Md3WindowCapabilities.taskbarProgress
            text: qsTr("Taskbar progress / overlay")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        RowLayout {
            visible: Md3WindowCapabilities.taskbarProgress && root.appWin
            Layout.fillWidth: true
            spacing: 12
            Text {
                text: qsTr("Progress")
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
            }
            Md3Slider {
                id: taskbarProgressSlider
                Layout.fillWidth: true
                from: 0
                to: 1
                value: 0.35
                onMoved: {
                    if (root.appWin)
                        root.appWin.setTaskbarProgress(value, Md3WindowHelper.ProgressNormal)
                }
            }
            Text {
                text: Math.round(taskbarProgressSlider.value * 100) + "%"
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: 12
            }
        }

        Flow {
            visible: Md3WindowCapabilities.taskbarProgress
            Layout.fillWidth: true
            spacing: 8

            Md3Button {
                text: qsTr("Indeterminate")
                variant: Md3Button.Outlined
                onClicked: {
                    if (root.appWin)
                        root.appWin.setTaskbarProgress(0, Md3WindowHelper.ProgressIndeterminate)
                }
            }
            Md3Button {
                text: qsTr("Error")
                variant: Md3Button.Outlined
                onClicked: {
                    if (root.appWin)
                        root.appWin.setTaskbarProgress(taskbarProgressSlider.value,
                                                       Md3WindowHelper.ProgressError)
                }
            }
            Md3Button {
                text: qsTr("Paused")
                variant: Md3Button.Outlined
                onClicked: {
                    if (root.appWin)
                        root.appWin.setTaskbarProgress(taskbarProgressSlider.value,
                                                       Md3WindowHelper.ProgressPaused)
                }
            }
            Md3Button {
                text: qsTr("Clear progress")
                variant: Md3Button.Text
                onClicked: {
                    if (root.appWin)
                        root.appWin.clearTaskbarProgress()
                }
            }
            Md3Button {
                text: qsTr("Overlay badge")
                onClicked: {
                    if (root.appWin)
                        root.appWin.setTaskbarOverlayIcon("qrc:/md3/icons/app-icon-16.png",
                                                          qsTr("Notification"))
                }
            }
            Md3Button {
                text: qsTr("Clear overlay")
                variant: Md3Button.Outlined
                onClicked: {
                    if (root.appWin)
                        root.appWin.clearTaskbarOverlayIcon()
                }
            }
        }

        Text {
            visible: Md3WindowCapabilities.peekControl || Md3WindowCapabilities.excludeFromCapture
            text: qsTr("Peek / capture")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        ColumnLayout {
            visible: (Md3WindowCapabilities.peekControl
                      || Md3WindowCapabilities.excludeFromCapture) && root.appWin
            Layout.fillWidth: true
            spacing: 8

            RowLayout {
                visible: Md3WindowCapabilities.peekControl
                Layout.fillWidth: true
                spacing: 12
                Md3Switch {
                    id: excludePeekSwitch
                    onToggled: function (isOn) {
                        if (root.appWin)
                            root.appWin.setExcludedFromPeek(isOn)
                    }
                }
                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("Exclude from Aero Peek thumbnail")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                }
            }
            RowLayout {
                visible: Md3WindowCapabilities.peekControl
                Layout.fillWidth: true
                spacing: 12
                Md3Switch {
                    onToggled: function (isOn) {
                        if (root.appWin)
                            root.appWin.setDisallowPeek(isOn)
                    }
                }
                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("Disallow peek (live preview)")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                }
            }
            RowLayout {
                visible: Md3WindowCapabilities.excludeFromCapture
                Layout.fillWidth: true
                spacing: 12
                Md3Switch {
                    onToggled: function (isOn) {
                        if (root.appWin)
                            root.appWin.setExcludeFromCapture(isOn)
                    }
                }
                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("Exclude from screen capture (black box in screenshots)")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                }
            }
        }

        Text {
            visible: Md3WindowCapabilities.jumpList || Md3WindowCapabilities.thumbBar
                     || Md3WindowCapabilities.systemTray || Md3WindowCapabilities.iconicThumbnail
            text: qsTr("Shell extras")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        Flow {
            visible: Md3WindowCapabilities.isWindows && root.appWin
            Layout.fillWidth: true
            spacing: 8

            Md3Button {
                visible: Md3WindowCapabilities.jumpList
                text: qsTr("Set Jump List")
                onClicked: {
                    root.appWin.setJumpListTasks([
                        { title: qsTr("Open Gallery"), arguments: "", description: qsTr("Launch Md3 Gallery") },
                        { title: qsTr("Window page"), arguments: "--page=window" },
                        { title: qsTr("Theme page"), arguments: "--page=theme" }
                    ])
                }
            }
            Md3Button {
                visible: Md3WindowCapabilities.jumpList
                text: qsTr("Clear Jump List")
                variant: Md3Button.Outlined
                onClicked: root.appWin.clearJumpList()
            }
            Md3Button {
                visible: Md3WindowCapabilities.thumbBar
                text: qsTr("ThumbBar buttons")
                onClicked: {
                    root.appWin.setThumbBarButtons([
                        { id: 1, icon: "qrc:/md3/icons/app-icon-16.png", tooltip: qsTr("Action A") },
                        { id: 2, icon: "qrc:/md3/icons/app-icon-16.png", tooltip: qsTr("Action B") }
                    ])
                }
            }
            Md3Button {
                visible: Md3WindowCapabilities.thumbBar
                text: qsTr("Clear ThumbBar")
                variant: Md3Button.Outlined
                onClicked: root.appWin.clearThumbBarButtons()
            }
            Md3Button {
                visible: Md3WindowCapabilities.iconicThumbnail
                text: qsTr("Custom iconic thumb")
                onClicked: root.appWin.setIconicThumbnail("qrc:/md3/icons/app-icon-256.png")
            }
            Md3Button {
                visible: Md3WindowCapabilities.iconicThumbnail
                text: qsTr("Clear iconic")
                variant: Md3Button.Outlined
                onClicked: root.appWin.clearIconicThumbnail()
            }
            Md3Button {
                visible: Md3WindowCapabilities.systemTray
                text: qsTr("Show tray icon")
                onClicked: {
                    root.appWin.showSystemTrayIcon("qrc:/md3/icons/app-icon-16.png",
                                                   qsTr("Md3 Gallery"))
                }
            }
            Md3Button {
                visible: Md3WindowCapabilities.systemTray
                text: qsTr("Tray balloon")
                variant: Md3Button.Outlined
                onClicked: root.appWin.showTrayNotification(qsTr("Md3 Gallery"),
                                                            qsTr("Native tray notification"), 4000)
            }
            Md3Button {
                visible: Md3WindowCapabilities.systemTray
                text: qsTr("Hide tray")
                variant: Md3Button.Text
                onClicked: root.appWin.hideSystemTrayIcon()
            }
            Md3Button {
                visible: Md3WindowCapabilities.alwaysOnTop
                text: qsTr("Always on top")
                onClicked: root.appWin.setAlwaysOnTop(true)
            }
            Md3Button {
                visible: Md3WindowCapabilities.alwaysOnTop
                text: qsTr("Clear topmost")
                variant: Md3Button.Outlined
                onClicked: root.appWin.setAlwaysOnTop(false)
            }
            Md3Button {
                visible: Md3WindowCapabilities.thumbnailClip
                text: qsTr("Thumb clip (title)")
                onClicked: root.appWin.setThumbnailClip(0, 0, root.appWin.width, 40)
            }
            Md3Button {
                visible: Md3WindowCapabilities.thumbnailClip
                text: qsTr("Clear thumb clip")
                variant: Md3Button.Outlined
                onClicked: {
                    root.appWin.clearThumbnailClip()
                    root.appWin.setThumbnailTooltip("")
                }
            }
            Md3Button {
                visible: Md3WindowCapabilities.thumbnailClip
                text: qsTr("Thumb tooltip")
                variant: Md3Button.Outlined
                onClicked: root.appWin.setThumbnailTooltip(qsTr("Md3 Gallery preview"))
            }
            Md3Button {
                text: qsTr("Next monitor")
                variant: Md3Button.Outlined
                onClicked: {
                    const n = root.appWin.monitorCount
                    if (n <= 1)
                        return
                    root._monitorIndex = (root._monitorIndex + 1) % n
                    root.appWin.moveToMonitor(root._monitorIndex)
                }
            }
            Md3Button {
                visible: Md3WindowCapabilities.preferredAppMode
                text: qsTr("App mode dark")
                onClicked: root.appWin.setPreferredAppMode(true)
            }
            Md3Button {
                visible: Md3WindowCapabilities.preferredAppMode
                text: qsTr("App mode light")
                variant: Md3Button.Outlined
                onClicked: root.appWin.setPreferredAppMode(false)
            }
            Md3Button {
                visible: Md3WindowCapabilities.applicationRestart
                text: qsTr("Register restart")
                variant: Md3Button.Outlined
                onClicked: root.appWin.registerApplicationRestart("")
            }
            Md3Button {
                visible: Md3WindowCapabilities.applicationRestart
                text: qsTr("Unregister restart")
                variant: Md3Button.Text
                onClicked: root.appWin.unregisterApplicationRestart()
            }
        }

        Text {
            visible: Md3WindowCapabilities.isWindows
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Last shell event: %1").arg(shellEventLabel.text)
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
        }
        Text {
            id: shellEventLabel
            visible: false
            text: "-"
        }

        Connections {
            target: root.appWin && root.appWin.windowNative ? root.appWin.windowNative : nativeHelper
            function onThumbBarButtonClicked(buttonId) {
                shellEventLabel.text = qsTr("ThumbBar #%1").arg(buttonId)
            }
            function onTrayActivated(reason) {
                shellEventLabel.text = qsTr("Tray reason=%1").arg(reason)
            }
            function onDpiChanged(dpr, dpi) {
                shellEventLabel.text = qsTr("DPI dpr=%1 dpi=%2").arg(dpr).arg(dpi)
            }
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: {
                const dpr = root.appWin ? root.appWin.windowDpr : nativeHelper.devicePixelRatio(Window.window)
                const dpi = root.appWin ? root.appWin.windowDpi : nativeHelper.windowDpi(Window.window)
                return "platform=" + Md3WindowCapabilities.platformId
                      + "  dpr=" + Number(dpr).toFixed(2)
                      + "  dpi=" + dpi
                      + "  perMonitorV2=" + Md3WindowCapabilities.perMonitorDpiV2
                      + "  taskbar=" + nativeHelper.taskbarProgressSupported
                      + "  jumpList=" + nativeHelper.jumpListSupported
                      + "  tray=" + nativeHelper.systemTraySupported
            }
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
        }
    }
}

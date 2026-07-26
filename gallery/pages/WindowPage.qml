import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true

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

    readonly property bool isWin: Md3WindowCapabilities.isWindows
    readonly property bool isLinux: Md3WindowCapabilities.isLinux
    readonly property bool isMac: Md3WindowCapabilities.isMacOS

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
            text: {
                if (root.isWin)
                    return qsTr("Windows: Mica/Acrylic backdrop, DWM chrome, taskbar, tray, and Jump List. Tint≈0 keeps the material soft.")
                if (root.isLinux)
                    return qsTr("Linux / Wayland: client-side decoration, soft translucent backdrop + compositor blur hints, dock progress (Plasma), StatusNotifier tray, FreeDesktop notifications, accent from gsettings/KDE. Taskbar icon needs a matching .desktop (app_id).")
                if (root.isMac)
                    return qsTr("macOS: traffic-lights inset, soft translucent backdrop hook, system color scheme.")
                return qsTr("Platform window chrome and shell affordances for the current OS.")
            }
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Document tabs: documentTabsEnabled — Explorer-style strip with + / tear-off. Managed API: openTab / addTab / closeTab.")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            text: qsTr("Graphics (RHI)")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Platform=%1 · current=%2 · preferred=%3%4\nCLI: --rhi-backend=… · env MD3_RHI_BACKEND")
                  .arg(Md3Graphics.platformName)
                  .arg(Md3Graphics.currentBackend)
                  .arg(Md3Graphics.preferredBackend)
                  .arg(Md3Graphics.restartRequired ? qsTr(" · restart required") : "")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }

        Flow {
            Layout.fillWidth: true
            spacing: 8
            Repeater {
                model: Md3Graphics.availableBackends
                Md3FilterChip {
                    text: modelData
                    selected: Md3Graphics.preferredBackend === modelData
                    onClicked: Md3Graphics.setBackend(modelData)
                }
            }
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
            visible: root.isWin && root.appWin
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
            visible: Md3WindowCapabilities.systemBackdrop || Md3WindowCapabilities.immersiveDarkMode
            text: qsTr("Native window")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Text {
            visible: Md3WindowCapabilities.systemBackdrop || Md3WindowCapabilities.immersiveDarkMode
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: root.appWin
                  ? qsTr("Bound — platform=%1 · wayland=%2 · backdrop=%3")
                        .arg(Md3WindowCapabilities.platformId)
                        .arg(nativeHelper.wayland ? "yes" : "no")
                        .arg(root.appWin.systemBackdrop)
                  : qsTr("Window not bound — controls disabled")
            color: root.appWin ? Md3Theme.colorScheme.primary : Md3Theme.colorScheme.error
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            visible: Md3WindowCapabilities.immersiveDarkMode && root.appWin
            Md3Switch {
                checked: root.appWin.syncImmersiveDarkMode
                onToggled: function (isOn) {
                    root.appWin.syncImmersiveDarkMode = isOn
                }
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Sync color scheme with theme (%1)")
                      .arg(Md3Theme.dark ? "dark" : "light")
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyMedium.size
            }
        }

        // --- Backdrop: Win11 materials vs Linux soft on/off ---
        Text {
            visible: Md3WindowCapabilities.systemBackdrop && root.isWin
            text: qsTr("System backdrop (DWM)")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Md3ButtonGroup {
            visible: Md3WindowCapabilities.systemBackdrop && root.isWin
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
            visible: Md3WindowCapabilities.systemBackdrop && !root.isWin
            text: qsTr("Soft backdrop")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Md3ButtonGroup {
            visible: Md3WindowCapabilities.systemBackdrop && !root.isWin
            Layout.fillWidth: true
            layout: Md3ButtonGroup.Connected
            variant: Md3ButtonGroup.Outlined
            buttonHeight: 36
            currentIndex: root.appWin && root.appWin.systemBackdrop > 0 ? 1 : 0
            model: [
                { text: qsTr("Off") },
                { text: qsTr("On (blur hint)") }
            ]
            onClicked: function (index) { root.applyBackdrop(index === 0 ? 0 : 1) }
        }

        Text {
            visible: root.isWin
            text: qsTr("DWM border color")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Flow {
            visible: root.isWin
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

        Text {
            visible: root.appWin
            text: qsTr("Window actions")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Flow {
            visible: root.appWin
            Layout.fillWidth: true
            spacing: 8

            Md3Button {
                text: root.isWin ? qsTr("Flash taskbar") : qsTr("Request attention")
                onClicked: root.appWin.flashTaskbar(true)
            }
            Md3Button {
                text: qsTr("Stop")
                variant: Md3Button.Outlined
                onClicked: root.appWin.flashTaskbar(false)
            }
            Md3Button {
                visible: Md3WindowCapabilities.systemMenu
                text: qsTr("System menu…")
                variant: Md3Button.Outlined
                onClicked: {
                    const g = mapToGlobal(width / 2, height)
                    if (root.appWin.titleBarItem
                            && typeof root.appWin.titleBarItem.openSystemMenu === "function")
                        root.appWin.titleBarItem.openSystemMenu(g.x, g.y)
                    else
                        nativeHelper.showSystemMenu(root.appWin, g.x, g.y)
                }
            }
            Md3Button {
                text: qsTr("Raise / activate")
                variant: Md3Button.Outlined
                onClicked: root.appWin.raiseWindow()
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
                text: qsTr("Prefer dark")
                onClicked: root.appWin.setPreferredAppMode(true)
            }
            Md3Button {
                visible: Md3WindowCapabilities.preferredAppMode
                text: qsTr("Prefer light")
                variant: Md3Button.Outlined
                onClicked: root.appWin.setPreferredAppMode(false)
            }
            Md3Button {
                visible: root.isLinux
                text: qsTr("Idle inhibit")
                variant: Md3Button.Outlined
                onClicked: root.appWin.setIdleInhibit(true, qsTr("Md3 Gallery demo"))
            }
            Md3Button {
                visible: root.isLinux
                text: qsTr("Allow idle")
                variant: Md3Button.Text
                onClicked: root.appWin.setIdleInhibit(false)
            }
        }

        Text {
            visible: Md3WindowCapabilities.taskbarProgress
            text: root.isWin ? qsTr("Taskbar progress") : qsTr("Dock progress")
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
            visible: Md3WindowCapabilities.taskbarProgress && root.appWin
            Layout.fillWidth: true
            spacing: 8
            Md3Button {
                text: qsTr("Indeterminate")
                variant: Md3Button.Outlined
                onClicked: root.appWin.setTaskbarProgress(0, Md3WindowHelper.ProgressIndeterminate)
            }
            Md3Button {
                text: qsTr("Error")
                variant: Md3Button.Outlined
                onClicked: root.appWin.setTaskbarProgress(taskbarProgressSlider.value,
                                                          Md3WindowHelper.ProgressError)
            }
            Md3Button {
                text: qsTr("Paused")
                variant: Md3Button.Outlined
                onClicked: root.appWin.setTaskbarProgress(taskbarProgressSlider.value,
                                                          Md3WindowHelper.ProgressPaused)
            }
            Md3Button {
                text: qsTr("Clear")
                variant: Md3Button.Text
                onClicked: root.appWin.clearTaskbarProgress()
            }
            Md3Button {
                visible: Md3WindowCapabilities.taskbarOverlay
                text: qsTr("Overlay icon")
                onClicked: root.appWin.setTaskbarOverlayIcon("qrc:/md3/icons/app-icon-16.png",
                                                             qsTr("Notification"))
            }
            Md3Button {
                visible: Md3WindowCapabilities.taskbarOverlay
                text: qsTr("Clear overlay")
                variant: Md3Button.Outlined
                onClicked: root.appWin.clearTaskbarOverlayIcon()
            }
            Md3Button {
                visible: root.isLinux || root.isWin || root.isMac
                text: qsTr("Dock badge 3")
                onClicked: root.appWin.setDockBadge(3)
            }
            Md3Button {
                visible: root.isLinux || root.isWin || root.isMac
                text: qsTr("Clear badge")
                variant: Md3Button.Outlined
                onClicked: root.appWin.setDockBadge(0)
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
                    text: qsTr("Exclude from screen capture")
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                }
            }
        }

        Text {
            visible: Md3WindowCapabilities.jumpList || Md3WindowCapabilities.thumbBar
                     || Md3WindowCapabilities.systemTray || Md3WindowCapabilities.iconicThumbnail
                     || Md3WindowCapabilities.thumbnailClip || Md3WindowCapabilities.applicationRestart
            text: qsTr("Shell extras")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Flow {
            visible: root.appWin && (Md3WindowCapabilities.jumpList || Md3WindowCapabilities.thumbBar
                     || Md3WindowCapabilities.systemTray || Md3WindowCapabilities.iconicThumbnail
                     || Md3WindowCapabilities.thumbnailClip || Md3WindowCapabilities.applicationRestart)
            Layout.fillWidth: true
            spacing: 8

            Md3Button {
                visible: Md3WindowCapabilities.jumpList
                text: qsTr("Set Jump List")
                onClicked: {
                    root.appWin.setJumpListTasks([
                        { title: qsTr("Open Gallery"), arguments: "", description: qsTr("Launch Md3 Gallery") },
                        { title: qsTr("Window page"), arguments: "--page=window" }
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
                onClicked: root.appWin.showSystemTrayIcon("qrc:/md3/icons/app-icon-16.png",
                                                          qsTr("Md3 Gallery"))
            }
            Md3Button {
                visible: Md3WindowCapabilities.systemTray
                text: qsTr("Notify")
                variant: Md3Button.Outlined
                onClicked: root.appWin.showTrayNotification(qsTr("Md3 Gallery"),
                                                            qsTr("Desktop notification"), 4000)
            }
            Md3Button {
                visible: Md3WindowCapabilities.systemTray
                text: qsTr("Hide tray")
                variant: Md3Button.Text
                onClicked: root.appWin.hideSystemTrayIcon()
            }
            Md3Button {
                visible: Md3WindowCapabilities.thumbnailClip
                text: qsTr("Thumb clip")
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
            visible: Md3WindowCapabilities.systemTray || Md3WindowCapabilities.thumbBar
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
                const accent = Md3WindowCapabilities.systemAccent
                        ? nativeHelper.systemAccentColor() : "-"
                return "platform=" + Md3WindowCapabilities.platformId
                      + "  wayland=" + (nativeHelper.wayland ? "1" : "0")
                      + "  dpr=" + Number(dpr).toFixed(2)
                      + "  dpi=" + dpi
                      + "  accent=" + accent
                      + "  dockProgress=" + Md3WindowCapabilities.taskbarProgress
                      + "  tray=" + Md3WindowCapabilities.systemTray
            }
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
        }
    }
}

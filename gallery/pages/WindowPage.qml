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

    readonly property int currentOsTab: {
        if (Md3WindowCapabilities.isWindows)
            return 0
        if (Md3WindowCapabilities.isLinux)
            return 1
        if (Md3WindowCapabilities.isMacOS)
            return 2
        return 0
    }

    property int platformTab: currentOsTab

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
            text: qsTr("Shared settings below; open the tab for your OS (or another) to try native shell controls. Running as %1%2.")
                  .arg(Md3WindowCapabilities.platformId)
                  .arg(nativeHelper.wayland ? " · Wayland" : (nativeHelper.xcb ? " · X11" : ""))
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        // —— Shared ——
        Text {
            text: qsTr("Shared")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Document tabs: documentTabsEnabled — strip with + / tear-off. API: openTab / addTab / closeTab.")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            text: qsTr("Graphics (RHI)")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("%1 · current=%2 · preferred=%3%4")
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
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
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

        // —— Per-OS tabs ——
        Text {
            text: qsTr("Platform native")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Md3TabBar {
            Layout.fillWidth: true
            currentIndex: root.platformTab
            model: [
                { text: qsTr("Windows") },
                { text: qsTr("Linux") },
                { text: qsTr("macOS") }
            ]
            onCurrentIndexChangedByUser: function (index) {
                root.platformTab = index
            }
        }

        Text {
            visible: root.platformTab !== root.currentOsTab
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Browsing another OS tab — live actions only work on this machine (%1).")
                  .arg(Md3WindowCapabilities.platformId)
            color: Md3Theme.colorScheme.tertiary
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }

        StackLayout {
            Layout.fillWidth: true
            currentIndex: root.platformTab

            // ===== Windows =====
            ColumnLayout {
                spacing: 12

                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("Win10/11 client chrome: Mica/Acrylic, DWM border, taskbar progress/overlay, Jump List, ThumbBar, tray, peek/capture.")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                    font.family: Md3Theme.typography.fontFamily
                }

                Text {
                    visible: root.appWin && Md3WindowCapabilities.isWindows
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("Bound — backdrop=%1 border=\"%2\"")
                          .arg(root.appWin ? root.appWin.systemBackdrop : -1)
                          .arg(root.appWin ? root.appWin.nativeBorderColor : "")
                    color: Md3Theme.colorScheme.primary
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }

                RowLayout {
                    visible: Md3WindowCapabilities.isWindows && root.appWin
                    Layout.fillWidth: true
                    spacing: 12
                    Md3Switch {
                        checked: root.appWin.syncImmersiveDarkMode
                        onToggled: function (isOn) { root.appWin.syncImmersiveDarkMode = isOn }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("syncImmersiveDarkMode")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                    }
                }

                RowLayout {
                    visible: Md3WindowCapabilities.isWindows && root.appWin
                    Layout.fillWidth: true
                    spacing: 12
                    Text { text: qsTr("Tint"); color: Md3Theme.colorScheme.colorOnSurface }
                    Md3Slider {
                        Layout.fillWidth: true
                        from: 0; to: 0.85
                        value: root.appWin ? root.appWin.backdropTint : 0.08
                        onMoved: {
                            root.appWin.backdropTint = value
                            root.appWin.backdropContentTint = Math.min(0.9, value + 0.1)
                            root.appWin.backdropTitleTint = Math.max(0, value * 0.6)
                        }
                    }
                }

                Text {
                    text: qsTr("System backdrop")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                Md3ButtonGroup {
                    enabled: Md3WindowCapabilities.isWindows
                    Layout.fillWidth: true
                    layout: Md3ButtonGroup.Connected
                    variant: Md3ButtonGroup.Outlined
                    buttonHeight: 36
                    currentIndex: root.appWin ? Math.max(0, Math.min(4, root.appWin.systemBackdrop)) : 0
                    model: [
                        { text: "None" }, { text: "Auto" }, { text: "Mica" },
                        { text: "Acrylic" }, { text: "Tabbed" }
                    ]
                    onClicked: function (index) { root.applyBackdrop(index) }
                }

                Text {
                    text: qsTr("DWM border")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                Flow {
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
                            enabled: Md3WindowCapabilities.isWindows
                            text: modelData.label
                            variant: Md3Button.Outlined
                            onClicked: {
                                let c = modelData.color
                                if (c === "primary") c = Md3Theme.colorScheme.primary
                                else if (c === "error") c = Md3Theme.colorScheme.error
                                else if (c === "outline") c = Md3Theme.colorScheme.outline
                                root.applyBorder(c)
                            }
                        }
                    }
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Flash taskbar")
                        onClicked: if (root.appWin) root.appWin.flashTaskbar(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Stop flash")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.flashTaskbar(false)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("System menu…")
                        variant: Md3Button.Outlined
                        onClicked: {
                            if (!root.appWin) return
                            const g = mapToGlobal(width / 2, height)
                            if (root.appWin.titleBarItem
                                    && typeof root.appWin.titleBarItem.openSystemMenu === "function")
                                root.appWin.titleBarItem.openSystemMenu(g.x, g.y)
                            else
                                nativeHelper.showSystemMenu(root.appWin, g.x, g.y)
                        }
                    }
                }

                Text {
                    text: qsTr("Taskbar progress / overlay")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    enabled: Md3WindowCapabilities.isWindows
                    Md3Slider {
                        id: winProgress
                        Layout.fillWidth: true
                        from: 0; to: 1; value: 0.35
                        onMoved: if (root.appWin) root.appWin.setTaskbarProgress(value)
                    }
                    Text {
                        text: Math.round(winProgress.value * 100) + "%"
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.pixelSize: 12
                    }
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Indeterminate")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setTaskbarProgress(0, Md3WindowHelper.ProgressIndeterminate)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Error")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setTaskbarProgress(winProgress.value, Md3WindowHelper.ProgressError)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Clear")
                        variant: Md3Button.Text
                        onClicked: if (root.appWin) root.appWin.clearTaskbarProgress()
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Overlay")
                        onClicked: if (root.appWin) root.appWin.setTaskbarOverlayIcon("qrc:/md3/icons/app-icon-16.png", qsTr("Badge"))
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Clear overlay")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.clearTaskbarOverlayIcon()
                    }
                }

                Text {
                    text: qsTr("Peek / capture / shell")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                ColumnLayout {
                    spacing: 8
                    enabled: Md3WindowCapabilities.isWindows
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        Md3Switch {
                            onToggled: function (on) { if (root.appWin) root.appWin.setExcludedFromPeek(on) }
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            text: qsTr("Exclude from Aero Peek")
                            color: Md3Theme.colorScheme.colorOnSurface
                            font.pixelSize: Md3Theme.typography.bodyMedium.size
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        Md3Switch {
                            onToggled: function (on) { if (root.appWin) root.appWin.setDisallowPeek(on) }
                        }
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Disallow peek")
                            color: Md3Theme.colorScheme.colorOnSurface
                            font.pixelSize: Md3Theme.typography.bodyMedium.size
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        Md3Switch {
                            onToggled: function (on) { if (root.appWin) root.appWin.setExcludeFromCapture(on) }
                        }
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Exclude from capture")
                            color: Md3Theme.colorScheme.colorOnSurface
                            font.pixelSize: Md3Theme.typography.bodyMedium.size
                        }
                    }
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Jump List")
                        onClicked: if (root.appWin) root.appWin.setJumpListTasks([
                            { title: qsTr("Gallery"), arguments: "" },
                            { title: qsTr("Window"), arguments: "--page=window" }
                        ])
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("ThumbBar")
                        onClicked: if (root.appWin) root.appWin.setThumbBarButtons([
                            { id: 1, icon: "qrc:/md3/icons/app-icon-16.png", tooltip: "A" },
                            { id: 2, icon: "qrc:/md3/icons/app-icon-16.png", tooltip: "B" }
                        ])
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Tray")
                        onClicked: if (root.appWin) root.appWin.showSystemTrayIcon("qrc:/md3/icons/app-icon-16.png", qsTr("Md3"))
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Balloon")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.showTrayNotification(qsTr("Md3"), qsTr("Tray notify"), 4000)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Always on top")
                        onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("Register restart")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.registerApplicationRestart("")
                    }
                }
            }

            // ===== Linux =====
            ColumnLayout {
                spacing: 12

                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("Wayland/X11: CSD, soft translucent backdrop + blur hints, dock progress (LauncherEntry), SNI tray, FDO notifications, accent (gsettings/KDE), idle inhibit. Taskbar icon needs matching .desktop app_id.")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                    font.family: Md3Theme.typography.fontFamily
                }

                Text {
                    visible: root.appWin && Md3WindowCapabilities.isLinux
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("Bound — wayland=%1 backdrop=%2 accent=%3")
                          .arg(nativeHelper.wayland ? "yes" : "no")
                          .arg(root.appWin ? root.appWin.systemBackdrop : -1)
                          .arg(nativeHelper.systemAccentColor())
                    color: Md3Theme.colorScheme.primary
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }

                RowLayout {
                    visible: Md3WindowCapabilities.isLinux && root.appWin
                    Layout.fillWidth: true
                    spacing: 12
                    Md3Switch {
                        checked: root.appWin.syncImmersiveDarkMode
                        onToggled: function (isOn) { root.appWin.syncImmersiveDarkMode = isOn }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Sync color scheme with theme")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                    }
                }

                Text {
                    text: qsTr("Soft backdrop")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                Md3ButtonGroup {
                    enabled: Md3WindowCapabilities.isLinux
                    Layout.fillWidth: true
                    layout: Md3ButtonGroup.Connected
                    variant: Md3ButtonGroup.Outlined
                    buttonHeight: 36
                    currentIndex: root.appWin && root.appWin.systemBackdrop > 0 ? 1 : 0
                    model: [ { text: qsTr("Off") }, { text: qsTr("On (blur hint)") } ]
                    onClicked: function (index) { root.applyBackdrop(index === 0 ? 0 : 1) }
                }

                Text {
                    text: qsTr("Window actions")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Request attention")
                        onClicked: if (root.appWin) root.appWin.flashTaskbar(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Stop")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.flashTaskbar(false)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("System menu…")
                        variant: Md3Button.Outlined
                        onClicked: {
                            if (!root.appWin) return
                            const g = mapToGlobal(width / 2, height)
                            if (root.appWin.titleBarItem
                                    && typeof root.appWin.titleBarItem.openSystemMenu === "function")
                                root.appWin.titleBarItem.openSystemMenu(g.x, g.y)
                            else
                                nativeHelper.showSystemMenu(root.appWin, g.x, g.y)
                        }
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Raise")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.raiseWindow()
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Always on top")
                        onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Clear topmost")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(false)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Idle inhibit")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setIdleInhibit(true, qsTr("Md3 demo"))
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Allow idle")
                        variant: Md3Button.Text
                        onClicked: if (root.appWin) root.appWin.setIdleInhibit(false)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Prefer dark")
                        onClicked: if (root.appWin) root.appWin.setPreferredAppMode(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Prefer light")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setPreferredAppMode(false)
                    }
                }

                Text {
                    text: qsTr("Dock progress / badge")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    enabled: Md3WindowCapabilities.isLinux
                    Md3Slider {
                        id: linuxProgress
                        Layout.fillWidth: true
                        from: 0; to: 1; value: 0.35
                        onMoved: if (root.appWin) root.appWin.setTaskbarProgress(value)
                    }
                    Text {
                        text: Math.round(linuxProgress.value * 100) + "%"
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.pixelSize: 12
                    }
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Indeterminate")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setTaskbarProgress(0, Md3WindowHelper.ProgressIndeterminate)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Clear progress")
                        variant: Md3Button.Text
                        onClicked: if (root.appWin) root.appWin.clearTaskbarProgress()
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Badge 3")
                        onClicked: if (root.appWin) root.appWin.setDockBadge(3)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Clear badge")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setDockBadge(0)
                    }
                }

                Text {
                    text: qsTr("Tray / notify")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Show tray")
                        onClicked: if (root.appWin) root.appWin.showSystemTrayIcon("qrc:/md3/icons/app-icon-16.png", qsTr("Md3 Gallery"))
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Notify")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.showTrayNotification(qsTr("Md3 Gallery"), qsTr("FreeDesktop notification"), 4000)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Hide tray")
                        variant: Md3Button.Text
                        onClicked: if (root.appWin) root.appWin.hideSystemTrayIcon()
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("Next monitor")
                        variant: Md3Button.Outlined
                        onClicked: {
                            if (!root.appWin) return
                            const n = root.appWin.monitorCount
                            if (n <= 1) return
                            root._monitorIndex = (root._monitorIndex + 1) % n
                            root.appWin.moveToMonitor(root._monitorIndex)
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("Install resources/linux/appQML_MD3.desktop for a proper Wayland taskbar icon (setDesktopFileName).")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                    font.family: Md3Theme.typography.fontFamily
                }
            }

            // ===== macOS =====
            ColumnLayout {
                spacing: 12

                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("macOS: leave traffic-lights inset, soft translucent hook, color scheme / accent. System caption buttons stay native.")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                    font.family: Md3Theme.typography.fontFamily
                }

                Text {
                    visible: root.appWin && Md3WindowCapabilities.isMacOS
                    Layout.fillWidth: true
                    text: qsTr("Bound — trafficLightsInset=%1")
                          .arg(nativeHelper.trafficLightsInset)
                    color: Md3Theme.colorScheme.primary
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }

                RowLayout {
                    visible: Md3WindowCapabilities.isMacOS && root.appWin
                    Layout.fillWidth: true
                    spacing: 12
                    Md3Switch {
                        checked: root.appWin.syncImmersiveDarkMode
                        onToggled: function (isOn) { root.appWin.syncImmersiveDarkMode = isOn }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Sync color scheme with theme")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                    }
                }

                Text {
                    text: qsTr("Soft backdrop")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                Md3ButtonGroup {
                    enabled: Md3WindowCapabilities.isMacOS
                    Layout.fillWidth: true
                    layout: Md3ButtonGroup.Connected
                    variant: Md3ButtonGroup.Outlined
                    buttonHeight: 36
                    currentIndex: root.appWin && root.appWin.systemBackdrop > 0 ? 1 : 0
                    model: [ { text: qsTr("Off") }, { text: qsTr("On") } ]
                    onClicked: function (index) { root.applyBackdrop(index === 0 ? 0 : 1) }
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("Request attention")
                        onClicked: if (root.appWin) root.appWin.flashTaskbar(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("Raise")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.raiseWindow()
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("Always on top")
                        onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("Clear topmost")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(false)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("Dock badge 3")
                        onClicked: if (root.appWin) root.appWin.setDockBadge(3)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("Clear badge")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setDockBadge(0)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("Prefer dark")
                        onClicked: if (root.appWin) root.appWin.setPreferredAppMode(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("Prefer light")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setPreferredAppMode(false)
                    }
                }
            }
        }

        Text {
            id: shellEventLabel
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Shell event: —")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }
        Connections {
            target: root.appWin && root.appWin.windowNative ? root.appWin.windowNative : nativeHelper
            function onThumbBarButtonClicked(buttonId) {
                shellEventLabel.text = qsTr("Shell event: ThumbBar #%1").arg(buttonId)
            }
            function onTrayActivated(reason) {
                shellEventLabel.text = qsTr("Shell event: tray reason=%1").arg(reason)
            }
            function onDpiChanged(dpr, dpi) {
                shellEventLabel.text = qsTr("Shell event: dpr=%1 dpi=%2").arg(dpr).arg(dpi)
            }
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: {
                const dpr = root.appWin ? root.appWin.windowDpr : nativeHelper.devicePixelRatio(Window.window)
                const dpi = root.appWin ? root.appWin.windowDpi : nativeHelper.windowDpi(Window.window)
                return "runtime=" + Md3WindowCapabilities.platformId
                      + "  tab=" + ["windows", "linux", "macos"][root.platformTab]
                      + "  dpr=" + Number(dpr).toFixed(2)
                      + "  dpi=" + dpi
            }
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
        }
    }
}

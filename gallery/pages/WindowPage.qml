import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtCore
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
    Md3ReleaseUpdater {
        id: releaseUpdater
        owner: "wuyijing-dev"
        repo: "QML_MD3"
        currentVersion: "1.0.0"
        assetNameContains: ".zip"
    }
    property int _monitorIndex: 0

    // UNSUITABLE — retained for native code paths; Gallery UI removed.
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
            text: qsTr("应用窗口")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("下方为通用设置；按系统切换标签页查看原生能力。当前运行：%1%2。")
                  .arg(Md3WindowCapabilities.platformId)
                  .arg(nativeHelper.wayland ? " · Wayland" : (nativeHelper.xcb ? " · X11" : ""))
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        // —— Shared ——
        Text {
            text: qsTr("通用")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("文档标签：标题栏下方开启 documentTabsEnabled。支持 + 新建 / 关闭 / 拖拽排序；拖出标签条可撕离为独立 Md3TabWindow（documentTabsTearOff）。")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            text: qsTr("图形后端（RHI）")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("%1 · 当前=%2 · 首选=%3%4")
                  .arg(Md3Graphics.platformName)
                  .arg(Md3Graphics.currentBackend)
                  .arg(Md3Graphics.preferredBackend)
                  .arg(Md3Graphics.restartRequired ? qsTr(" · 需重启生效") : "")
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
            text: qsTr("页面转场")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Md3ButtonGroup {
            Layout.fillWidth: true
            layout: Md3ButtonGroup.Connected
            variant: Md3ButtonGroup.Outlined
            buttonHeight: 32
            fontSize: 11
            currentIndex: {
                if (!root.appWin)
                    return 0
                const modes = ["fade", "fadeThrough", "slide", "slideUp", "scale", "none"]
                const i = modes.indexOf(root.appWin.pageTransition)
                return i >= 0 ? i : 0
            }
            model: [
                { text: qsTr("淡入淡出") },
                { text: qsTr("贯穿") },
                { text: qsTr("滑动") },
                { text: qsTr("上滑") },
                { text: qsTr("缩放") },
                { text: qsTr("无") }
            ]
            onClicked: function (index) {
                if (!root.appWin)
                    return
                const modes = ["fade", "fadeThrough", "slide", "slideUp", "scale", "none"]
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
                text: qsTr("加载时显示骨架屏")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: 12
            }
        }

        Text {
            text: qsTr("Release 更新")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Row {
            spacing: 12
            Md3Button {
                text: releaseUpdater.checking ? qsTr("Checking…") : qsTr("Check GitHub Release")
                variant: Md3Button.Outlined
                enabled: !releaseUpdater.checking
                onClicked: releaseUpdater.check()
            }
            Md3Button {
                text: qsTr("Open Download")
                variant: Md3Button.Text
                enabled: releaseUpdater.downloadUrl.length > 0
                onClicked: Qt.openUrlExternally(releaseUpdater.downloadUrl)
            }
            Md3Button {
                text: releaseUpdater.downloading ? qsTr("Downloading…") : qsTr("Download ZIP")
                variant: Md3Button.Text
                enabled: !releaseUpdater.downloading && releaseUpdater.downloadUrl.length > 0
                onClicked: releaseUpdater.downloadTo(StandardPaths.writableLocation(StandardPaths.DownloadLocation))
            }
        }
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: releaseUpdater.errorString.length
                  ? releaseUpdater.errorString
                  : (releaseUpdater.latestVersion.length
                     ? qsTr("Current %1 · Latest %2 · %3")
                           .arg(releaseUpdater.currentVersion)
                           .arg(releaseUpdater.latestVersion)
                           .arg(releaseUpdater.hasUpdate ? qsTr("Update available") : qsTr("Up to date"))
                     : qsTr("Checks GitHub Release metadata and exposes a ZIP download URL."))
            color: releaseUpdater.errorString.length
                   ? Md3Theme.colorScheme.error
                   : Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }
        Text {
            visible: releaseUpdater.downloading || releaseUpdater.downloadedFilePath.length > 0
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: releaseUpdater.downloading
                  ? qsTr("Download %1%").arg(Math.round(releaseUpdater.downloadProgress * 100))
                  : qsTr("Downloaded: %1").arg(releaseUpdater.downloadedFilePath)
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }

        // —— Per-OS tabs ——
        Text {
            text: qsTr("平台原生")
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
            text: qsTr("正在浏览其他系统标签；可操作控件仅对本机（%1）生效。")
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
                    text: qsTr("Windows 10/11 客户区：DWM 边框、任务栏进度与角标、跳转列表、缩略图工具栏、托盘、Peek/捕获。（系统背景材质已标记为不适合使用，Gallery 不再展示。）")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                    font.family: Md3Theme.typography.fontFamily
                }

                Text {
                    visible: root.appWin && Md3WindowCapabilities.isWindows
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("已绑定 — 边框=\"%1\"")
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
                        text: qsTr("与主题同步沉浸式深色")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                    }
                }

                Text {
                    text: qsTr("DWM 边框颜色")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Repeater {
                        model: [
                            { label: qsTr("默认"), color: "" },
                            { label: qsTr("无"), color: "none" },
                            { label: qsTr("主色"), color: "primary" },
                            { label: qsTr("错误色"), color: "error" },
                            { label: qsTr("轮廓色"), color: "outline" }
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
                        text: qsTr("闪烁任务栏")
                        onClicked: if (root.appWin) root.appWin.flashTaskbar(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("停止闪烁")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.flashTaskbar(false)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("系统菜单…")
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
                    text: qsTr("任务栏进度 / 角标")
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
                        onMoved: function () {
                            if (root.appWin)
                                root.appWin.setTaskbarProgress(winProgress.value)
                        }
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
                        text: qsTr("不确定进度")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setTaskbarProgress(0, Md3WindowHelper.ProgressIndeterminate)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("错误")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setTaskbarProgress(winProgress.value, Md3WindowHelper.ProgressError)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("清除")
                        variant: Md3Button.Text
                        onClicked: if (root.appWin) root.appWin.clearTaskbarProgress()
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("叠加图标")
                        onClicked: if (root.appWin) root.appWin.setTaskbarOverlayIcon(Md3AppIcons.app16, qsTr("角标"))
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("清除角标")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.clearTaskbarOverlayIcon()
                    }
                }

                Text {
                    text: qsTr("Peek、捕获与外壳")
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
                            text: qsTr("从 Aero Peek 排除")
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
                            text: qsTr("禁止 Peek 预览")
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
                            text: qsTr("排除屏幕捕获")
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
                        text: qsTr("跳转列表")
                        onClicked: if (root.appWin) root.appWin.setJumpListTasks([
                            { title: qsTr("打开图库"), arguments: "" },
                            { title: qsTr("窗口页"), arguments: "--page=window" }
                        ])
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("缩略图栏")
                        onClicked: if (root.appWin) root.appWin.setThumbBarButtons([
                            { id: 1, icon: Md3AppIcons.app16, tooltip: qsTr("操作 A") },
                            { id: 2, icon: Md3AppIcons.app16, tooltip: qsTr("操作 B") }
                        ])
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("显示托盘")
                        onClicked: if (root.appWin) root.appWin.showSystemTrayIcon(Md3AppIcons.app16, qsTr("Md3 图库"))
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("气泡通知")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.showTrayNotification(qsTr("Md3 图库"), qsTr("托盘通知"), 4000)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("窗口置顶")
                        onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isWindows
                        text: qsTr("注册崩溃重启")
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
                    text: qsTr("Wayland 下「真模糊」需要合成器协议（Plasma + KF6WindowSystem + 开启 Blur 特效）。否则只会半透明。置顶/抢焦点也常被 Wayland 禁止——点按钮后看下方状态与桌面通知。")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                    font.family: Md3Theme.typography.fontFamily
                }

                Text {
                    visible: root.appWin && Md3WindowCapabilities.isLinux
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("已绑定 — Wayland=%1 模糊协议=%2 强调色=%3")
                          .arg(nativeHelper.wayland ? qsTr("是") : qsTr("否"))
                          .arg((root.appWin.windowNative
                                ? root.appWin.windowNative.blurBehindAvailable()
                                : nativeHelper.blurBehindAvailable()) ? qsTr("可用") : qsTr("不可用"))
                          .arg(nativeHelper.systemAccentColor())
                    color: Md3Theme.colorScheme.primary
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }

                Text {
                    visible: Md3WindowCapabilities.isLinux
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("原生反馈：%1").arg(
                              (root.appWin && root.appWin.windowNative
                               ? root.appWin.windowNative.lastNativeStatus
                               : nativeHelper.lastNativeStatus) || qsTr("（点击下方按钮后显示）"))
                    color: Md3Theme.colorScheme.tertiary
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                    font.family: Md3Theme.typography.fontFamily
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
                        text: qsTr("与主题同步配色方案")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                    }
                }

                Text {
                    text: qsTr("窗口操作")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("「请求注意」请先切到其他窗口再点；「前置」在已聚焦时无变化；「允许空闲」需先成功「禁止休眠」。")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("请求注意")
                        onClicked: if (root.appWin) root.appWin.flashTaskbar(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("停止")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.flashTaskbar(false)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("系统菜单…")
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
                        text: qsTr("前置激活")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.raiseWindow()
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("窗口置顶")
                        onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("取消置顶")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(false)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("禁止休眠/锁屏")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setIdleInhibit(true, qsTr("Md3 演示"))
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("允许空闲")
                        variant: Md3Button.Text
                        onClicked: if (root.appWin) root.appWin.setIdleInhibit(false)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("偏好深色")
                        onClicked: if (root.appWin) root.appWin.setPreferredAppMode(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("偏好浅色")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setPreferredAppMode(false)
                    }
                }

                Text {
                    text: qsTr("Dock 进度 / 角标")
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
                        onMoved: function () {
                            if (root.appWin)
                                root.appWin.setTaskbarProgress(linuxProgress.value)
                        }
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
                        text: qsTr("不确定进度")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setTaskbarProgress(0, Md3WindowHelper.ProgressIndeterminate)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("清除进度")
                        variant: Md3Button.Text
                        onClicked: if (root.appWin) root.appWin.clearTaskbarProgress()
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("角标 3")
                        onClicked: if (root.appWin) root.appWin.setDockBadge(3)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("清除角标")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setDockBadge(0)
                    }
                }

                Text {
                    text: qsTr("托盘 / 通知")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("显示托盘")
                        onClicked: if (root.appWin) root.appWin.showSystemTrayIcon(Md3AppIcons.app16, qsTr("Md3 图库"))
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("发送通知")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.showTrayNotification(qsTr("Md3 图库"), qsTr("桌面通知"), 4000)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("隐藏托盘")
                        variant: Md3Button.Text
                        onClicked: if (root.appWin) root.appWin.hideSystemTrayIcon()
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isLinux
                        text: qsTr("下一显示器")
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
                    text: qsTr("安装 resources/linux/appQML_MD3.desktop 以获得正确的 Wayland 任务栏图标（setDesktopFileName）。")
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
                    text: qsTr("macOS：保留红绿灯留白、半透明背景钩子、配色/强调色。标题按钮保持系统原生。")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                    font.family: Md3Theme.typography.fontFamily
                }

                Text {
                    visible: root.appWin && Md3WindowCapabilities.isMacOS
                    Layout.fillWidth: true
                    text: qsTr("已绑定 — 红绿灯留白=%1")
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
                        text: qsTr("与主题同步配色方案")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                    }
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("请求注意")
                        onClicked: if (root.appWin) root.appWin.flashTaskbar(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("前置激活")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.raiseWindow()
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("窗口置顶")
                        onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("取消置顶")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(false)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("程序坞角标 3")
                        onClicked: if (root.appWin) root.appWin.setDockBadge(3)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("清除角标")
                        variant: Md3Button.Outlined
                        onClicked: if (root.appWin) root.appWin.setDockBadge(0)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("偏好深色")
                        onClicked: if (root.appWin) root.appWin.setPreferredAppMode(true)
                    }
                    Md3Button {
                        enabled: Md3WindowCapabilities.isMacOS
                        text: qsTr("偏好浅色")
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
            text: qsTr("外壳事件：—")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }
        Connections {
            target: root.appWin && root.appWin.windowNative ? root.appWin.windowNative : nativeHelper
            function onThumbBarButtonClicked(buttonId) {
                shellEventLabel.text = qsTr("外壳事件：缩略图栏 #%1").arg(buttonId)
            }
            function onTrayActivated(reason) {
                shellEventLabel.text = qsTr("外壳事件：托盘 reason=%1").arg(reason)
            }
            function onDpiChanged(dpr, dpi) {
                shellEventLabel.text = qsTr("外壳事件：dpr=%1 dpi=%2").arg(dpr).arg(dpi)
            }
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: {
                const dpr = root.appWin ? root.appWin.windowDpr : nativeHelper.devicePixelRatio(Window.window)
                const dpi = root.appWin ? root.appWin.windowDpi : nativeHelper.windowDpi(Window.window)
                return qsTr("运行环境=%1  标签=%2  dpr=%3  dpi=%4")
                      .arg(Md3WindowCapabilities.platformId)
                      .arg([qsTr("Windows"), qsTr("Linux"), qsTr("macOS")][root.platformTab])
                      .arg(Number(dpr).toFixed(2))
                      .arg(dpi)
            }
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
        }
    }
}

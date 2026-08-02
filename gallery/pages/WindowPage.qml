import QtQuick
import QtQuick.Window
import QtCore
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.implicitHeight
    clip: true

    /// Injected by Md3PageHost; fallback Window.window (ApplicationWindow is the Window).
    property var md3HostWindow: null
    property bool md3PageActive: true
    readonly property var appWin: {
        const w = Md3OverlayHost.resolveWindow(md3HostWindow, root)
        if (w && w.systemBackdrop !== undefined)
            return w
        return null
    }

    readonly property int currentOsTab: {
        if (Md3WindowCapabilities.isWindows)
            return 0
        if (Md3WindowCapabilities.isWayland)
            return 1
        if (Md3WindowCapabilities.isX11)
            return 2
        if (Md3WindowCapabilities.isLinux)
            return 1 // generic Linux → Wayland tab as default browse target
        if (Md3WindowCapabilities.isMacOS)
            return 3
        if (Md3WindowCapabilities.isAndroid)
            return 4
        return 0
    }

    /// Tabs: 0 Windows · 1 Wayland · 2 X11 · 3 macOS · 4 Android
    property int platformTab: currentOsTab

    readonly property bool linuxDesktopActive: platformTab === 1 || platformTab === 2
    /// Ops only when viewing the tab that matches this machine's display server.
    readonly property bool linuxOpsEnabled: {
        if (platformTab === 1)
            return Md3WindowCapabilities.isWayland
        if (platformTab === 2)
            return Md3WindowCapabilities.isX11
        return false
    }
    readonly property bool androidOpsEnabled: platformTab === 4 && Md3WindowCapabilities.isAndroid

    readonly property var platformTabLabels: [
        qsTr("Windows"),
        qsTr("Wayland"),
        qsTr("X11"),
        qsTr("macOS"),
        qsTr("Android")
    ]

    Md3WindowHelper { id: nativeHelper }
    Connections {
        target: Md3NativeShell
        function onGlobalShortcutActivated(id) {
            Md3Notify.toast(qsTr("全局快捷键：%1").arg(id), { severity: Md3Toast.Success })
            if (root.appWin)
                root.appWin.raiseWindow()
        }
        function onSecondInstance(argv) {
            Md3Notify.snackbar(qsTr("次实例启动：%1").arg(argv.join(" ")))
            if (root.appWin)
                root.appWin.raiseWindow()
        }
        function onLockScreen() {
            Md3Notify.toast(qsTr("锁屏"), { severity: Md3Toast.Warning })
        }
        function onUnlockScreen() {
            Md3Notify.toast(qsTr("解锁"))
        }
    }
    Md3ReleaseUpdater {
        id: releaseUpdater
        owner: "wuyijing-dev"
        repo: "QML_MD3"
        currentVersion: "1.1.1"
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

    Md3VStack {
        id: column
        width: root.width
        spacing: 16

        Md3Text {
            text: qsTr("应用窗口")
            role: Md3Text.HeadlineMedium
        }

        Md3Text {
                    width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("下方为通用设置；按系统切换标签页查看原生能力。当前运行：%1%2。")
                  .arg(Md3WindowCapabilities.platformId)
                  .arg(Md3WindowCapabilities.isLinux
                       ? (Md3WindowCapabilities.isWayland ? " · Wayland"
                          : (Md3WindowCapabilities.isX11 ? " · X11" : ""))
                       : (Md3WindowCapabilities.isAndroid ? " · Android" : ""))
            role: Md3Text.BodyMedium
            tone: Md3Text.OnSurfaceVariant
        }

        Md3Text {
            text: qsTr("自适应（MD3 窗口类）")
            role: Md3Text.TitleSmall
        }
        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: {
                if (!root.appWin)
                    return qsTr("未绑定 ApplicationWindow。")
                const w = root.appWin
                return qsTr("宽度类 %1 · 设备 %2 · 外观 %3 · CSD %4 · 紧凑标题栏 %5 · 导航%6")
                      .arg(w.widthClassName !== undefined ? w.widthClassName
                           : Md3Adaptive.widthClassName(Md3Adaptive.widthClassFor(w.width)))
                      .arg(w.deviceClassName !== undefined ? w.deviceClassName
                           : Md3Adaptive.deviceClassName(Md3Adaptive.deviceClassFor(w.width, w.height)))
                      .arg(w.windowAppearanceName !== undefined ? w.windowAppearanceName
                           : Md3Adaptive.windowAppearanceName(Md3Adaptive.windowAppearanceFor(w.width, w.height)))
                      .arg(w.useCustomChrome !== undefined
                           ? (w.useCustomChrome ? qsTr("开") : qsTr("关"))
                           : (Md3Adaptive.useCustomChrome(w.width, w.height) ? qsTr("开") : qsTr("关")))
                      .arg(w.preferCompactTitleBar ? qsTr("是") : qsTr("否"))
                      .arg(w.preferNavigationBar ? qsTr("底栏") : qsTr("轨道"))
            }
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3FlowLayout {
            width: parent.width
            spacing: 8
            Md3Button {
                enabled: !!root.appWin && root.appWin.adaptiveChrome !== undefined
                text: qsTr("切换自适应外观")
                variant: Md3Button.Outlined
                onClicked: {
                    if (root.appWin && root.appWin.adaptiveChrome !== undefined)
                        root.appWin.adaptiveChrome = !root.appWin.adaptiveChrome
                }
            }
            Md3AssistChip {
                text: root.appWin && root.appWin.adaptiveChrome !== undefined
                      ? (root.appWin.adaptiveChrome ? qsTr("adaptiveChrome: on") : qsTr("adaptiveChrome: off"))
                      : qsTr("adaptiveChrome: —")
            }
        }

        Md3Text {
            text: qsTr("系统封装")
            role: Md3Text.TitleSmall
        }
        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("跨平台系统能力：打开 URL、资源管理器定位、分享/剪贴板、振动、沉浸式系统栏、任务栏可见性、居中/透明度等。状态见 lastNativeStatus。")
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3FlowLayout {
            width: parent.width
            spacing: 8
            Md3Button {
                enabled: Md3WindowCapabilities.systemOpen && !!root.appWin
                text: qsTr("打开官网")
                onClicked: if (root.appWin) root.appWin.openUrl("https://github.com/wuyijing-dev/QML_MD3")
            }
            Md3Button {
                enabled: Md3WindowCapabilities.revealInFolder && !!root.appWin
                text: qsTr("定位本程序目录")
                variant: Md3Button.Outlined
                onClicked: {
                    if (!root.appWin)
                        return
                    root.appWin.revealInFolder(Qt.application.arguments[0]
                                               ? ("file:///" + Qt.application.arguments[0].replace(/\\/g, "/"))
                                               : "")
                }
            }
            Md3Button {
                enabled: !!root.appWin
                text: qsTr("提示音")
                variant: Md3Button.Text
                onClicked: if (root.appWin) root.appWin.beep()
            }
            Md3Button {
                enabled: !!root.appWin
                text: qsTr("窗口居中")
                onClicked: if (root.appWin) root.appWin.centerOnScreen()
            }
            Md3Button {
                enabled: Md3WindowCapabilities.shareText && !!root.appWin
                text: qsTr("分享/复制文本")
                onClicked: if (root.appWin) root.appWin.shareText(qsTr("来自 Md3 Gallery 的系统分享测试"), qsTr("Md3"))
            }
            Md3Button {
                enabled: Md3WindowCapabilities.vibrate && !!root.appWin
                text: qsTr("振动")
                onClicked: if (root.appWin) root.appWin.vibrate(50)
            }
            Md3Button {
                enabled: Md3WindowCapabilities.immersiveSystemUi && !!root.appWin
                text: qsTr("沉浸式 UI")
                onClicked: if (root.appWin) root.appWin.setImmersiveSystemUi(true)
            }
            Md3Button {
                enabled: Md3WindowCapabilities.immersiveSystemUi && !!root.appWin
                text: qsTr("恢复系统栏")
                variant: Md3Button.Outlined
                onClicked: if (root.appWin) root.appWin.setImmersiveSystemUi(false)
            }
            Md3Button {
                enabled: Md3WindowCapabilities.skipTaskbar && !!root.appWin
                text: qsTr("隐藏任务栏按钮")
                variant: Md3Button.Outlined
                onClicked: if (root.appWin) root.appWin.setVisibleInTaskbar(false)
            }
            Md3Button {
                enabled: Md3WindowCapabilities.skipTaskbar && !!root.appWin
                text: qsTr("显示任务栏按钮")
                onClicked: if (root.appWin) root.appWin.setVisibleInTaskbar(true)
            }
            Md3Button {
                enabled: !!root.appWin
                text: qsTr("请求注意")
                onClicked: if (root.appWin) root.appWin.requestAttention(true)
            }
        }
        Md3Text {
            width: parent.width
            visible: !!root.appWin
            wrapMode: Text.WordWrap
            text: qsTr("原生反馈：%1 · 系统深色=%2")
                  .arg((root.appWin && root.appWin.windowNative
                        ? root.appWin.windowNative.lastNativeStatus
                        : "") || qsTr("（点击上方按钮后显示）"))
                  .arg(root.appWin && root.appWin.systemColorSchemeDark() ? qsTr("是") : qsTr("否"))
            role: Md3Text.BodySmall
            tone: Md3Text.Tertiary
        }

        // —— Electron-parity host ——
        Md3Text {
            text: qsTr("宿主能力（对标 Electron）")
            role: Md3Text.TitleSmall
        }
        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("Md3NativeShell：单实例 · 开机启动 · 全局快捷键(Win/macOS/Linux) · 自定义协议 · 电源/锁屏 · getPath。能力旗：openAtLogin=%1 · globalShortcut=%2 · protocolClient=%3")
                  .arg(Md3WindowCapabilities.openAtLogin ? qsTr("是") : qsTr("否"))
                  .arg(Md3WindowCapabilities.globalShortcut ? qsTr("是") : qsTr("否"))
                  .arg(Md3WindowCapabilities.protocolClient ? qsTr("是") : qsTr("否"))
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("userData=%1").arg(Md3NativeShell.userDataPath)
            role: Md3Text.BodySmall
            tone: Md3Text.Tertiary
        }
        Md3FlowLayout {
            width: parent.width
            spacing: 8
            Md3Button {
                text: qsTr("申请单实例锁")
                variant: Md3Button.FilledTonal
                onClicked: {
                    const ok = Md3NativeShell.requestSingleInstanceLock("QML_MD3.Gallery")
                    Md3Notify.toast(ok ? qsTr("本进程是主实例") : qsTr("已是次实例（应退出）"),
                                    { severity: ok ? Md3Toast.Success : Md3Toast.Warning })
                }
            }
            Md3Button {
                text: Md3NativeShell.openAtLogin ? qsTr("关闭开机启动") : qsTr("开启开机启动")
                enabled: Md3NativeShell.openAtLoginSupported
                variant: Md3Button.Outlined
                onClicked: {
                    const next = !Md3NativeShell.openAtLogin
                    Md3NativeShell.setOpenAtLoginEnabled(next)
                    Md3Notify.toast(next ? qsTr("已写入开机启动") : qsTr("已取消开机启动"))
                }
            }
            Md3Button {
                text: qsTr("注册 Ctrl+Shift+M")
                enabled: Md3NativeShell.globalShortcutSupported
                onClicked: {
                    const ok = Md3NativeShell.registerGlobalShortcut("gallery.focus", "Ctrl+Shift+M")
                    Md3Notify.toast(ok ? qsTr("全局快捷键已注册") : qsTr("注册失败"),
                                    { severity: ok ? Md3Toast.Success : Md3Toast.Error })
                }
            }
            Md3Button {
                text: qsTr("注销快捷键")
                enabled: Md3NativeShell.globalShortcutSupported
                variant: Md3Button.Text
                onClicked: {
                    Md3NativeShell.unregisterGlobalShortcut("gallery.focus")
                    Md3Notify.toast(qsTr("已注销"))
                }
            }
            Md3Button {
                text: qsTr("注册 md3gallery://")
                enabled: Md3NativeShell.protocolClientSupported
                variant: Md3Button.Outlined
                onClicked: {
                    const ok = Md3NativeShell.setAsDefaultProtocolClient("md3gallery")
                    Md3Notify.toast(ok ? qsTr("协议已注册") : qsTr("协议注册失败"),
                                    { severity: ok ? Md3Toast.Success : Md3Toast.Error })
                }
            }
            Md3Button {
                text: qsTr("移除协议")
                enabled: Md3NativeShell.protocolClientSupported
                variant: Md3Button.Text
                onClicked: {
                    Md3NativeShell.removeAsDefaultProtocolClient("md3gallery")
                    Md3Notify.toast(qsTr("协议已移除"))
                }
            }
            Md3Button {
                text: qsTr("打开 logs 目录")
                variant: Md3Button.Text
                onClicked: {
                    if (root.appWin)
                        root.appWin.revealInFolder(Md3NativeShell.logsPath)
                }
            }
        }
        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("Shell 状态：%1 · 主实例=%2 · 电池=%3")
                  .arg(Md3NativeShell.lastStatus || qsTr("（空）"))
                  .arg(Md3NativeShell.singleInstancePrimary ? qsTr("是") : qsTr("否"))
                  .arg(Md3NativeShell.onBattery ? qsTr("是") : qsTr("否"))
            role: Md3Text.BodySmall
            tone: Md3Text.Tertiary
        }

        // —— Shared ——
        Md3Text {
            text: qsTr("通用")
            role: Md3Text.TitleSmall
        }

        Md3Text {
            text: qsTr("标题栏中间槽 / AppToolBar / 文档标签撕离")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }
        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("图库 TitleBar 中间已放入 ChipGroup + ButtonGroup；窗口下方 AppToolBar 可切密度、新建标签、撕离当前标签。documentTabsEnabled + documentTabsTearOff 已开：拖出标签条，或点工具条「撕离」。")
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3Card {
            variant: Md3Card.Outlined
            width: parent.width
            title: qsTr("TitleBar / AppToolBar 内容槽（示例）")
            subtitle: qsTr("复制到 Md3ApplicationWindow { titleBar / toolBar }")
            Md3CodeBlock {
                width: parent.width
                height: 168
                language: "qml"
                showLineNumbers: false
                code: "titleBar: Md3TitleBar {
    Md3ChipGroup { model: [{ text: \"Inbox\" }] }
}
toolBar: Md3AppToolBar {
    Md3IconButton { icon: \"save\" }
    Md3Text { text: qsTr(\"Ready\") }
}"
            }
        }
        Md3FlowLayout {
            width: parent.width
            spacing: 8
            Md3Button {
                enabled: !!root.appWin
                text: qsTr("新建文档标签")
                variant: Md3Button.FilledTonal
                onClicked: if (root.appWin) root.appWin.addTab(root.appWin.currentIndex)
            }
            Md3Button {
                enabled: !!root.appWin && root.appWin.documentTabs
                         && root.appWin.documentTabs.length > 1
                text: qsTr("撕离当前标签")
                variant: Md3Button.Outlined
                onClicked: {
                    if (!root.appWin)
                        return
                    const cx = root.appWin.x + root.appWin.width / 2
                    const cy = root.appWin.y + 96
                    root.appWin.tearOffTab(root.appWin.documentTabIndex, cx, cy)
                }
            }
            Md3Button {
                enabled: !!root.appWin
                text: qsTr("关闭当前标签")
                variant: Md3Button.Text
                onClicked: if (root.appWin) root.appWin.closeTab()
            }
        }
        Md3Text {
            width: parent.width
            visible: !!root.appWin
            wrapMode: Text.WordWrap
            text: qsTr("标签数 %1 · 当前索引 %2 · 撕离=%3")
                  .arg(root.appWin && root.appWin.documentTabs
                       ? root.appWin.documentTabs.length : 0)
                  .arg(root.appWin ? root.appWin.documentTabIndex : -1)
                  .arg(root.appWin && root.appWin.documentTabsTearOff ? qsTr("开") : qsTr("关"))
            role: Md3Text.BodySmall
            tone: Md3Text.Tertiary
        }

        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("文档标签：标题栏下方开启 documentTabsEnabled。支持 + 新建 / 关闭 / 拖拽排序；拖出标签条可撕离为独立 Md3TabWindow（documentTabsTearOff）。")
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3Text {
            text: qsTr("图形后端（RHI）")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }
        Md3Text {
                    width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("%1 · 当前=%2 · 首选=%3%4")
                  .arg(Md3Graphics.platformName)
                  .arg(Md3Graphics.currentBackend)
                  .arg(Md3Graphics.preferredBackend)
                  .arg(Md3Graphics.restartRequired ? qsTr(" · 需重启生效") : "")
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3FlowLayout {
            width: parent.width
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

        Md3Text {
            text: qsTr("页面转场")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }
        Md3ButtonGroup {
            width: parent.width
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
        Md3HStack {
            spacing: 12
            Md3Switch {
                checked: root.appWin ? root.appWin.pageSkeleton : false
                onToggled: function (on) {
                    if (root.appWin)
                        root.appWin.pageSkeleton = on
                }
            }
            Md3Text {
                text: qsTr("加载时显示骨架屏")
                role: Md3Text.BodySmall
                tone: Md3Text.OnSurfaceVariant
            }
        }
        Md3HStack {
            spacing: 12
            Md3Switch {
                checked: Md3Theme.reduceMotion
                onToggled: function (on) {
                    Md3Theme.reduceMotion = on
                    Md3AppSettings.setValue("a11y/reduceMotion", on)
                }
            }
            Md3Text {
                text: qsTr("减少动效（PageHost 切换立刻完成）")
                role: Md3Text.BodySmall
                tone: Md3Text.OnSurfaceVariant
            }
            Md3Button {
                text: qsTr("淡入 350ms (iOS)")
                variant: Md3Button.Text
                enabled: !!root.appWin
                onClicked: {
                    if (!root.appWin)
                        return
                    root.appWin.pageTransition = "fade"
                    root.appWin.pageTransitionDuration = Md3Motion.medium2
                }
            }
        }

        Md3Text {
            text: qsTr("Release 更新")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }
        Md3HStack {
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
        Md3Text {
                    width: parent.width
            wrapMode: Text.WordWrap
            text: releaseUpdater.errorString.length
                  ? releaseUpdater.errorString
                  : (releaseUpdater.latestVersion.length
                     ? qsTr("Current %1 · Latest %2 · %3")
                           .arg(releaseUpdater.currentVersion)
                           .arg(releaseUpdater.latestVersion)
                           .arg(releaseUpdater.hasUpdate ? qsTr("Update available") : qsTr("Up to date"))
                     : qsTr("Checks GitHub Release metadata and exposes a ZIP download URL."))
            role: Md3Text.BodySmall
            tone: releaseUpdater.errorString.length ? Md3Text.Error : Md3Text.OnSurfaceVariant
        }
        Md3Text {
            visible: releaseUpdater.downloading || releaseUpdater.downloadedFilePath.length > 0
            width: parent.width
            wrapMode: Text.WordWrap
            text: releaseUpdater.downloading
                  ? qsTr("Download %1%").arg(Math.round(releaseUpdater.downloadProgress * 100))
                  : qsTr("Downloaded: %1").arg(releaseUpdater.downloadedFilePath)
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }

        // —— Per-OS tabs ——
        Md3Text {
            text: qsTr("平台原生")
            role: Md3Text.TitleSmall
        }

        Md3TabBar {
            width: parent.width
            currentIndex: root.platformTab
            model: [
                { text: qsTr("Windows") },
                { text: qsTr("Wayland") },
                { text: qsTr("X11") },
                { text: qsTr("macOS") },
                { text: qsTr("Android") }
            ]
            onCurrentIndexChangedByUser: function (index) {
                root.platformTab = index
            }
        }

        Md3Text {
            visible: root.platformTab !== root.currentOsTab
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("正在浏览其他平台标签；可操作控件仅对本机（%1 / %2）生效。")
                  .arg(Md3WindowCapabilities.platformId)
                  .arg(Md3WindowCapabilities.displayServer)
            role: Md3Text.BodySmall
            tone: Md3Text.Tertiary
        }

        Item {
            id: platformHost
            width: parent.width
            height: {
                const loaders = [winPaneLoader, linuxPaneLoader, linuxPaneLoader, macPaneLoader, androidPaneLoader]
                const L = loaders[root.platformTab]
                return (L && L.item) ? L.item.implicitHeight : 0
            }

            Loader {
                id: winPaneLoader
                width: parent.width
                active: root.md3PageActive && root.platformTab === 0
                sourceComponent: windowsPaneComp
                onLoaded: if (item) item.width = Qt.binding(function () { return winPaneLoader.width })
            }
            Loader {
                id: linuxPaneLoader
                width: parent.width
                active: root.md3PageActive && root.linuxDesktopActive
                sourceComponent: linuxPaneComp
                onLoaded: if (item) item.width = Qt.binding(function () { return linuxPaneLoader.width })
            }
            Loader {
                id: macPaneLoader
                width: parent.width
                active: root.md3PageActive && root.platformTab === 3
                sourceComponent: macPaneComp
                onLoaded: if (item) item.width = Qt.binding(function () { return macPaneLoader.width })
            }
            Loader {
                id: androidPaneLoader
                width: parent.width
                active: root.md3PageActive && root.platformTab === 4
                sourceComponent: androidPaneComp
                onLoaded: if (item) item.width = Qt.binding(function () { return androidPaneLoader.width })
            }

            Component {
                id: windowsPaneComp
    Md3VStack {
                    id: paneWindows
                    width: parent.width
                    spacing: 12

                    Md3Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: qsTr("Windows 10/11 客户区（能力袋 id=windows）：DWM 边框、任务栏进度与角标、跳转列表、缩略图工具栏、托盘、Peek/捕获、延迟 Snap Layouts。（系统背景材质已标记为不适合使用，Gallery 不再展示。）")
                        role: Md3Text.BodyMedium
                        tone: Md3Text.OnSurfaceVariant
                    }

                    Md3Text {
                        width: parent.width
                        visible: root.appWin && Md3WindowCapabilities.isWindows
                        wrapMode: Text.WordWrap
                        text: qsTr("已绑定 — 边框=\"%1\"")
                              .arg(root.appWin ? root.appWin.nativeBorderColor : "")
                        role: Md3Text.BodySmall
                        tone: Md3Text.Primary
                    }
                    Md3HStack {
                        visible: Md3WindowCapabilities.isWindows && root.appWin
                        spacing: 12
                        Md3Switch {
                            checked: root.appWin.syncImmersiveDarkMode
                            onToggled: function (isOn) { root.appWin.syncImmersiveDarkMode = isOn }
                        }
                        Md3Text {
                            text: qsTr("与主题同步沉浸式深色")
                            role: Md3Text.BodyMedium
                        }
                    }

                    Md3Text {
                        text: qsTr("DWM 边框颜色")
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3FlowLayout {
                width: parent.width
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

                    Md3FlowLayout {
                width: parent.width
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

                    Md3Text {
                        text: qsTr("任务栏进度 / 角标")
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3HStack {
                        spacing: 12
                        enabled: Md3WindowCapabilities.isWindows
                        Md3Slider {
                            id: winProgress
                            from: 0; to: 1; value: 0.35
                            onMoved: function () {
                                if (root.appWin)
                                    root.appWin.setTaskbarProgress(winProgress.value)
                            }
                        }
                        Md3Text {
                            text: Math.round(winProgress.value * 100) + "%"
                            role: Md3Text.BodySmall
                            tone: Md3Text.OnSurfaceVariant
                        }
                    }
                    Md3FlowLayout {
                width: parent.width
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
                        Md3Button {
                            enabled: Md3WindowCapabilities.isWindows
                                       || Md3WindowCapabilities.isAndroid
                                       || Md3WindowCapabilities.isLinux
                            text: qsTr("数字角标 3")
                            onClicked: if (root.appWin) root.appWin.setDockBadge(3)
                        }
                        Md3Button {
                            enabled: Md3WindowCapabilities.isWindows
                                       || Md3WindowCapabilities.isAndroid
                                       || Md3WindowCapabilities.isLinux
                            text: qsTr("清除数字角标")
                            variant: Md3Button.Text
                            onClicked: if (root.appWin) root.appWin.setDockBadge(0)
                        }
                    }

                    Md3Text {
                        text: qsTr("空闲抑制")
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3FlowLayout {
                        width: parent.width
                        spacing: 8
                        Md3Button {
                            enabled: Md3WindowCapabilities.idleInhibit
                            text: qsTr("防止休眠")
                            onClicked: {
                                if (!root.appWin)
                                    return
                                const ok = root.appWin.setIdleInhibit(true, qsTr("Md3 演示"))
                                shellEventLabel.text = ok ? qsTr("外壳事件：已抑制空闲")
                                                         : qsTr("外壳事件：空闲抑制失败")
                            }
                        }
                        Md3Button {
                            enabled: Md3WindowCapabilities.idleInhibit
                            text: qsTr("恢复空闲")
                            variant: Md3Button.Outlined
                            onClicked: {
                                if (!root.appWin)
                                    return
                                root.appWin.setIdleInhibit(false)
                                shellEventLabel.text = qsTr("外壳事件：已恢复空闲计时")
                            }
                        }
                    }

                    Md3Text {
                        visible: Md3WindowCapabilities.isAndroid
                        text: qsTr("Android：系统标题栏；息屏抑制=FLAG_KEEP_SCREEN_ON；防截屏=FLAG_SECURE；角标=setBadgeNumber。")
                        role: Md3Text.BodySmall
                        tone: Md3Text.OnSurfaceVariant
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    Md3Text {
                        visible: Md3WindowCapabilities.isWindows && Md3WindowCapabilities.snapLayouts
                        text: qsTr("Snap Layouts：短按最大化按钮为普通最大化；悬停约 0.4s 后触发 Win11 贴靠面板。")
                        role: Md3Text.BodySmall
                        tone: Md3Text.OnSurfaceVariant
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    Md3Text {
                        text: qsTr("Peek、捕获与外壳")
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3VStack {
                        spacing: 8
                        enabled: Md3WindowCapabilities.isWindows
                        Md3HStack {
                            spacing: 12
                            Md3Switch {
                                onToggled: function (on) { if (root.appWin) root.appWin.setExcludedFromPeek(on) }
                            }
                            Md3Text {
                                wrapMode: Text.WordWrap
                                text: qsTr("从 Aero Peek 排除")
                                role: Md3Text.BodyMedium
                            }
                        }
                        Md3HStack {
                            spacing: 12
                            Md3Switch {
                                onToggled: function (on) { if (root.appWin) root.appWin.setDisallowPeek(on) }
                            }
                            Md3Text {
                                text: qsTr("禁止 Peek 预览")
                                role: Md3Text.BodyMedium
                            }
                        }
                        Md3HStack {
                            spacing: 12
                            Md3Switch {
                                onToggled: function (on) { if (root.appWin) root.appWin.setExcludeFromCapture(on) }
                            }
                            Md3Text {
                                text: qsTr("排除屏幕捕获")
                                role: Md3Text.BodyMedium
                            }
                        }
                    }
                    Md3FlowLayout {
                width: parent.width
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
                            onClicked: {
                                if (!root.appWin)
                                    return
                                const ok = root.appWin.showSystemTrayIcon(Md3AppIcons.app16, qsTr("Md3 图库"))
                                shellEventLabel.text = ok ? qsTr("外壳事件：托盘图标已显示（左键抬窗 / 右键菜单）")
                                                         : qsTr("外壳事件：显示托盘失败")
                            }
                        }
                        Md3Button {
                            enabled: Md3WindowCapabilities.isWindows
                            text: qsTr("气泡通知")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.showTrayNotification(qsTr("Md3 图库"), qsTr("托盘通知"), 4000)
                        }
                        Md3Button {
                            enabled: Md3WindowCapabilities.isWindows
                            text: qsTr("隐藏托盘")
                            variant: Md3Button.Text
                            onClicked: {
                                if (!root.appWin)
                                    return
                                root.appWin.hideSystemTrayIcon()
                                shellEventLabel.text = qsTr("外壳事件：托盘已隐藏")
                            }
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
            }

            Component {
                id: linuxPaneComp
    Md3VStack {
                    id: paneLinuxDesktop
                    width: parent.width
                    spacing: 12

                    Md3Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: root.platformTab === 2
                              ? qsTr("X11（xcb）：CSD 客户区、KX11Extras KeepAbove / forceActiveWindow（装 KF 时）、KWin blur atom、StatusNotifier 托盘、LauncherEntry 进度/角标、空闲抑制。合成器仍可能覆盖置顶。")
                              : qsTr("Wayland：CSD、xdg-activation 前置、KF6 模糊协议（需合成器开启 Blur）、托盘 portal、LauncherEntry。无令牌时「前置」常被忽略；fractional scale 更可靠。")
                        role: Md3Text.BodyMedium
                        tone: Md3Text.OnSurfaceVariant
                    }

                    Md3Text {
                        width: parent.width
                        visible: root.appWin && root.linuxOpsEnabled
                        wrapMode: Text.WordWrap
                        text: qsTr("已绑定 — 显示服务器=%1 · 能力袋=%2 · 模糊=%3 · 强调色=%4")
                              .arg(Md3WindowCapabilities.displayServer)
                              .arg(Md3WindowCapabilities.platformId)
                              .arg((root.appWin.windowNative
                                    ? root.appWin.windowNative.blurBehindAvailable()
                                    : nativeHelper.blurBehindAvailable()) ? qsTr("可用") : qsTr("不可用"))
                              .arg(nativeHelper.systemAccentColor())
                        role: Md3Text.BodySmall
                        tone: Md3Text.Primary
                    }

                    Md3Text {
                        width: parent.width
                        visible: root.linuxOpsEnabled
                        wrapMode: Text.WordWrap
                        text: qsTr("原生反馈：%1").arg(
                                  (root.appWin && root.appWin.windowNative
                                   ? root.appWin.windowNative.lastNativeStatus
                                   : nativeHelper.lastNativeStatus) || qsTr("（点击下方按钮后显示）"))
                        role: Md3Text.BodySmall
                        tone: Md3Text.Tertiary
                    }
                    Md3HStack {
                        visible: root.linuxOpsEnabled && root.appWin
                        spacing: 12
                        Md3Switch {
                            checked: root.appWin.syncImmersiveDarkMode
                            onToggled: function (isOn) { root.appWin.syncImmersiveDarkMode = isOn }
                        }
                        Md3Text {
                            width: parent.width
                            text: qsTr("与主题同步配色方案")
                            role: Md3Text.BodyMedium
                        }
                    }

                    Md3Text {
                        text: qsTr("窗口操作")
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: root.platformTab === 2
                              ? qsTr("X11：「请求注意」请先切到其他窗口；「前置」可用 forceActiveWindow（KF）。「允许空闲」需先成功「禁止休眠」。")
                              : qsTr("Wayland：「请求注意」请先切窗；无 xdg-activation 令牌时「前置」常被忽略（看 lastNativeStatus）。「允许空闲」需先成功「禁止休眠」。")
                        role: Md3Text.BodySmall
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3FlowLayout {
                        width: parent.width
                        spacing: 8
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("请求注意")
                            onClicked: if (root.appWin) root.appWin.flashTaskbar(true)
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("停止")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.flashTaskbar(false)
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
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
                            enabled: root.linuxOpsEnabled
                            text: qsTr("前置激活")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.raiseWindow()
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("窗口置顶")
                            onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(true)
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("取消置顶")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(false)
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("禁止休眠/锁屏")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setIdleInhibit(true, qsTr("Md3 演示"))
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("允许空闲")
                            variant: Md3Button.Text
                            onClicked: if (root.appWin) root.appWin.setIdleInhibit(false)
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("偏好深色")
                            onClicked: if (root.appWin) root.appWin.setPreferredAppMode(true)
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("偏好浅色")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setPreferredAppMode(false)
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("打开模糊设置")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.openBlurSettings()
                        }
                    }

                    Md3Text {
                        text: qsTr("Dock 进度 / 角标")
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3HStack {
                        spacing: 12
                        enabled: root.linuxOpsEnabled
                        Md3Slider {
                            id: linuxProgress
                            from: 0; to: 1; value: 0.35
                            onMoved: function () {
                                if (root.appWin)
                                    root.appWin.setTaskbarProgress(linuxProgress.value)
                            }
                        }
                        Md3Text {
                            text: Math.round(linuxProgress.value * 100) + "%"
                            role: Md3Text.BodySmall
                            tone: Md3Text.OnSurfaceVariant
                        }
                    }
                    Md3FlowLayout {
                        width: parent.width
                        spacing: 8
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("不确定进度")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setTaskbarProgress(0, Md3WindowHelper.ProgressIndeterminate)
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("清除进度")
                            variant: Md3Button.Text
                            onClicked: if (root.appWin) root.appWin.clearTaskbarProgress()
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("角标 3")
                            onClicked: if (root.appWin) root.appWin.setDockBadge(3)
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("清除角标")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setDockBadge(0)
                        }
                    }

                    Md3Text {
                        text: qsTr("托盘 / 通知")
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3FlowLayout {
                        width: parent.width
                        spacing: 8
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("显示托盘")
                            onClicked: {
                                if (!root.appWin)
                                    return
                                const ok = root.appWin.showSystemTrayIcon(Md3AppIcons.app16, qsTr("Md3 图库"))
                                shellEventLabel.text = ok ? qsTr("外壳事件：托盘图标已显示（左键抬窗 / 右键菜单）")
                                                         : qsTr("外壳事件：显示托盘失败")
                            }
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("发送通知")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.showTrayNotification(qsTr("Md3 图库"), qsTr("桌面通知"), 4000)
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
                            text: qsTr("隐藏托盘")
                            variant: Md3Button.Text
                            onClicked: if (root.appWin) root.appWin.hideSystemTrayIcon()
                        }
                        Md3Button {
                            enabled: root.linuxOpsEnabled
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

                    Md3Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: root.platformTab === 2
                              ? qsTr("X11 能力袋 id=x11。桌面文件仍建议安装以便任务栏匹配。")
                              : qsTr("Wayland 能力袋 id=wayland。安装 resources/linux/appQML_MD3.desktop 以获得正确的任务栏图标（desktopFileName → xdg app_id）。")
                        role: Md3Text.BodySmall
                        tone: Md3Text.OnSurfaceVariant
                    }
                }
            }

            Component {
                id: macPaneComp
    Md3VStack {
                    id: paneMac
                    width: parent.width
                    spacing: 12

                    Md3Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: qsTr("macOS：保留红绿灯留白、半透明背景钩子、配色/强调色。标题按钮保持系统原生。能力袋 id=macos。")
                        role: Md3Text.BodyMedium
                        tone: Md3Text.OnSurfaceVariant
                    }

                    Md3Text {
                        visible: root.appWin && Md3WindowCapabilities.isMacOS
                        text: qsTr("已绑定 — 红绿灯留白=%1")
                              .arg(nativeHelper.trafficLightsInset)
                        role: Md3Text.BodySmall
                        tone: Md3Text.Primary
                    }
                    Md3HStack {
                        visible: Md3WindowCapabilities.isMacOS && root.appWin
                        spacing: 12
                        Md3Switch {
                            checked: root.appWin.syncImmersiveDarkMode
                            onToggled: function (isOn) { root.appWin.syncImmersiveDarkMode = isOn }
                        }
                        Md3Text {
                            text: qsTr("与主题同步配色方案")
                            role: Md3Text.BodyMedium
                        }
                    }

                    Md3FlowLayout {
                width: parent.width
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

            Component {
                id: androidPaneComp
    Md3VStack {
                    id: paneAndroid
                    width: parent.width
                    spacing: 12

                    Md3Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: qsTr("Android：系统标题栏（无 CSD / Snap / 托盘）。能力袋 id=android。原生：亮屏/FLAG_SECURE/角标/沉浸式/分享/振动，以及通知、系统栏颜色、方向锁定、软键盘、Toast/触觉、应用设置、电池优化白名单。")
                        role: Md3Text.BodyMedium
                        tone: Md3Text.OnSurfaceVariant
                    }

                    Md3Text {
                        width: parent.width
                        visible: root.androidOpsEnabled && root.appWin
                        wrapMode: Text.WordWrap
                        text: qsTr("已绑定 — displayServer=%1 · notifications=%2 · systemBar=%3 · softInput=%4")
                              .arg(Md3WindowCapabilities.displayServer)
                              .arg(Md3WindowCapabilities.notifications ? qsTr("是") : qsTr("否"))
                              .arg(Md3WindowCapabilities.systemBarColors ? qsTr("是") : qsTr("否"))
                              .arg(Md3WindowCapabilities.softInput ? qsTr("是") : qsTr("否"))
                        role: Md3Text.BodySmall
                        tone: Md3Text.Primary
                    }

                    Md3Text {
                        width: parent.width
                        visible: root.androidOpsEnabled
                        wrapMode: Text.WordWrap
                        text: qsTr("原生反馈：%1").arg(
                                  (root.appWin && root.appWin.windowNative
                                   ? root.appWin.windowNative.lastNativeStatus
                                   : nativeHelper.lastNativeStatus) || qsTr("（点击下方按钮后显示）"))
                        role: Md3Text.BodySmall
                        tone: Md3Text.Tertiary
                    }

                    Md3Text {
                        text: qsTr("屏幕 / 安全")
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3FlowLayout {
                        width: parent.width
                        spacing: 8
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("保持亮屏")
                            onClicked: {
                                if (!root.appWin) return
                                const ok = root.appWin.setIdleInhibit(true, qsTr("Md3 演示"))
                                shellEventLabel.text = ok ? qsTr("外壳事件：FLAG_KEEP_SCREEN_ON")
                                                         : qsTr("外壳事件：息屏抑制失败")
                            }
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("恢复息屏")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setIdleInhibit(false)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("防截屏 ON")
                            onClicked: if (root.appWin) root.appWin.setExcludeFromCapture(true)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("防截屏 OFF")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setExcludeFromCapture(false)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.immersiveSystemUi
                            text: qsTr("沉浸式 UI")
                            onClicked: if (root.appWin) root.appWin.setImmersiveSystemUi(true)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.immersiveSystemUi
                            text: qsTr("恢复系统栏")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setImmersiveSystemUi(false)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.screenOrientation
                            text: qsTr("锁定竖屏")
                            onClicked: if (root.appWin) root.appWin.setScreenOrientation("portrait")
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.screenOrientation
                            text: qsTr("方向自动")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setScreenOrientation("sensor")
                        }
                    }

                    Md3Text {
                        text: qsTr("系统栏 / 通知 / Toast")
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3FlowLayout {
                        width: parent.width
                        spacing: 8
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.systemBarColors
                            text: qsTr("主题色状态栏")
                            onClicked: {
                                if (!root.appWin) return
                                const c = String(Md3Theme.colorScheme.primary)
                                root.appWin.setSystemBarColors(c, c, !Md3Theme.dark)
                            }
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.notifications
                            text: qsTr("系统通知")
                            onClicked: if (root.appWin) root.appWin.showTrayNotification(qsTr("Md3"), qsTr("Android 通知测试"), 4000)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.nativeToast
                            text: qsTr("原生 Toast")
                            onClicked: if (root.appWin) root.appWin.nativeToast(qsTr("Hello from Md3"))
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("通知设置")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.openNotificationSettings()
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.openAppSettings
                            text: qsTr("应用设置")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.openAppSettings()
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("电池优化白名单")
                            variant: Md3Button.Text
                            onClicked: if (root.appWin) root.appWin.requestIgnoreBatteryOptimizations()
                        }
                    }

                    Md3Text {
                        text: qsTr("角标 / 分享 / 振动 / 键盘")
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3FlowLayout {
                        width: parent.width
                        spacing: 8
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("角标 3")
                            onClicked: if (root.appWin) root.appWin.setDockBadge(3)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("清除角标")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setDockBadge(0)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.shareText
                            text: qsTr("系统分享")
                            onClicked: if (root.appWin) root.appWin.shareText(qsTr("来自 Md3 Gallery"), qsTr("Md3"))
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.vibrate
                            text: qsTr("振动")
                            onClicked: if (root.appWin) root.appWin.vibrate(50)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.softInput
                            text: qsTr("显示键盘")
                            onClicked: if (root.appWin) root.appWin.showSoftInput()
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.softInput
                            text: qsTr("隐藏键盘")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.hideSoftInput()
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled && Md3WindowCapabilities.hapticFeedback
                            text: qsTr("触觉")
                            onClicked: if (root.appWin) root.appWin.hapticFeedback(0)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("复制测试")
                            variant: Md3Button.Text
                            onClicked: Md3Notify.copy(qsTr("Md3 clipboard"), { feedback: qsTr("已复制") })
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("尝试置顶")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(true)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("取消置顶")
                            variant: Md3Button.Text
                            onClicked: if (root.appWin) root.appWin.setAlwaysOnTop(false)
                        }
                        Md3Button {
                            enabled: root.androidOpsEnabled
                            text: qsTr("前置 Activity")
                            variant: Md3Button.Outlined
                            onClicked: if (root.appWin) root.appWin.raiseWindow()
                        }
                    }

                    Md3Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: qsTr("详见 docs/topics/android.md。桌面端浏览本标签时按钮禁用。Android 13+ 通知需 POST_NOTIFICATIONS；shareFile 需宿主 FileProvider（${applicationId}.fileprovider）。")
                        role: Md3Text.BodySmall
                        tone: Md3Text.OnSurfaceVariant
                    }
                }
            }
        }

        Md3Text {
            id: shellEventLabel
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("外壳事件：—")
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
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

        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: {
                const win = root.appWin || Md3OverlayHost.resolveWindow(root.md3HostWindow, root)
                const dpr = root.appWin ? root.appWin.windowDpr : nativeHelper.devicePixelRatio(win)
                const dpi = root.appWin ? root.appWin.windowDpi : nativeHelper.windowDpi(win)
                const tab = root.platformTabLabels[root.platformTab] || "?"
                return qsTr("运行环境=%1  显示服务器=%2  标签=%3  dpr=%4  dpi=%5")
                      .arg(Md3WindowCapabilities.platformId)
                      .arg(Md3WindowCapabilities.displayServer)
                      .arg(tab)
                      .arg(Number(dpr).toFixed(2))
                      .arg(dpi)
            }
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }
    }
}

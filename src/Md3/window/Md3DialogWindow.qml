import QtQuick
import QtQuick.Window
import QtQuick.Effects

/// Separate OS-level dialog window (QWidget-like multi-window), not an overlay.
Window {
    id: root

    property bool customChrome: Md3WindowCapabilities.customChrome
    property bool showTitleBar: true
    property bool roundedCorners: Md3WindowCapabilities.roundedCorners
    property real cornerRadius: Md3WindowCapabilities.windowCornerRadius
    property bool showWindowBorder: true
    property alias titleBarItem: titleBarLoader.item
    property alias overlay: overlayHost.data
    property Component titleBar: null
    property url windowIcon: Md3AppIcons.window
    property bool syncImmersiveDarkMode: true
    property int systemBackdrop: 0
    property string nativeBorderColor: ""
    readonly property bool usesSystemBackdrop: systemBackdrop > 0
    property real backdropTint: 0.08
    property real backdropContentTint: 0.18
    property real backdropTitleTint: 0.06

    /// Owner window for transient parenting (centers / groups with parent)
    property var owner: null
    /// ApplicationModal | WindowModal | NonModal
    property int dialogModality: Qt.ApplicationModal
    property bool resizable: true
    property bool closable: true
    /// Title-bar pin (always-on-top) — on by default for dialog windows
    property bool showPinButton: true
    property bool pinned: false
    property bool showMinimizeButton: false
    property bool showMaximizeButton: false
    property bool showThemeToggle: false
    property bool showStandardButtons: true
    property string confirmText: qsTr("OK")
    property string dismissText: qsTr("Cancel")
    property bool showDismiss: true
    property string dialogText: ""
    property int layoutMode: Md3ContainerBody.Fit

    signal confirmed()
    signal dismissed()
    signal opened()
    signal closed()

    default property alias content: customContent.content
    property alias footer: footerSlot.data

    width: 480
    height: 360
    minimumWidth: 280
    minimumHeight: 160
    visible: false
    title: qsTr("Dialog")
    modality: root.dialogModality
    transientParent: {
        if (owner && owner instanceof Window)
            return owner
        return null
    }

    readonly property bool isMaximizedLike: visibility === Window.Maximized
                                            || visibility === Window.FullScreen
    readonly property real effectiveRadius: {
        if (!customChrome || !roundedCorners || isMaximizedLike)
            return 0
        return Math.max(0, cornerRadius)
    }

    color: (customChrome && Md3WindowCapabilities.customChrome) || usesSystemBackdrop
           ? "transparent" : Md3Theme.colorScheme.surface

    flags: {
        let f = Qt.Dialog
        if (root.customChrome && Md3WindowCapabilities.customChrome)
            f |= Qt.FramelessWindowHint
        if (root.pinned)
            f |= Qt.WindowStaysOnTopHint
        return f
    }

    Md3WindowHelper {
        id: windowHelper
    }
    readonly property alias windowNative: windowHelper

    readonly property real edge: 6
    readonly property bool canResize: resizable && customChrome && Md3WindowCapabilities.systemResize
                                      && !isMaximizedLike

    function openDialog(ownerWindow) {
        if (ownerWindow !== undefined && ownerWindow !== null)
            root.owner = ownerWindow
        if (root.owner && root.owner instanceof Window)
            root.transientParent = root.owner
        root.visible = true
        root.raise()
        root.requestActivate()
        root.opened()
    }

    function closeDialog() {
        root.visible = false
        root.closed()
    }

    function accept() {
        root.confirmed()
        closeDialog()
    }

    function reject() {
        root.dismissed()
        closeDialog()
    }

    function setPinned(onTop) {
        root.pinned = !!onTop
        if (windowHelper.alwaysOnTopSupported)
            windowHelper.setAlwaysOnTop(root, root.pinned)
        if (titleBarLoader.item && titleBarLoader.item.pinned !== undefined)
            titleBarLoader.item.pinned = root.pinned
    }

    function togglePinned() {
        setPinned(!root.pinned)
    }

    Component.onCompleted: {
        windowHelper.bindWindow(root)
        windowHelper.applyCornerPreference(root, root.effectiveRadius > 0)
        _applyWindowIcon()
        _syncWinNative()
        if (root.pinned)
            setPinned(true)
    }

    Component.onDestruction: {
        windowHelper.unbindWindow(root)
    }

    onWindowIconChanged: _applyWindowIcon()
    onEffectiveRadiusChanged: windowHelper.applyCornerPreference(root, effectiveRadius > 0)
    onVisibilityChanged: function () {
        windowHelper.applyCornerPreference(root, effectiveRadius > 0)
        if (root.visibility !== Window.Hidden)
            Qt.callLater(function () {
                root._applyWindowIcon()
                root._syncWinNative()
                if (root.pinned)
                    root.setPinned(true)
            })
    }
    onVisibleChanged: {
        if (visible)
            Qt.callLater(function () {
                root._applyWindowIcon()
                root._syncWinNative()
            })
    }
    onSystemBackdropChanged: _syncWinNative()
    onNativeBorderColorChanged: _syncWinNative()
    onPinnedChanged: {
        if (windowHelper.alwaysOnTopSupported)
            windowHelper.setAlwaysOnTop(root, root.pinned)
    }
    onOwnerChanged: {
        if (owner && owner instanceof Window)
            transientParent = owner
    }

    Connections {
        target: Md3Theme
        function onDarkChanged() { root._syncWinNative() }
    }

    function _applyWindowIcon() {
        if (!windowIcon || windowIcon.toString().length === 0)
            return
        windowHelper.setWindowIcon(root, windowIcon)
        if (titleBarLoader.item && titleBarLoader.item.appIcon !== undefined)
            titleBarLoader.item.appIcon = windowIcon
    }

    function _syncWinNative() {
        if (!windowHelper || !root.visible)
            return
        if (syncImmersiveDarkMode && windowHelper.immersiveDarkModeSupported)
            windowHelper.setImmersiveDarkMode(root, Md3Theme.dark)
        if (windowHelper.systemBackdropSupported)
            windowHelper.setSystemBackdrop(root, systemBackdrop)
        if (windowHelper.platformId === "windows")
            windowHelper.setBorderColor(root, nativeBorderColor.length > 0 ? nativeBorderColor : "default")
    }

    Item {
        id: shell
        anchors.fill: parent
        z: 0

        Item {
            id: chrome
            anchors.fill: parent

            layer.enabled: root.effectiveRadius > 0 && !root.usesSystemBackdrop
            layer.smooth: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: chromeMask
            }

            Rectangle {
                id: fill
                anchors.fill: parent
                radius: root.usesSystemBackdrop ? 0 : root.effectiveRadius
                color: root.usesSystemBackdrop
                       ? Qt.alpha(Md3Theme.colorScheme.surface, root.backdropTint)
                       : (root.customChrome ? Qt.alpha(Md3Theme.colorScheme.surface, 0.98)
                                            : Md3Theme.colorScheme.surface)
                visible: !root.usesSystemBackdrop || root.backdropTint > 0.001
            }

            Rectangle {
                anchors.fill: parent
                radius: root.effectiveRadius
                color: "transparent"
                border.width: root.showWindowBorder && root.effectiveRadius > 0 && !root.usesSystemBackdrop ? 1 : 0
                border.color: Md3Theme.colorScheme.outlineVariant
                z: 50
            }

            Loader {
                id: titleBarLoader
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                active: root.showTitleBar && root.customChrome
                height: active && item ? item.height : 0
                z: 100
                sourceComponent: root.titleBar !== null ? root.titleBar : defaultTitleBar
                onLoaded: {
                    if (!item)
                        return
                    if (item.targetWindow !== undefined)
                        item.targetWindow = root
                    if (item.windowHelper !== undefined)
                        item.windowHelper = windowHelper
                    if (item.cornerRadius !== undefined)
                        item.cornerRadius = Qt.binding(function () { return root.effectiveRadius })
                    if (item.title !== undefined)
                        item.title = Qt.binding(function () { return root.title })
                    if (item.appIcon !== undefined && root.windowIcon.toString().length > 0)
                        item.appIcon = Qt.binding(function () { return root.windowIcon })
                    if (item.showPin !== undefined)
                        item.showPin = Qt.binding(function () { return root.showPinButton })
                    if (item.pinned !== undefined)
                        item.pinned = Qt.binding(function () { return root.pinned })
                    if (item.showMinimize !== undefined)
                        item.showMinimize = Qt.binding(function () { return root.showMinimizeButton })
                    if (item.showMaximize !== undefined)
                        item.showMaximize = Qt.binding(function () { return root.showMaximizeButton })
                    if (item.showThemeToggle !== undefined)
                        item.showThemeToggle = Qt.binding(function () { return root.showThemeToggle })
                    if (item.showAboutButton !== undefined)
                        item.showAboutButton = false
                    if (item.showClose !== undefined)
                        item.showClose = Qt.binding(function () { return root.closable })
                    if (item.pinToggled) {
                        item.pinToggled.connect(function (onTop) {
                            root.pinned = onTop
                        })
                    }
                }
            }

            Component {
                id: defaultTitleBar
                Md3TitleBar {
                    title: root.title
                    appIcon: root.windowIcon
                    showAppIcon: true
                    showThemeToggle: root.showThemeToggle
                    showAboutButton: false
                    showPin: root.showPinButton
                    pinned: root.pinned
                    showMinimize: root.showMinimizeButton
                    showMaximize: root.showMaximizeButton
                    showClose: root.closable
                    targetWindow: root
                    windowHelper: windowHelper
                    cornerRadius: root.effectiveRadius
                    preferredHeight: 28
                    barHeight: 28
                    leadingInset: windowHelper.trafficLightsInset > 0
                                  ? windowHelper.trafficLightsInset
                                  : Md3WindowCapabilities.trafficLightsInset
                    onPinToggled: function (onTop) { root.pinned = onTop }
                }
            }

            Item {
                id: contentHost
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: titleBarLoader.bottom
                anchors.bottom: parent.bottom
                clip: true
                z: 0

                Item {
                    anchors.fill: parent
                    anchors.margins: 24

                    Column {
                        id: mainCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: footerArea.top
                        anchors.bottomMargin: 16
                        spacing: 16

                        Text {
                            width: parent.width
                            visible: root.dialogText.length > 0
                            text: root.dialogText
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.bodyMedium.size
                            wrapMode: Text.Wrap
                        }

                        Md3ContainerBody {
                            id: customContent
                            width: parent.width
                            layoutMode: root.layoutMode
                        }
                    }

                    Binding {
                        target: customContent
                        property: "height"
                        value: Math.max(0, mainCol.height
                                        - (root.dialogText.length > 0 ? 48 : 0))
                    }

                    Item {
                        id: footerArea
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: Math.max(footerSlot.childrenRect.height, footerRow.height, 36)

                        Item {
                            id: footerSlot
                            anchors.left: parent.left
                            anchors.right: footerRow.left
                            anchors.rightMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            height: childrenRect.height
                            width: Math.max(0, parent.width - footerRow.width - 8)
                        }

                        Row {
                            id: footerRow
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 8
                            visible: root.showStandardButtons

                            Md3Button {
                                visible: root.showDismiss
                                text: root.dismissText
                                variant: Md3Button.Text
                                onClicked: root.reject()
                            }
                            Md3Button {
                                text: root.confirmText
                                variant: Md3Button.Text
                                onClicked: root.accept()
                            }
                        }
                    }
                }
            }

            Item {
                id: overlayHost
                anchors.fill: parent
                z: 1000
            }
        }

        Item {
            id: chromeMask
            width: chrome.width
            height: chrome.height
            layer.enabled: chrome.layer.enabled
            visible: false
            Rectangle {
                anchors.fill: parent
                radius: root.effectiveRadius
                color: "#ffffff"
            }
        }
    }

    component ResizeEdge: MouseArea {
        property int edges: 0
        enabled: root.canResize
        hoverEnabled: true
        z: 200
        onPressed: root.startSystemResize(edges)
    }

    ResizeEdge {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.edge
        edges: Qt.LeftEdge
        cursorShape: Qt.SizeHorCursor
    }
    ResizeEdge {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.edge
        edges: Qt.RightEdge
        cursorShape: Qt.SizeHorCursor
    }
    ResizeEdge {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: root.edge
        edges: Qt.TopEdge
        cursorShape: Qt.SizeVerCursor
        z: 300
    }
    ResizeEdge {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: root.edge
        edges: Qt.BottomEdge
        cursorShape: Qt.SizeVerCursor
    }
    ResizeEdge {
        anchors.left: parent.left
        anchors.top: parent.top
        width: root.edge * 2
        height: root.edge * 2
        edges: Qt.LeftEdge | Qt.TopEdge
        cursorShape: Qt.SizeFDiagCursor
    }
    ResizeEdge {
        anchors.right: parent.right
        anchors.top: parent.top
        width: root.edge * 2
        height: root.edge * 2
        edges: Qt.RightEdge | Qt.TopEdge
        cursorShape: Qt.SizeBDiagCursor
    }
    ResizeEdge {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: root.edge * 2
        height: root.edge * 2
        edges: Qt.LeftEdge | Qt.BottomEdge
        cursorShape: Qt.SizeBDiagCursor
    }
    ResizeEdge {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: root.edge * 2
        height: root.edge * 2
        edges: Qt.RightEdge | Qt.BottomEdge
        cursorShape: Qt.SizeFDiagCursor
    }

    Shortcut {
        sequences: [StandardKey.Cancel]
        enabled: root.visible && root.closable
        onActivated: root.reject()
    }
}

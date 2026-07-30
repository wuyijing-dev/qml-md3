import QtQuick
import QtQuick.Window
import Md3

// Win-native style title bar: [icon][single-line title] | flexible middle | trailing | caption
// Title block is reserved — middle content must not squeeze it.
Rectangle {
    id: root

    property var targetWindow: null
    property var windowHelper: null

    property string title: ""
    /// Deprecated — Win title bars are single-line; kept for API compat, not shown
    property string subtitle: ""
    property string leadingIcon: ""
    property bool showLeading: leadingIcon.length > 0
    property bool showTitle: true
    property bool showAppIcon: true
    property bool showThemeToggle: true
    /// Info button opens a modeless About dialog
    property bool showAboutButton: true
    property string aboutAppName: ""
    property string aboutVersion: ""
    property string aboutOrganization: ""
    property string aboutText: ""
    property url aboutIcon: ""
    /// Optional custom body for the About dialog (replaces default text block)
    property Component aboutContent: null
    /// Performance monitor toggle (right of trailing content, before theme)
    property bool showPerformanceToggle: false
    property bool performanceChecked: false
    /// Product tour / onboarding guide (before About / performance / theme)
    property bool showTourButton: false
    /// Pin / always-on-top (shown by default)
    property bool showPin: true
    property bool pinned: false
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showClose: true
    property bool dragEnabled: Md3WindowCapabilities.systemMove
    property bool nativeCaptionHit: Md3WindowCapabilities.captionHitTest
    property real leadingInset: Md3WindowCapabilities.trafficLightsInset
    property real cornerRadius: 0

    /// Window / taskbar icon (qrc or file). Synced from Md3ApplicationWindow.windowIcon when bound.
    property url appIcon: ""

    property real preferredHeight: 28
    property real compactHeight: 28
    property bool compact: false
    property real barHeight: -1
    property real padding: 6
    property real contentSpacing: 6
    /// Reserved title area (Win-like); middle never steals from this
    property real minTitleWidth: 96
    property real maxTitleWidth: 240

    /// 0=Auto (narrow → second row for middle only), 1=SingleRow, 2=TwoRow
    property int responsiveMode: 0
    property real collapseWidth: 900

    property alias leadingContent: leadingSlot.data
    property alias trailingContent: trailingSlot.data
    property alias extraActions: trailingSlot.data
    property alias middleContent: middleFlow.content
    property alias centerContent: middleFlow.content
    default property alias content: middleFlow.content

    Accessible.role: Accessible.TitleBar
    Accessible.name: title.length ? title : qsTr("Title bar")

    signal leadingClicked()
    signal themeToggled()
    signal performanceClicked()
    signal tourClicked()
    signal pinToggled(bool pinned)
    signal aboutClicked()

    function resolvedAboutName() {
        if (aboutAppName.length > 0)
            return aboutAppName
        if (Qt.application.displayName && Qt.application.displayName.length > 0)
            return Qt.application.displayName
        if (Qt.application.name && Qt.application.name.length > 0)
            return Qt.application.name
        return root.title.length > 0 ? root.title : qsTr("Application")
    }

    function resolvedAboutVersion() {
        if (aboutVersion.length > 0)
            return aboutVersion
        return (Qt.application.version && Qt.application.version.length > 0)
                ? Qt.application.version : ""
    }

    function resolvedAboutOrganization() {
        if (aboutOrganization.length > 0)
            return aboutOrganization
        return (Qt.application.organization && Qt.application.organization.length > 0)
                ? Qt.application.organization : ""
    }

    function resolvedAboutIcon() {
        if (aboutIcon.toString().length > 0)
            return aboutIcon
        return root.appIcon
    }

    function openAbout() {
        if (root.targetWindow && typeof root.targetWindow.openAbout === "function")
            root.targetWindow.openAbout()
        root.aboutClicked()
    }

    function setPinned(onTop) {
        root.pinned = !!onTop
        if (root.windowHelper && root.targetWindow
                && root.windowHelper.alwaysOnTopSupported)
            root.windowHelper.setAlwaysOnTop(root.targetWindow, root.pinned)
        else if (root.targetWindow)
            root.targetWindow.flags = root.pinned
                    ? (root.targetWindow.flags | Qt.WindowStaysOnTopHint)
                    : (root.targetWindow.flags & ~Qt.WindowStaysOnTopHint)
        root.pinToggled(root.pinned)
    }

    function togglePinned() {
        setPinned(!root.pinned)
    }

    function reportNativeHits() {
        if (!root.windowHelper || !root.targetWindow)
            return
        const host = root.targetWindow.contentItem
        if (!host)
            return
        if (root.nativeCaptionHit && titleBlock.width > 0) {
            const p = titleBlock.mapToItem(host, 0, 0)
            root.windowHelper.setCaptionHitRect(root.targetWindow, p.x, p.y, titleBlock.width, titleBlock.height)
        } else {
            root.windowHelper.clearCaptionHitRect(root.targetWindow)
        }
    }

    function openSystemMenu(globalX, globalY) {
        if (root.windowHelper && root.targetWindow
                && root.windowHelper.systemMenuSupported)
            root.windowHelper.showSystemMenu(root.targetWindow, globalX, globalY)
    }

    Component.onCompleted: Qt.callLater(reportNativeHits)
    Component.onDestruction: {
        if (root.windowHelper && root.targetWindow)
            root.windowHelper.clearCaptionHitRect(root.targetWindow)
    }
    onWidthChanged: Qt.callLater(reportNativeHits)
    onHeightChanged: Qt.callLater(reportNativeHits)
    onNativeCaptionHitChanged: Qt.callLater(reportNativeHits)

    readonly property real baseHeight: barHeight >= 0 ? barHeight
                                       : (compact ? compactHeight : preferredHeight)

    readonly property bool twoRow: {
        if (responsiveMode === 2)
            return true
        if (responsiveMode === 1)
            return false
        return width > 0 && width < collapseWidth
    }

    readonly property real contentHeight: {
        if (barHeight >= 0)
            return barHeight
        if (!twoRow)
            return baseHeight
        const midH = middleFlow.contentHeight
        return baseHeight + (midH > 0 ? midH + padding : 0)
    }

    readonly property real _titleBlockWidth: {
        if (!showTitle && !showAppIcon)
            return 0
        const iconW = showAppIcon ? 16 + 8 : 0
        const textW = showTitle && title.length > 0
                      ? Math.min(maxTitleWidth, Math.max(minTitleWidth, titleMetrics.advanceWidth + 4))
                      : 0
        return iconW + textW
    }

    color: {
        const base = Md3Theme.colorScheme.surfaceContainer
        if (root.targetWindow && root.targetWindow.usesSystemBackdrop) {
            const t = root.targetWindow.backdropTitleTint !== undefined
                      ? root.targetWindow.backdropTitleTint : 0.06
            return Qt.alpha(base, t)
        }
        return base
    }
    topLeftRadius: cornerRadius
    topRightRadius: cornerRadius
    clip: true
    height: contentHeight
    width: parent ? parent.width : 400

    TextMetrics {
        id: titleMetrics
        font.family: Md3Theme.typography.fontFamily
        font.pixelSize: 12
        font.weight: Font.Normal
        text: root.title
    }

    Behavior on height {
        enabled: root.barHeight < 0
        NumberAnimation {
            duration: Md3Motion.spatialDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.spatialDefault
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        anchors.topMargin: 6 // leave OS / ResizeEdge band for top-edge resize
        anchors.rightMargin: rightChrome.width + padding
        z: 0
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        enabled: root.dragEnabled && root.targetWindow !== null
        cursorShape: Qt.ArrowCursor
        onPressed: function (mouse) {
            if (mouse.button === Qt.RightButton) {
                const g = mapToGlobal(mouse.x, mouse.y)
                root.openSystemMenu(g.x, g.y)
                return
            }
            if (root.targetWindow && root.dragEnabled)
                root.targetWindow.startSystemMove()
        }
        onDoubleClicked: function (mouse) {
            if (mouse.button !== Qt.LeftButton)
                return
            if (!root.targetWindow || !Md3WindowCapabilities.doubleClickMaximize)
                return
            if (!root.showMaximize)
                return
            if (root.targetWindow.visibility === Window.Maximized)
                root.targetWindow.showNormal()
            else
                root.targetWindow.showMaximized()
        }
    }

    Item {
        id: topBand
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: root.leadingInset
        height: root.baseHeight
        z: 2

        Row {
            id: leadingRow
            anchors.left: parent.left
            anchors.leftMargin: root.padding
            anchors.verticalCenter: parent.verticalCenter
            spacing: root.contentSpacing

            Md3TitleBarButton {
                visible: root.showLeading
                buttonWidth: 40
                buttonHeight: root.baseHeight
                iconSize: 14
                icon: root.leadingIcon
                accessibleName: qsTr("Back")
                onClicked: root.leadingClicked()
            }

            Item {
                id: leadingSlot
                width: childrenRect.width
                height: root.baseHeight
            }
        }

        // Reserved Win-style identity: icon + single-line title (never compressed by middle)
        Item {
            id: titleBlock
            anchors.left: leadingRow.right
            anchors.leftMargin: leadingRow.width > 0 ? root.contentSpacing : 0
            anchors.verticalCenter: parent.verticalCenter
            width: root._titleBlockWidth
            height: root.baseHeight
            z: 3
            onWidthChanged: Qt.callLater(root.reportNativeHits)
            onHeightChanged: Qt.callLater(root.reportNativeHits)
            onXChanged: Qt.callLater(root.reportNativeHits)
            onYChanged: Qt.callLater(root.reportNativeHits)

            Row {
                id: titleRow
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                spacing: 8

                Item {
                    id: appIconHit
                    width: 16
                    height: 16
                    visible: root.showAppIcon
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: appIconImage
                        anchors.fill: parent
                        visible: root.appIcon.toString().length > 0
                        source: root.appIcon
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                    }

                    Md3Icon {
                        anchors.centerIn: parent
                        visible: !appIconImage.visible
                        icon: "web_asset"
                        size: 16
                        iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -4
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: function (mouse) {
                            const g = mapToGlobal(mouse.x, mouse.y)
                            root.openSystemMenu(g.x, g.y)
                        }
                        onDoubleClicked: function (mouse) {
                            if (mouse.button === Qt.LeftButton && root.targetWindow)
                                root.targetWindow.close()
                        }
                    }
                }

                Text {
                    visible: root.showTitle && root.title.length > 0
                    text: root.title
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    width: Math.min(root.maxTitleWidth,
                                    Math.max(root.minTitleWidth, titleMetrics.advanceWidth + 4))
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Row {
            id: rightChrome
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            spacing: 0
            z: 3

            Item {
                id: trailingSlot
                width: childrenRect.width
                height: root.baseHeight
            }

            Md3TitleBarButton {
                id: tourBtn
                visible: root.showTourButton
                buttonHeight: root.baseHeight
                buttonWidth: 40
                iconSize: 14
                icon: "tour"
                accessibleName: qsTr("Start tour")
                onClicked: root.tourClicked()
            }

            Md3TitleBarButton {
                id: aboutBtn
                visible: root.showAboutButton
                buttonHeight: root.baseHeight
                buttonWidth: 40
                iconSize: 14
                icon: "info"
                accessibleName: qsTr("About")
                onClicked: root.openAbout()
            }

            Md3TitleBarButton {
                id: performanceBtn
                visible: root.showPerformanceToggle
                buttonHeight: root.baseHeight
                buttonWidth: 40
                iconSize: 14
                icon: "speed"
                checked: root.performanceChecked
                accessibleName: qsTr("Performance monitor")
                onClicked: root.performanceClicked()
            }

            Md3TitleBarButton {
                id: themeToggleBtn
                visible: root.showThemeToggle
                buttonHeight: root.baseHeight
                buttonWidth: 40
                iconSize: 14
                icon: Md3Theme.dark ? "light_mode" : "dark_mode"
                accessibleName: Md3Theme.dark ? qsTr("Light mode") : qsTr("Dark mode")
                onClicked: {
                    if (root.targetWindow && typeof root.targetWindow.toggleThemeFrom === "function")
                        root.targetWindow.toggleThemeFrom(themeToggleBtn)
                    else
                        Md3Theme.toggleDark()
                    root.themeToggled()
                }
            }

            Md3TitleBarButton {
                id: pinBtn
                visible: root.showPin
                buttonHeight: root.baseHeight
                buttonWidth: 40
                iconSize: 14
                icon: "push_pin"
                checked: root.pinned
                accessibleName: root.pinned ? qsTr("Unpin window") : qsTr("Pin window on top")
                onClicked: root.togglePinned()
            }

            Md3CaptionButtons {
                id: caption
                height: root.baseHeight
                targetWindow: root.targetWindow
                windowHelper: root.windowHelper
                cornerRadius: root.cornerRadius
                showMinimize: root.showMinimize
                showMaximize: root.showMaximize
                showClose: root.showClose
            }
        }
    }

    // Middle only uses leftover width — never overlaps titleBlock
    Item {
        id: middleHost
        z: 1
        clip: true
        x: root.twoRow
           ? root.leadingInset + root.padding
           : titleBlock.x + titleBlock.width + root.contentSpacing
        y: root.twoRow ? root.baseHeight : 0
        width: {
            const right = rightChrome.width + root.padding + root.contentSpacing
            return Math.max(0, root.width - x - right)
        }
        height: root.twoRow ? Math.max(0, root.height - root.baseHeight) : root.baseHeight

        Md3AnimatedFlow {
            id: middleFlow
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            fillWidth: true
            spacing: root.contentSpacing
            rowSpacing: 6
            animate: true
            moveDuration: Md3Motion.spatialDuration
            moveEasing: Md3Motion.spatialDefault
        }
    }
}

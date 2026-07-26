import QtQuick
import QtQuick.Effects

Item {
    id: root

    enum Layout { Standard, Connected }
    enum Variant { Filled, FilledTonal, Outlined, Text }

    property int layout: Md3ButtonGroup.Standard
    property int variant: Md3ButtonGroup.Outlined
    property var model: [] // [{ text, icon?, enabled? }]
    property bool enabled: true
    property int currentIndex: -1 // optional highlight; -1 = none
    property real spacing: 8
    /// Compact title-bar / dense UIs: set e.g. 24–28
    property real buttonHeight: 40
    property real iconSize: 18
    property real fontSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)

    signal clicked(int index)

    readonly property real outerRadius: buttonHeight / 2
    readonly property bool connected: layout === Md3ButtonGroup.Connected

    implicitHeight: buttonHeight
    implicitWidth: connected ? connectedFrame.width : standardRow.implicitWidth
    height: implicitHeight
    width: implicitWidth

    function itemEnabled(index) {
        if (!enabled)
            return false
        const item = model[index]
        return !(item && item.enabled === false)
    }

    function containerFor(selected) {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContainer()
        if (connected) {
            if (selected)
                return Md3Theme.colorScheme.secondaryContainer
            return "transparent"
        }
        switch (variant) {
        case Md3ButtonGroup.Filled: return Md3Theme.colorScheme.primary
        case Md3ButtonGroup.FilledTonal: return Md3Theme.colorScheme.secondaryContainer
        case Md3ButtonGroup.Text:
        case Md3ButtonGroup.Outlined: return "transparent"
        default: return Md3Theme.colorScheme.primary
        }
    }

    function contentFor(selected) {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        if (connected) {
            return selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                            : Md3Theme.colorScheme.colorOnSurface
        }
        switch (variant) {
        case Md3ButtonGroup.Filled: return Md3Theme.colorScheme.colorOnPrimary
        case Md3ButtonGroup.FilledTonal: return Md3Theme.colorScheme.colorOnSecondaryContainer
        case Md3ButtonGroup.Text:
        case Md3ButtonGroup.Outlined: return Md3Theme.colorScheme.primary
        default: return Md3Theme.colorScheme.colorOnPrimary
        }
    }

    // --- Standard: spaced separate buttons ---
    Row {
        id: standardRow
        visible: !root.connected
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.spacing

        Repeater {
            model: root.model

            delegate: Item {
                id: std
                required property int index
                required property var modelData

                readonly property string label: modelData.text !== undefined ? modelData.text : String(modelData)
                readonly property string iconName: modelData.icon !== undefined ? modelData.icon : ""
                readonly property bool btnEnabled: root.itemEnabled(index)
                readonly property bool selected: root.currentIndex === index

                width: Math.max(root.buttonHeight, stdRow.implicitWidth + Math.max(16, root.buttonHeight * 0.6))
                height: root.buttonHeight

                Item {
                    id: stdBg
                    anchors.centerIn: parent
                    width: parent.width
                    height: root.buttonHeight

                    layer.enabled: true
                    layer.smooth: true
                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: stdMask
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: root.outerRadius
                        color: root.containerFor(std.selected)
                        border.width: root.variant === Md3ButtonGroup.Outlined ? 1 : 0
                        border.color: std.btnEnabled ? Md3Theme.colorScheme.outline
                                                     : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.outline, 0.12)

                        Behavior on color {
                            ColorAnimation {
                                duration: Md3Motion.short4
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Md3Motion.standard
                            }
                        }
                    }

                    Md3Ripple {
                        id: stdRipple
                        rippleColor: root.contentFor(std.selected)
                        clipRadius: root.outerRadius
                    }
                    Md3StateOverlay {
                        overlayColor: root.contentFor(std.selected)
                        hovered: stdMouse.containsMouse
                        pressed: stdMouse.pressed
                        focused: false
                        controlEnabled: std.btnEnabled
                        radius: root.outerRadius
                    }

                    Row {
                        id: stdRow
                        anchors.centerIn: parent
                        spacing: 8
                        Md3Icon {
                            visible: std.iconName.length > 0
                            icon: std.iconName
                            size: root.iconSize
                            iconColor: std.btnEnabled ? root.contentFor(std.selected)
                                                      : Md3Theme.colorScheme.disabledContent()
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: std.label
                            color: std.btnEnabled ? root.contentFor(std.selected)
                                                  : Md3Theme.colorScheme.disabledContent()
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: root.fontSize
                            font.weight: Md3Theme.typography.labelLarge.weight
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                Item {
                    id: stdMask
                    width: stdBg.width
                    height: stdBg.height
                    layer.enabled: true
                    visible: false
                    Rectangle {
                        anchors.fill: parent
                        radius: root.outerRadius
                        color: "#ffffff"
                    }
                }

                MouseArea {
                    id: stdMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: std.btnEnabled
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onPressed: function (mouse) {
                        const local = mapToItem(stdBg, mouse.x, mouse.y)
                        stdRipple.pulse(local.x, local.y)
                    }
                    onClicked: root.clicked(std.index)
                }

                Accessible.name: std.label
                Accessible.role: Accessible.Button
            }
        }
    }

    // --- Connected: joined segments ---
    Rectangle {
        id: connectedFrame
        visible: root.connected
        anchors.verticalCenter: parent.verticalCenter
        width: connectedRow.width
        height: root.buttonHeight
        radius: root.outerRadius
        color: "transparent"
        border.width: 1
        border.color: root.enabled ? Md3Theme.colorScheme.outline
                                   : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.outline, 0.12)

        Row {
            id: connectedRow
            height: parent.height

            Repeater {
                model: root.model

                delegate: Item {
                    id: seg
                    required property int index
                    required property var modelData

                    readonly property string label: modelData.text !== undefined ? modelData.text : String(modelData)
                    readonly property string iconName: modelData.icon !== undefined ? modelData.icon : ""
                    readonly property bool segEnabled: root.itemEnabled(index)
                    readonly property bool selected: root.currentIndex === index
                    readonly property bool isFirst: index === 0
                    readonly property bool isLast: index === root.model.length - 1

                    width: Math.max(root.buttonHeight, segRow.implicitWidth + Math.max(16, root.buttonHeight * 0.6))
                    height: parent.height

                    Rectangle {
                        id: segFill
                        anchors.fill: parent
                        topLeftRadius: seg.isFirst ? root.outerRadius : 0
                        bottomLeftRadius: seg.isFirst ? root.outerRadius : 0
                        topRightRadius: seg.isLast ? root.outerRadius : 0
                        bottomRightRadius: seg.isLast ? root.outerRadius : 0
                        color: {
                            if (!seg.segEnabled)
                                return seg.selected ? Md3Theme.colorScheme.disabledContainer() : "transparent"
                            return seg.selected ? Md3Theme.colorScheme.secondaryContainer : "transparent"
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: Md3Motion.short4
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Md3Motion.standard
                            }
                        }

                        Md3Ripple {
                            id: segRipple
                            rippleColor: seg.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                      : Md3Theme.colorScheme.colorOnSurface
                            clipRadius: 0
                            topLeftRadius: seg.isFirst ? root.outerRadius : 0
                            bottomLeftRadius: seg.isFirst ? root.outerRadius : 0
                            topRightRadius: seg.isLast ? root.outerRadius : 0
                            bottomRightRadius: seg.isLast ? root.outerRadius : 0
                        }
                        Md3StateOverlay {
                            overlayColor: seg.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                       : Md3Theme.colorScheme.colorOnSurface
                            hovered: segMouse.containsMouse
                            pressed: segMouse.pressed
                            focused: false
                            controlEnabled: seg.segEnabled
                            topLeftRadius: segFill.topLeftRadius
                            bottomLeftRadius: segFill.bottomLeftRadius
                            topRightRadius: segFill.topRightRadius
                            bottomRightRadius: segFill.bottomRightRadius
                        }

                        Row {
                            id: segRow
                            anchors.centerIn: parent
                            spacing: 8
                            Md3Icon {
                                visible: seg.iconName.length > 0
                                icon: seg.iconName
                                size: root.iconSize
                                iconColor: {
                                    if (!seg.segEnabled)
                                        return Md3Theme.colorScheme.disabledContent()
                                    return seg.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                        : Md3Theme.colorScheme.colorOnSurface
                                }
                                anchors.verticalCenter: parent.verticalCenter
                                Behavior on iconColor {
                                    ColorAnimation {
                                        duration: Md3Motion.short4
                                        easing.type: Easing.BezierSpline
                                        easing.bezierCurve: Md3Motion.standard
                                    }
                                }
                            }
                            Text {
                                text: seg.label
                                color: {
                                    if (!seg.segEnabled)
                                        return Md3Theme.colorScheme.disabledContent()
                                    return seg.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                        : Md3Theme.colorScheme.colorOnSurface
                                }
                                font.family: Md3Theme.typography.fontFamily
                                font.pixelSize: root.fontSize
                                font.weight: Md3Theme.typography.labelLarge.weight
                                anchors.verticalCenter: parent.verticalCenter
                                Behavior on color {
                                    ColorAnimation {
                                        duration: Md3Motion.short4
                                        easing.type: Easing.BezierSpline
                                        easing.bezierCurve: Md3Motion.standard
                                    }
                                }
                            }
                        }

                        Rectangle {
                            visible: index < root.model.length - 1
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 1
                            height: parent.height
                            color: root.enabled ? Md3Theme.colorScheme.outline
                                                : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.outline, 0.12)
                        }
                    }

                    MouseArea {
                        id: segMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: seg.segEnabled
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onPressed: function (mouse) {
                            const local = mapToItem(segFill, mouse.x, mouse.y)
                            segRipple.pulse(local.x, local.y)
                        }
                        onClicked: root.clicked(seg.index)
                    }

                    Accessible.name: seg.label
                    Accessible.role: Accessible.Button
                }
            }
        }
    }
}

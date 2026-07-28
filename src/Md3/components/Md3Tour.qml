import QtQuick
import QtQuick.Window
import QtQuick.Effects

/// Guided tour overlay: rounded spotlight cutout + animated step transitions.
Item {
    id: root
    anchors.fill: parent
    visible: opacity > 0.01
    opacity: active ? 1 : 0
    z: 100000

    property bool active: false
    property int currentIndex: 0
    /// [{ target: Item, title, body, placement, radius? }]
    property var steps: []
    property bool persistCompleted: true
    property string completedKey: "tour/completed"
    property real holePad: 10
    property int transitionDuration: Md3Motion.medium2

    signal finished()
    signal skipped()
    signal stepChanged(int index)

    Behavior on opacity {
        NumberAnimation {
            duration: Md3Motion.short4
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }

    readonly property var currentStep: {
        if (!steps || currentIndex < 0 || currentIndex >= steps.length)
            return null
        return steps[currentIndex]
    }

    readonly property Item currentTarget: {
        const s = currentStep
        return (s && s.target) ? s.target : null
    }

    // Animated hole geometry (scrim + ring bind to these)
    property real holeX: 0
    property real holeY: 0
    property real holeW: 0
    property real holeH: 0
    property real holeR: Md3Theme.shape.large

    Behavior on holeX {
        NumberAnimation {
            duration: root.transitionDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }
    Behavior on holeY {
        NumberAnimation {
            duration: root.transitionDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }
    Behavior on holeW {
        NumberAnimation {
            duration: root.transitionDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }
    Behavior on holeH {
        NumberAnimation {
            duration: root.transitionDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }
    Behavior on holeR {
        NumberAnimation {
            duration: root.transitionDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }

    function start(at) {
        currentIndex = Math.max(0, at !== undefined ? at : 0)
        if (!steps || steps.length === 0)
            return
        active = true
        cardPulse.restart()
        stepChanged(currentIndex)
        _snapHoleThenAnimate()
    }

    function stop(completed) {
        active = false
        if (completed && persistCompleted)
            Md3AppSettings.setValue(completedKey, true)
        if (completed)
            finished()
        else
            skipped()
    }

    function next() {
        if (currentIndex + 1 >= steps.length) {
            stop(true)
            return
        }
        currentIndex++
        cardPulse.restart()
        stepChanged(currentIndex)
        _refreshHole(false)
    }

    function previous() {
        if (currentIndex <= 0)
            return
        currentIndex--
        cardPulse.restart()
        stepChanged(currentIndex)
        _refreshHole(false)
    }

    function _targetRadius(t) {
        if (!t)
            return Md3Theme.shape.large
        const s = currentStep
        if (s && s.radius !== undefined)
            return Number(s.radius) + holePad
        if (t.radius !== undefined && Number(t.radius) > 0)
            return Number(t.radius) + holePad * 0.5
        if (t.cornerRadius !== undefined && Number(t.cornerRadius) > 0)
            return Number(t.cornerRadius) + holePad * 0.5
        if (t.effectiveRadius !== undefined && Number(t.effectiveRadius) > 0)
            return Number(t.effectiveRadius) + holePad * 0.5
        // Icon buttons / chips tend to be circular or full
        const side = Math.min(t.width, t.height)
        if (side > 0 && side <= 56 && Math.abs(t.width - t.height) < 2)
            return side / 2 + holePad
        return Md3Theme.shape.large + holePad * 0.25
    }

    function _computeHole() {
        const t = currentTarget
        if (!t || t.width <= 0 || t.height <= 0) {
            return { x: width / 2, y: height / 2, w: 0, h: 0, r: 0 }
        }
        const p = t.mapToItem(root, 0, 0)
        return {
            x: p.x - holePad,
            y: p.y - holePad,
            w: t.width + holePad * 2,
            h: t.height + holePad * 2,
            r: Math.min(_targetRadius(t), (t.width + holePad * 2) / 2, (t.height + holePad * 2) / 2)
        }
    }

    function _applyHole(h, instant) {
        if (instant) {
            holeX = h.x
            holeY = h.y
            holeW = h.w
            holeH = h.h
            holeR = h.r
            return
        }
        holeX = h.x
        holeY = h.y
        holeW = h.w
        holeH = h.h
        holeR = h.r
    }

    function _refreshHole(instant) {
        _applyHole(_computeHole(), !!instant)
    }

    function _snapHoleThenAnimate() {
        // First show: place hole without long travel from 0,0
        _refreshHole(true)
        Qt.callLater(function () { root._refreshHole(false) })
    }

    onCurrentIndexChanged: if (active) _refreshHole(false)
    onActiveChanged: {
        if (active)
            _snapHoleThenAnimate()
    }

    Timer {
        running: root.active
        interval: 32
        repeat: true
        onTriggered: root._refreshHole(false)
    }

    // Full-screen dim with true rounded-rect cutout via inverted mask
    Item {
        id: dimLayer
        anchors.fill: parent
        z: 0

        Rectangle {
            id: dimFill
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.58)
            visible: false
            layer.enabled: root.active
            layer.smooth: true
        }

        // Mask: opaque rounded hole on transparent — invert so dim is cut out there
        Item {
            id: holeMask
            anchors.fill: parent
            visible: false
            layer.enabled: root.active
            layer.smooth: true

            Rectangle {
                x: root.holeX
                y: root.holeY
                width: Math.max(0, root.holeW)
                height: Math.max(0, root.holeH)
                radius: Math.max(0, Math.min(root.holeR, width / 2, height / 2))
                color: "#ffffffff"
            }
        }

        MultiEffect {
            anchors.fill: parent
            source: dimFill
            maskEnabled: true
            maskSource: holeMask
            maskInverted: true
        }

        // Focus ring around the hole
        Rectangle {
            id: focusRing
            x: root.holeX - 2
            y: root.holeY - 2
            width: Math.max(0, root.holeW + 4)
            height: Math.max(0, root.holeH + 4)
            radius: Math.max(0, root.holeR + 2)
            color: "transparent"
            border.width: 2
            border.color: Md3Theme.colorScheme.primary
            opacity: root.holeW > 1 ? 1 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onClicked: { /* block */ }
            onWheel: function (w) { w.accepted = true }
        }
    }

    // Tooltip card
    property real _cardX: 16
    property real _cardY: 16

    function _placeCard() {
        const place = currentStep && currentStep.placement ? String(currentStep.placement) : "auto"
        const cw = card.width
        const ch = card.height
        let x = root.holeX + root.holeW / 2 - cw / 2
        let y = root.holeY + root.holeH + 12
        if (place === "left") {
            x = root.holeX - cw - 12
            y = root.holeY
        } else if (place === "right") {
            x = root.holeX + root.holeW + 12
            y = root.holeY
        } else if (place === "top") {
            y = root.holeY - ch - 12
        } else {
            // auto: prefer below, else above
            if (y + ch + 16 > root.height)
                y = root.holeY - ch - 12
        }
        _cardX = Math.max(16, Math.min(root.width - cw - 16, x))
        _cardY = Math.max(16, Math.min(root.height - ch - 16, y))
    }

    onHoleXChanged: _placeCard()
    onHoleYChanged: _placeCard()
    onHoleWChanged: _placeCard()
    onHoleHChanged: _placeCard()
    onWidthChanged: _placeCard()
    onHeightChanged: _placeCard()

    Behavior on _cardX {
        NumberAnimation {
            duration: root.transitionDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }
    Behavior on _cardY {
        NumberAnimation {
            duration: root.transitionDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }

    SequentialAnimation {
        id: cardPulse
        PropertyAction { target: card; property: "opacity"; value: 0 }
        PropertyAction { target: card; property: "scale"; value: 0.94 }
        ParallelAnimation {
            NumberAnimation {
                target: card
                property: "opacity"
                to: 1
                duration: Md3Motion.short4
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasizedDecelerate
            }
            NumberAnimation {
                target: card
                property: "scale"
                to: 1
                duration: Md3Motion.medium2
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasizedDecelerate
            }
        }
    }

    Rectangle {
        id: card
        z: 2
        x: root._cardX
        y: root._cardY
        width: Math.min(320, parent.width - 32)
        height: cardCol.implicitHeight + 24
        radius: Md3Theme.shape.large
        color: Md3Theme.colorScheme.surfaceContainerHigh
        border.width: 1
        border.color: Md3Theme.colorScheme.outlineVariant
        transformOrigin: Item.TopLeft
        opacity: 1
        scale: 1

        Accessible.role: Accessible.Dialog
        Accessible.name: root.currentStep && root.currentStep.title ? root.currentStep.title : qsTr("引导")
        Accessible.description: root.currentStep && root.currentStep.body ? root.currentStep.body : ""

        Md3Shadow {
            anchors.fill: parent
            elevation: 3
            cornerRadius: parent.radius
        }

        Column {
            id: cardCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 16
            spacing: 10

            Text {
                width: parent.width
                text: root.currentStep && root.currentStep.title ? root.currentStep.title : ""
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.titleMedium.size
                font.weight: Font.Medium
                wrapMode: Text.Wrap
            }
            Text {
                width: parent.width
                text: root.currentStep && root.currentStep.body ? root.currentStep.body : ""
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyMedium.size
                wrapMode: Text.Wrap
            }
            Text {
                text: qsTr("%1 / %2").arg(root.currentIndex + 1).arg(root.steps ? root.steps.length : 0)
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.labelSmall.size
            }
            Item {
                width: parent.width
                height: 40
                Row {
                    anchors.right: parent.right
                    spacing: 8
                    Md3Button {
                        text: qsTr("跳过")
                        variant: Md3Button.Text
                        onClicked: root.stop(false)
                    }
                    Md3Button {
                        text: qsTr("上一步")
                        variant: Md3Button.Outlined
                        enabled: root.currentIndex > 0
                        onClicked: root.previous()
                    }
                    Md3Button {
                        text: root.currentIndex + 1 >= (root.steps ? root.steps.length : 0)
                               ? qsTr("完成") : qsTr("下一步")
                        variant: Md3Button.Filled
                        onClicked: root.next()
                    }
                }
            }
        }

        onHeightChanged: root._placeCard()
        onWidthChanged: root._placeCard()
    }
}

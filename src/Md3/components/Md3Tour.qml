import QtQuick
import QtQuick.Window

/// Guided tour overlay: spotlight + card over a sequence of targets.
Item {
    id: root
    anchors.fill: parent
    visible: active
    z: 100000

    property bool active: false
    property int currentIndex: 0
    /// [{ target: Item, title, body, placement: "bottom"|"top"|"left"|"right"|"auto" }]
    property var steps: []
    property bool persistCompleted: true
    property string completedKey: "tour/completed"

    signal finished()
    signal skipped()
    signal stepChanged(int index)

    readonly property var currentStep: {
        if (!steps || currentIndex < 0 || currentIndex >= steps.length)
            return null
        return steps[currentIndex]
    }

    readonly property Item currentTarget: {
        const s = currentStep
        return (s && s.target) ? s.target : null
    }

    function start(at) {
        currentIndex = Math.max(0, at !== undefined ? at : 0)
        if (!steps || steps.length === 0)
            return
        active = true
        stepChanged(currentIndex)
        _updateHole()
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
        stepChanged(currentIndex)
        _updateHole()
    }

    function previous() {
        if (currentIndex <= 0)
            return
        currentIndex--
        stepChanged(currentIndex)
        _updateHole()
    }

    function _updateHole() {
        holeSync.restart()
    }

    Timer {
        id: holeSync
        interval: 16
        repeat: false
        onTriggered: hole.requestPaint()
    }

    onCurrentIndexChanged: _updateHole()
    onActiveChanged: if (active) _updateHole()

    // Dim with rectangular cutout approximated by 4 panels around the target.
    Item {
        id: scrim
        anchors.fill: parent

        property real hx: 0
        property real hy: 0
        property real hw: 0
        property real hh: 0
        property real pad: 8

        function refresh() {
            const t = root.currentTarget
            if (!t || !t.width) {
                hx = hy = 0
                hw = hh = 0
                return
            }
            const p = t.mapToItem(scrim, 0, 0)
            hx = p.x - pad
            hy = p.y - pad
            hw = t.width + pad * 2
            hh = t.height + pad * 2
        }

        Connections {
            target: root
            function onCurrentIndexChanged() { scrim.refresh(); hole.requestPaint() }
            function onActiveChanged() { if (root.active) { scrim.refresh(); hole.requestPaint() } }
        }

        Timer {
            running: root.active
            interval: 50
            repeat: true
            onTriggered: {
                scrim.refresh()
                hole.requestPaint()
            }
        }

        // Four dim panels form a hole
        Rectangle {
            color: Qt.rgba(0, 0, 0, 0.55)
            x: 0; y: 0; width: parent.width; height: Math.max(0, scrim.hy)
        }
        Rectangle {
            color: Qt.rgba(0, 0, 0, 0.55)
            x: 0; y: scrim.hy + scrim.hh
            width: parent.width
            height: Math.max(0, parent.height - (scrim.hy + scrim.hh))
        }
        Rectangle {
            color: Qt.rgba(0, 0, 0, 0.55)
            x: 0; y: scrim.hy; width: Math.max(0, scrim.hx); height: scrim.hh
        }
        Rectangle {
            color: Qt.rgba(0, 0, 0, 0.55)
            x: scrim.hx + scrim.hw; y: scrim.hy
            width: Math.max(0, parent.width - (scrim.hx + scrim.hw))
            height: scrim.hh
        }

        Rectangle {
            id: hole
            x: scrim.hx
            y: scrim.hy
            width: scrim.hw
            height: scrim.hh
            radius: Md3Theme.shape.medium
            color: "transparent"
            border.width: 2
            border.color: Md3Theme.colorScheme.primary
            function requestPaint() { scrim.refresh() }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: { /* block clicks through */ }
        }
    }

    Rectangle {
        id: card
        width: Math.min(320, parent.width - 32)
        height: cardCol.implicitHeight + 24
        radius: Md3Theme.shape.large
        color: Md3Theme.colorScheme.surfaceContainerHigh
        border.width: 1
        border.color: Md3Theme.colorScheme.outlineVariant
        z: 2

        x: {
            const s = root.currentStep
            const place = s && s.placement ? String(s.placement) : "auto"
            const cx = scrim.hx + scrim.hw / 2 - width / 2
            if (place === "left")
                return Math.max(16, scrim.hx - width - 12)
            if (place === "right")
                return Math.min(parent.width - width - 16, scrim.hx + scrim.hw + 12)
            return Math.max(16, Math.min(parent.width - width - 16, cx))
        }
        y: {
            const s = root.currentStep
            const place = s && s.placement ? String(s.placement) : "auto"
            if (place === "top")
                return Math.max(16, scrim.hy - height - 12)
            if (place === "left" || place === "right")
                return Math.max(16, Math.min(parent.height - height - 16, scrim.hy))
            // bottom / auto
            const below = scrim.hy + scrim.hh + 12
            if (below + height + 16 < parent.height)
                return below
            return Math.max(16, scrim.hy - height - 12)
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
    }

    Component.onCompleted: scrim.refresh()
}

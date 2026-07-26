import QtQuick

Item {
    id: root

    property real from: 0
    property real to: 1
    property real firstValue: 0.2
    property real secondValue: 0.8
    property real stepSize: 0
    property bool enabled: true
    property real trackHeight: 16
    /// Slim handle thickness along the track
    property real handleWidth: 4
    /// Handle length across track — taller than track thickness
    property real handleHeight: trackHeight + 16
    property string accessibleName: "Range slider"

    signal rangeChanged(real first, real second)

    height: Math.max(48, handleHeight + 16)
    implicitWidth: 240
    width: implicitWidth

    readonly property real span: Math.max(0.0001, to - from)
    readonly property color activeColor: enabled ? Md3Theme.colorScheme.primary
                                                 : Md3Theme.colorScheme.disabledContent()
    readonly property color inactiveColor: enabled ? Md3Theme.colorScheme.secondaryContainer
                                                   : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.12)

    function snap(v) {
        let next = Math.max(from, Math.min(to, v))
        if (stepSize > 0) {
            const steps = Math.round((next - from) / stepSize)
            next = from + steps * stepSize
        }
        return Math.max(from, Math.min(to, next))
    }

    function setFirst(v) {
        firstValue = Math.min(snap(v), secondValue)
        rangeChanged(firstValue, secondValue)
    }

    function setSecond(v) {
        secondValue = Math.max(snap(v), firstValue)
        rangeChanged(firstValue, secondValue)
    }

    function xFor(v) {
        const travel = Math.max(0, track.width - handleWidth)
        return track.x + ((v - from) / span) * travel
    }

    function valueFor(px) {
        const travel = Math.max(1, track.width - handleWidth)
        return from + ((px - track.x) / travel) * span
    }

    Item {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Math.max(4, root.handleWidth)
        anchors.rightMargin: Math.max(4, root.handleWidth)
        height: root.trackHeight

        readonly property real x0: ((root.firstValue - root.from) / root.span) * Math.max(0, width - root.handleWidth)
        readonly property real x1: ((root.secondValue - root.from) / root.span) * Math.max(0, width - root.handleWidth)

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: root.inactiveColor
        }

        Rectangle {
            x: track.x0 + root.handleWidth
            width: Math.max(0, track.x1 - track.x0 - root.handleWidth)
            height: parent.height
            radius: height / 2
            color: root.activeColor
        }
    }

    component Thumb: Rectangle {
        property real thumbValue: 0
        property bool isSecond: false
        width: root.handleWidth
        height: root.handleHeight
        radius: width / 2
        color: root.activeColor
        border.width: 0
        anchors.verticalCenter: parent.verticalCenter
        x: root.xFor(thumbValue)

        Md3Shadow {
            anchors.fill: parent
            elevation: root.enabled ? 1 : 0
            cornerRadius: parent.radius
        }

        MouseArea {
            anchors.fill: parent
            anchors.margins: -14
            enabled: root.enabled
            preventStealing: true
            onPositionChanged: function (mouse) {
                if (!pressed)
                    return
                const globalX = mapToItem(root, mouse.x, 0).x
                if (isSecond)
                    root.setSecond(root.valueFor(globalX))
                else
                    root.setFirst(root.valueFor(globalX))
            }
        }
    }

    Thumb { thumbValue: root.firstValue; isSecond: false }
    Thumb { thumbValue: root.secondValue; isSecond: true }
}

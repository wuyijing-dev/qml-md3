import QtQuick
import Md3

Item {
    id: root

    property alias text: input.text
    property string placeholderText: qsTr("Search")
    // Use Item.enabled (do not redeclare)
    /// When set, click / focus opens this Md3SearchView (forwards `text`).
    property var searchView: null
    property bool showClearButton: true

    signal accepted(string text)
    signal clicked()
    signal cleared()

    function openSearchView() {
        if (!searchView)
            return
        if (searchView.text !== undefined)
            searchView.text = text
        searchView.open = true
    }

    function clear() {
        input.clear()
        cleared()
    }

    width: parent ? Math.min(parent.width, 720) : 360
    height: 56

    Accessible.role: Accessible.EditableText
    Accessible.name: placeholderText.length ? placeholderText : qsTr("Search bar")

    Rectangle {
        id: field
        anchors.fill: parent
        radius: Md3Theme.shape.full
        color: Md3Theme.colorScheme.surfaceContainerHigh
        clip: true
        border.width: input.activeFocus ? 2 : 0
        border.color: Md3Theme.colorScheme.primary

        Behavior on border.width {
            enabled: !Md3Theme.reduceMotion
            NumberAnimation {
                duration: Md3Motion.short2
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }

        Md3StateOverlay {
            overlayColor: Md3Theme.colorScheme.colorOnSurface
            hovered: mouse.containsMouse
            pressed: mouse.pressed
            focused: input.activeFocus
            controlEnabled: root.enabled
            radius: parent.radius
        }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 8
            spacing: 12

            Md3Icon {
                icon: "search"
                size: 24
                iconColor: input.activeFocus ? Md3Theme.colorScheme.primary
                                             : Md3Theme.colorScheme.colorOnSurfaceVariant
                anchors.verticalCenter: parent.verticalCenter
                Behavior on iconColor {
                    ColorAnimation {
                        duration: Md3Motion.short2
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
            }

            TextInput {
                id: input
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 72 - (clearHit.visible ? 40 : 0)
                enabled: root.enabled
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyLarge.size
                onAccepted: root.accepted(text)
            }

            Item {
                id: clearHit
                visible: root.showClearButton && input.text.length > 0
                width: 40
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                Accessible.role: Accessible.Button
                Accessible.name: qsTr("Clear search")
                Accessible.onPressAction: root.clear()

                Md3Icon {
                    anchors.centerIn: parent
                    icon: "close"
                    size: 20
                    iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: root.enabled
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.clear()
                }
            }
        }
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 52
        anchors.verticalCenter: parent.verticalCenter
        text: root.placeholderText
        visible: opacity > 0.02
        opacity: (input.text.length === 0 && !input.activeFocus) ? 0.7 : 0
        color: Md3Theme.colorScheme.colorOnSurfaceVariant
        font: input.font
        z: 1
        Behavior on opacity {
            enabled: !Md3Theme.reduceMotion
            NumberAnimation {
                duration: Md3Motion.short2
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
    }

    Md3FocusRing {
        anchors.fill: parent
        anchors.margins: -3
        radius: Md3Theme.shape.full
        focused: input.activeFocus
        visualFocus: input.activeFocus
        controlEnabled: root.enabled
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        z: -1
        onClicked: {
            input.forceActiveFocus()
            root.openSearchView()
            root.clicked()
        }
    }
}

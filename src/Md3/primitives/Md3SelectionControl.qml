import QtQuick

/// Shared shell for selection controls such as Checkbox / Radio / Switch.
/// Subclasses provide the left-side chrome and handle `onActivated`.
Item {
    id: root

    property bool checked: false
    property string text: ""
    property string accessibleName: text.length ? text : qsTr("Selection control")
    property int accessibleRole: Accessible.CheckBox
    property real chromeWidth: 48
    property real labelSpacing: 12
    property int labelRole: Md3Text.BodyLarge

    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed

    signal activated()

    implicitWidth: text.length > 0 ? chromeWidth + labelSpacing + labelText.implicitWidth : chromeWidth
    implicitHeight: 48
    width: implicitWidth
    height: implicitHeight

    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: accessibleRole
    Accessible.checkable: true
    Accessible.checked: checked
    Accessible.onToggleAction: root.activate()

    function activate() {
        if (!enabled)
            return
        activated()
    }

    Keys.onSpacePressed: activate()
    Keys.onReturnPressed: activate()
    Keys.onEnterPressed: activate()

    Md3Text {
        id: labelText
        visible: root.text.length > 0
        anchors.left: parent.left
        anchors.leftMargin: root.chromeWidth + root.labelSpacing
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        text: root.text
        role: root.labelRole
        tone: root.enabled ? Md3Text.OnSurface : Md3Text.OnSurfaceVariant
        elide: Text.ElideRight
        opacity: root.enabled ? 1 : 0.38
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: root.enabled
        onClicked: {
            root.forceActiveFocus()
            root.activate()
        }
    }
}

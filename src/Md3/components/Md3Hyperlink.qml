import QtQuick
import Md3

/// Text hyperlink / WinUI HyperlinkButton. Optional `url` opens externally on click.
Md3AbstractButton {
    id: root

    property url url: ""
    /// When true and `url` is set, click calls Qt.openUrlExternally.
    property bool openExternally: true
    property bool underline: true

    accessibleName: text.length ? text : String(url)
    accessibleRole: Accessible.Link
    contentColor: enabled ? Md3Theme.colorScheme.primary
                          : Md3Theme.colorScheme.disabledContent()
    pressTarget: label
    onPressFeedback: function (x, y) { }

    implicitWidth: Math.max(24, label.implicitWidth + 8)
    implicitHeight: Math.max(32, label.implicitHeight + 8)
    width: implicitWidth
    height: implicitHeight

    onClicked: {
        if (openExternally && String(url).length > 0)
            Qt.openUrlExternally(url)
    }

    Md3Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        role: Md3Text.LabelLarge
        tone: Md3Text.Custom
        customColor: root.contentColor
        font.underline: root.underline && (root.hovered || root.activeFocus)
    }

    Md3StateOverlay {
        anchors.fill: parent
        overlayColor: root.contentColor
        hovered: root.hovered
        focused: root.activeFocus && root.visualFocus
        pressed: root.pressed
        controlEnabled: root.enabled
        radius: Md3Theme.shape.extraSmall
    }

    Md3FocusRing {
        anchors.fill: parent
        anchors.margins: -2
        radius: Md3Theme.shape.extraSmall + 2
        focused: root.activeFocus
        visualFocus: root.visualFocus
        controlEnabled: root.enabled
    }
}

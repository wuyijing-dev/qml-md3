import QtQuick
import QtQuick.Layouts
import Md3

/// Tab strip + optional content pages (WinUI Pivot-style). When `pages` has children,
/// a StackLayout tracks `currentIndex` — no host sync glue.
Item {
    id: root

    enum Variant { Primary, Secondary }

    property int variant: Md3TabBar.Primary
    property var model: []
    property int currentIndex: 0
    /// Content pages (synced with currentIndex). Prefer over external StackLayout.
    default property alias pages: pageStack.data
    /// Extra height for page area when `pages` are present (Layout / implicit).
    property real pageAreaHeight: 96
    /// When true with pages, height fills the parent (IDE pageHost). Strip stays 48px.
    property bool fillHeight: false

    signal currentIndexChangedByUser(int index)

    readonly property bool hasPages: pageStack.children.length > 0

    implicitWidth: 360
    implicitHeight: hasPages ? (48 + pageAreaHeight) : 48
    height: {
        if (fillHeight && parent && parent.height > 0)
            return parent.height
        return implicitHeight
    }
    // Do not bind height to parent.height unless fillHeight — that fights ColumnLayout.
    width: parent && parent.width > 0 ? parent.width : implicitWidth

    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Tab bar")
    activeFocusOnTab: true
    focus: true

    Keys.onPressed: function (event) {
        const n = (root.model && root.model.length) ? root.model.length : 0
        if (n <= 0)
            return
        if (event.key === Qt.Key_Left || event.key === Qt.Key_Up) {
            currentIndex = (currentIndex - 1 + n) % n
            currentIndexChangedByUser(currentIndex)
            event.accepted = true
        } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Down) {
            currentIndex = (currentIndex + 1) % n
            currentIndexChangedByUser(currentIndex)
            event.accepted = true
        } else if (event.key === Qt.Key_Home) {
            currentIndex = 0
            currentIndexChangedByUser(currentIndex)
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            currentIndex = n - 1
            currentIndexChangedByUser(currentIndex)
            event.accepted = true
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            id: tabStrip
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            Layout.maximumHeight: 48

            Row {
                id: row
                anchors.fill: parent
                Repeater {
                    model: root.model
                    delegate: Item {
                        required property int index
                        required property var modelData
                        width: Math.max(90, label.implicitWidth + 32)
                        height: parent.height
                        readonly property bool selected: root.currentIndex === index
                        readonly property string title: modelData.text !== undefined ? modelData.text
                                                     : (modelData.label !== undefined ? modelData.label
                                                     : String(modelData))

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            radius: Md3Theme.shape.small
                            color: tabMouse.containsMouse && !selected
                                   ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.06)
                                   : "transparent"
                            Behavior on color {
                                ColorAnimation {
                                    duration: Md3Motion.short2
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Md3Motion.standard
                                }
                            }
                        }

                        Text {
                            id: label
                            anchors.centerIn: parent
                            text: title
                            color: selected ? Md3Theme.colorScheme.primary : Md3Theme.colorScheme.colorOnSurfaceVariant
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.titleSmall.size
                            font.weight: Font.Medium
                        }

                        MouseArea {
                            id: tabMouse
                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                root.currentIndex = index
                                root.currentIndexChangedByUser(index)
                            }
                        }
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                height: root.variant === Md3TabBar.Primary ? 3 : 2
                radius: root.variant === Md3TabBar.Primary ? 3 : 0
                color: Md3Theme.colorScheme.primary
                width: row.children.length > root.currentIndex ? Math.max(24, row.children[root.currentIndex].width - 32) : 24
                x: {
                    if (row.children.length <= root.currentIndex)
                        return 0
                    const item = row.children[root.currentIndex]
                    return item.x + (item.width - width) / 2
                }

                Behavior on x {
                    NumberAnimation {
                        duration: Md3Motion.spatialSnapDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
                    }
                }
                Behavior on width {
                    NumberAnimation {
                        duration: Md3Motion.spatialSnapDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: Md3Theme.colorScheme.surfaceContainerHighest
                z: -1
            }
        }

        StackLayout {
            id: pageStack
            visible: root.hasPages
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.currentIndex
        }
    }
}

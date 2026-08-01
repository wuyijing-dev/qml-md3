import QtQuick
import Md3

Item {
    id: root

    property var model: [] // [{ text, icon?, enabled? }]
    property int currentIndex: 0
    property bool multiSelect: false
    property var selectedIndices: []

    signal selectionChanged()

    readonly property real segmentHeight: Md3Theme.controlHeight
    readonly property real outerRadius: segmentHeight / 2

    implicitHeight: Math.max(48, segmentHeight + 8)
    implicitWidth: row.implicitWidth
    height: implicitHeight
    width: implicitWidth

    function isSelected(index) {
        if (multiSelect)
            return selectedIndices.indexOf(index) !== -1
        return currentIndex === index
    }

    function toggle(index) {
        if (!enabled)
            return
        const item = model[index]
        if (item && item.enabled === false)
            return

        if (multiSelect) {
            const copy = selectedIndices.slice()
            const pos = copy.indexOf(index)
            if (pos === -1)
                copy.push(index)
            else
                copy.splice(pos, 1)
            selectedIndices = copy
        } else {
            currentIndex = index
        }
        selectionChanged()
    }

    Rectangle {
        id: frame
        anchors.verticalCenter: parent.verticalCenter
        width: row.width
        height: root.segmentHeight
        radius: root.outerRadius
        color: "transparent"
        border.width: 1
        border.color: root.enabled ? Md3Theme.colorScheme.outline
                                   : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.outline, 0.12)

        Row {
            id: row
            height: parent.height

            Repeater {
                model: root.model

                delegate: Item {
                    id: seg
                    required property int index
                    required property var modelData

                    readonly property string label: modelData.text !== undefined ? modelData.text : String(modelData)
                    readonly property string iconName: modelData.icon !== undefined ? modelData.icon : ""
                    readonly property bool segEnabled: root.enabled && (modelData.enabled !== false)
                    readonly property bool selected: root.isSelected(index)
                    readonly property bool isFirst: index === 0
                    readonly property bool isLast: index === root.model.length - 1

                    width: Math.max(48, contentRow.implicitWidth + 24)
                    height: parent.height
                    activeFocusOnTab: seg.segEnabled
                    scale: segMouse.pressed ? 0.96 : 1.0
                    Behavior on scale {
                        enabled: !Md3Theme.reduceMotion
                        NumberAnimation {
                            duration: Md3Motion.short2
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Md3Motion.standard
                        }
                    }
                    Keys.onReturnPressed: function (event) {
                        root.toggle(seg.index)
                        event.accepted = true
                    }
                    Keys.onEnterPressed: function (event) {
                        root.toggle(seg.index)
                        event.accepted = true
                    }
                    Keys.onSpacePressed: function (event) {
                        root.toggle(seg.index)
                        event.accepted = true
                    }

                    Rectangle {
                        id: segFill
                        anchors.fill: parent
                        // End segments keep stadium outer corners (MD3)
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
                                easing.bezierCurve: Md3Motion.uiSpatial
                            }
                        }

                        Md3StateOverlay {
                            overlayColor: seg.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                       : Md3Theme.colorScheme.colorOnSurface
                            hovered: segMouse.containsMouse
                            pressed: segMouse.pressed
                            focused: seg.activeFocus
                            controlEnabled: seg.segEnabled
                            topLeftRadius: segFill.topLeftRadius
                            bottomLeftRadius: segFill.bottomLeftRadius
                            topRightRadius: segFill.topRightRadius
                            bottomRightRadius: segFill.bottomRightRadius
                        }

                        Row {
                            id: contentRow
                            anchors.centerIn: parent
                            spacing: 8

                            Md3Icon {
                                visible: root.multiSelect && seg.selected
                                icon: "check"
                                size: 18
                                iconColor: seg.segEnabled ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                          : Md3Theme.colorScheme.disabledContent()
                                anchors.verticalCenter: parent.verticalCenter
                                opacity: visible ? 1 : 0
                                Behavior on opacity {
                                    NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
                                }
                            }

                            Md3Icon {
                                visible: seg.iconName.length > 0
                                icon: seg.iconName
                                size: 18
                                iconColor: {
                                    if (!seg.segEnabled)
                                        return Md3Theme.colorScheme.disabledContent()
                                    return seg.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                        : Md3Theme.colorScheme.colorOnSurface
                                }
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Md3Text {
                                text: seg.label
                                role: Md3Text.LabelLarge
                                tone: Md3Text.Custom
                                customColor: {
                                    if (!seg.segEnabled)
                                        return Md3Theme.colorScheme.disabledContent()
                                    return seg.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                        : Md3Theme.colorScheme.colorOnSurface
                                }
                                font.pixelSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)
                                font.weight: Md3Theme.typography.labelLarge.weight
                                anchors.verticalCenter: parent.verticalCenter
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
                        onClicked: root.toggle(seg.index)
                    }

                    Accessible.name: seg.label
                    Accessible.role: Accessible.Button
                    Accessible.checkable: true
                    Accessible.checked: seg.selected
                }
            }
        }
    }
}

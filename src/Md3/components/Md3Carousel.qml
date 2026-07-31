import QtQuick
import QtQuick.Layouts
import Md3

// Material 3 hero / multi-browse carousel with peek of the next item.
Item {
    id: root

    enum Mode { MultiBrowse, Flip }

    property var model: [] // [{ title, subtitle?, color?, source? }]
    property int currentIndex: 0
    property int mode: Md3Carousel.MultiBrowse
    property real itemHeight: 168
    /// Fraction of next item visible (peek). Ignored in Flip mode.
    property real peekRatio: 0.12
    property real spacing: 12
    property bool showIndicators: true
    property int indicatorStyle: Md3PipsPager.Pill
    property bool autoPlay: false
    property int autoPlayInterval: 4000
    property bool wrap: true
    /// Shadow bleed around each card so elevation is not clipped.
    property real shadowPad: 10

    signal indexChangedByUser(int index)
    signal itemClicked(int index)

    implicitWidth: parent ? parent.width : 400
    implicitHeight: itemHeight + shadowPad * 2 + (showIndicators ? 28 : 0)
    height: implicitHeight
    width: implicitWidth

    Accessible.role: Accessible.List
    Accessible.name: qsTr("Carousel")

    readonly property real _peek: mode === Md3Carousel.Flip ? 0 : peekRatio
    readonly property real _spacing: mode === Md3Carousel.Flip ? 0 : spacing
    readonly property real pageWidth: Math.max(120, width * (1 - _peek) - _spacing)

    onCurrentIndexChanged: {
        if (view.currentIndex !== currentIndex && currentIndex >= 0
                && currentIndex < view.count)
            view.currentIndex = currentIndex
    }

    function goTo(index) {
        if (!model || model.length === 0)
            return
        let i = index
        if (wrap) {
            const n = model.length
            i = ((i % n) + n) % n
        } else {
            i = Math.max(0, Math.min(model.length - 1, i))
        }
        currentIndex = i
        view.currentIndex = i
    }

    function next() { goTo(currentIndex + 1) }
    function previous() { goTo(currentIndex - 1) }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        ListView {
            id: view
            Layout.fillWidth: true
            Layout.preferredHeight: root.itemHeight + root.shadowPad * 2
            orientation: ListView.Horizontal
            spacing: root._spacing
            // Keep horizontal clip; vertical shadow bleed stays inside preferredHeight.
            clip: true
            model: root.model
            snapMode: ListView.SnapOneItem
            highlightRangeMode: ListView.StrictlyEnforceRange
            preferredHighlightBegin: 0
            preferredHighlightEnd: root.pageWidth
            highlightMoveDuration: Md3Motion.spatialDuration
            highlightMoveVelocity: -1
            boundsBehavior: Flickable.StopAtBounds
            currentIndex: root.currentIndex
            displayMarginBeginning: root.mode === Md3Carousel.Flip ? 0 : root.shadowPad
            displayMarginEnd: root.mode === Md3Carousel.Flip ? 0 : root.shadowPad

            onCurrentIndexChanged: {
                if (root.currentIndex !== currentIndex) {
                    root.currentIndex = currentIndex
                    root.indexChangedByUser(currentIndex)
                }
            }

            delegate: Item {
                id: delegateRoot
                required property int index
                required property var modelData
                width: root.pageWidth
                height: root.itemHeight + (root.mode === Md3Carousel.Flip ? 0 : root.shadowPad * 2)

                readonly property bool selected: ListView.isCurrentItem
                readonly property real elev: root.mode === Md3Carousel.Flip ? 0 : (selected ? 2 : 1)

                // Soft approach — no opacity dimming (reads as a fake shadow).
                scale: root.mode === Md3Carousel.Flip ? 1 : (selected ? 1 : 0.985)
                transformOrigin: Item.Center
                Behavior on scale {
                    NumberAnimation {
                        duration: Md3Motion.spatialSnapDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
                    }
                }
                z: selected ? 2 : 1

                Item {
                    id: cardHost
                    anchors.fill: parent
                    anchors.margins: root.mode === Md3Carousel.Flip ? 0 : root.shadowPad

                    Md3Shadow {
                        anchors.fill: card
                        elevation: delegateRoot.elev
                        cornerRadius: card.radius
                        visible: root.mode !== Md3Carousel.Flip
                    }

                    Rectangle {
                        id: card
                        anchors.fill: parent
                        radius: root.mode === Md3Carousel.Flip ? 0 : Md3Theme.shape.extraLarge
                        color: {
                            if (delegateRoot.modelData.color !== undefined)
                                return delegateRoot.modelData.color
                            return Md3Theme.colorScheme.primaryContainer
                        }
                        clip: true

                        Image {
                            anchors.fill: parent
                            visible: delegateRoot.modelData.source !== undefined
                                     && String(delegateRoot.modelData.source).length > 0
                            source: delegateRoot.modelData.source !== undefined
                                    ? delegateRoot.modelData.source : ""
                            fillMode: Image.PreserveAspectCrop
                        }

                        // Bottom scrim for title contrast only (not a drop shadow).
                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: Math.min(88, parent.height * 0.42)
                            gradient: Gradient {
                                GradientStop { position: 0; color: "transparent" }
                                GradientStop {
                                    position: 1
                                    color: Qt.alpha(Md3Theme.colorScheme.scrim, 0.38)
                                }
                            }
                        }

                        Column {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 16
                            spacing: 4

                            Text {
                                width: parent.width
                                text: delegateRoot.modelData.title !== undefined
                                      ? delegateRoot.modelData.title : ""
                                color: "#FFFFFF"
                                font.pixelSize: Md3Theme.typography.titleLarge.size
                                font.family: Md3Theme.typography.fontFamily
                                font.weight: Font.Medium
                                elide: Text.ElideRight
                            }
                            Text {
                                width: parent.width
                                visible: text.length > 0
                                text: delegateRoot.modelData.subtitle !== undefined
                                      ? delegateRoot.modelData.subtitle : ""
                                color: Qt.rgba(1, 1, 1, 0.85)
                                font.pixelSize: Md3Theme.typography.bodyMedium.size
                                font.family: Md3Theme.typography.fontFamily
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                            anchors.fill: parent
                            onClicked: {
                                if (view.currentIndex !== delegateRoot.index)
                                    root.goTo(delegateRoot.index)
                                else
                                    root.itemClicked(delegateRoot.index)
                            }
                        }
                    }
                }
            }
        }

        Md3PipsPager {
            Layout.alignment: Qt.AlignHCenter
            visible: root.showIndicators && root.model && root.model.length > 1
            count: root.model ? root.model.length : 0
            currentIndex: root.currentIndex
            style: root.indicatorStyle
            onIndexRequested: function (index) { root.goTo(index) }
        }
    }

    Timer {
        running: root.autoPlay && root.model && root.model.length > 1
        interval: root.autoPlayInterval
        repeat: true
        onTriggered: root.next()
    }
}

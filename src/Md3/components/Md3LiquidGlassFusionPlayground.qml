import QtQuick
import QtQuick.Effects
import Md3

/// EXPERIMENTAL: Liquid Glass fusion demo API may change.
/// Two draggable glass bodies rendered in one fused SDF pass (real metaball merge).
Item {
    id: root

    property Item sourceItem: null
    property real fusionStrength: 0.14
    property real squircleN: 5.0
    property int quality: 2
    property int dragCount: 0
    property bool liveSampling: true
    property real samplePadding: 28

    readonly property real playgroundAspect: width / Math.max(1, height)
    readonly property real _pad: samplePadding
    readonly property real _texScale: quality >= 2 ? 1.0 : 0.65

    implicitWidth: 720
    implicitHeight: 420
    clip: true

    function _bodyFromRect(x, y, w, h) {
        return Qt.vector4d((x + w * 0.5) / root.width,
                             (y + h * 0.5) / root.height,
                             Math.max(0.08, w * 0.5 / root.width),
                             Math.max(0.08, h * 0.5 / root.height))
    }

    readonly property vector4d mergeA: _bodyFromRect(blobA.x, blobA.y, blobA.width, blobA.height)
    readonly property vector4d mergeB: _bodyFromRect(blobB.x, blobB.y, blobB.width, blobB.height)

    Item {
        id: backdropHost
        anchors.fill: parent
        visible: root.sourceItem === null

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FF6B4A" }
                GradientStop { position: 0.35; color: "#7C4DFF" }
                GradientStop { position: 0.7; color: "#00BCD4" }
                GradientStop { position: 1.0; color: "#FFD54F" }
            }
        }

        Repeater {
            model: [
                { t: "Md3", x: 0.08, y: 0.12, s: 42 },
                { t: "Fusion", x: 0.52, y: 0.18, s: 36 },
                { t: "SDF", x: 0.22, y: 0.62, s: 48 },
                { t: "Glass", x: 0.68, y: 0.55, s: 40 }
            ]
            delegate: Md3Text {
                required property var modelData
                x: modelData.x * backdropHost.width
                y: modelData.y * backdropHost.height
                text: modelData.t
                role: Md3Text.DisplaySmall
                tone: Md3Text.Custom
                customColor: Qt.rgba(1, 1, 1, 0.95)
                font.pixelSize: modelData.s
                font.weight: Font.Bold
            }
        }

        Repeater {
            model: 5
            delegate: Rectangle {
                required property int index
                width: 72 + (index % 2) * 28
                height: width
                radius: width / 2
                x: 24 + (index * 118) % Math.max(60, backdropHost.width - width - 24)
                y: 24 + (index * 73) % Math.max(60, backdropHost.height - height - 24)
                color: Qt.rgba(1, 1, 1, 0.14)
                border.width: 2
                border.color: Qt.rgba(1, 1, 1, 0.35)
            }
        }
    }

    readonly property Item _backdrop: sourceItem ? sourceItem : backdropHost

    Item {
        id: fusedLayer
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: true
        layer.samples: 2
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: fieldMask
            autoPaddingEnabled: false
        }

        ShaderEffectSource {
            id: regionSample
            width: Math.max(2, Math.round((root.width + root._pad * 2) * root._texScale))
            height: Math.max(2, Math.round((root.height + root._pad * 2) * root._texScale))
            x: -root._pad
            y: -root._pad
            visible: false
            live: root.liveSampling || root.dragCount > 0
            hideSource: false
            smooth: true
            sourceItem: root._backdrop
            sourceRect: {
                if (!root._backdrop || root._backdrop === backdropHost)
                    return Qt.rect(-root._pad, -root._pad, root.width + root._pad * 2, root.height + root._pad * 2)
                void root.width
                void root.height
                void root._pad
                const pad = root._pad
                const p = root.mapToItem(root._backdrop, -pad, -pad)
                return Qt.rect(p.x, p.y, root.width + pad * 2, root.height + pad * 2)
            }
        }

        ShaderEffect {
            anchors.fill: parent
            property variant source: regionSample
            property real bend: 1.2
            property real frost: 0.004
            property real chroma: 0.5
            property real radiusNorm: 0.22
            property real aspect: root.playgroundAspect
            property real padU: root._pad / Math.max(1, root.width + root._pad * 2)
            property real padV: root._pad / Math.max(1, root.height + root._pad * 2)
            property real squircleN: root.squircleN
            property real thickness: 1.0
            property real adaptive: 0.85
            property real baseTint: 0.08
            property real quality: root.quality
            property real fusion: 0.0
            property real fusionK: root.fusionStrength
            property vector4d mergeA: root.mergeA
            property vector4d mergeB: root.mergeB
            property vector4d dropA: Qt.vector4d(0, 0, 0, 0)
            property vector4d dropB: Qt.vector4d(0, 0, 0, 0)
            property vector4d dropC: Qt.vector4d(0, 0, 0, 0)
            property real edgeSpectral: 0.7
            property real sceneColor: 0.12
            vertexShader: "qrc:/qt/qml/Md3/shaders/md3liquidglass.vert.qsb"
            fragmentShader: "qrc:/qt/qml/Md3/shaders/md3liquidglass.frag.qsb"
        }
    }

    Item {
        id: fieldMask
        anchors.fill: parent
        visible: false
        layer.enabled: true
        ShaderEffect {
            anchors.fill: parent
            property real aspect: root.playgroundAspect
            property real squircleN: root.squircleN
            property real soft: 0.016
            property real fusion: 0.0
            property real fusionK: root.fusionStrength
            property vector4d mergeA: root.mergeA
            property vector4d mergeB: root.mergeB
            property vector4d dropA: Qt.vector4d(0, 0, 0, 0)
            property vector4d dropB: Qt.vector4d(0, 0, 0, 0)
            property vector4d dropC: Qt.vector4d(0, 0, 0, 0)
            vertexShader: "qrc:/qt/qml/Md3/shaders/md3liquidglass_mask.vert.qsb"
            fragmentShader: "qrc:/qt/qml/Md3/shaders/md3liquidglass_mask.frag.qsb"
        }
    }

    component Blob: Item {
        id: blob
        property string label: ""
        property real _grabX: 0
        property real _grabY: 0

        width: 168
        height: 112
        z: dragArea.pressed ? 30 : 10

        function clampPos(nx, ny) {
            const maxX = Math.max(0, root.width - width)
            const maxY = Math.max(0, root.height - height)
            x = Math.max(0, Math.min(maxX, nx))
            y = Math.max(0, Math.min(maxY, ny))
        }

        Md3Text {
            anchors.centerIn: parent
            text: blob.label
            role: Md3Text.TitleMedium
            tone: Md3Text.Custom
            customColor: Qt.rgba(1, 1, 1, 0.95)
            font.weight: Font.DemiBold
        }

        MouseArea {
            id: dragArea
            anchors.fill: parent
            cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
            preventStealing: pressed
            onPressed: function (mouse) {
                blob._grabX = mouse.x
                blob._grabY = mouse.y
                root.dragCount++
            }
            onReleased: root.dragCount = Math.max(0, root.dragCount - 1)
            onCanceled: root.dragCount = Math.max(0, root.dragCount - 1)
            onPositionChanged: function (mouse) {
                if (!pressed)
                    return
                blob.clampPos(blob.x + mouse.x - blob._grabX, blob.y + mouse.y - blob._grabY)
            }
        }
    }

    Blob {
        id: blobA
        label: qsTr("Glass A")
        x: 48
        y: 96
    }

    Blob {
        id: blobB
        label: qsTr("Glass B")
        x: 360
        y: 180
    }
}

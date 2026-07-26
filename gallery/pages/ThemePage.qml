import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true

    LayoutMirroring.enabled: rtlSwitch.checked
    LayoutMirroring.childrenInherit: true

    QtObject {
        id: seedDraft
        property real hue: Md3Theme.seed.hslHue
        property real chroma: Math.max(0.15, Math.min(0.75, Md3Theme.seed.hslSaturation))
    }
    // Windows: full-scheme apply every mouse move recolors the whole app + MultiEffects → huge CPU.
    Timer {
        id: seedApplyTimer
        interval: 50
        repeat: false
        onTriggered: Md3Theme.applySeed(Qt.hsla(seedDraft.hue, seedDraft.chroma, 0.40, 1))
    }

    component Swatch: Rectangle {
        property string roleName: ""
        property color roleColor: "transparent"
        property color labelColor: Md3Theme.colorScheme.colorOnSurface
        Layout.fillWidth: true
        Layout.preferredHeight: 56
        radius: Md3Theme.shape.medium
        color: roleColor
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: roleName
            color: parent.labelColor
            font.pixelSize: Md3Theme.typography.labelLarge.size
            font.family: Md3Theme.typography.fontFamily
        }
    }

    ColumnLayout {
        id: column
        width: root.width
        spacing: 20

        Text {
            text: qsTr("Theme")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            text: qsTr("Dynamic color from seed (Material You tonal roles)")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }

        Md3WindowHelper { id: winNative }

        RowLayout {
            spacing: 12
            Md3Button {
                id: themeSwitchBtn
                text: Md3Theme.dark ? qsTr("Switch to light") : qsTr("Switch to dark")
                onClicked: {
                    const w = Window.window
                    if (w && typeof w.toggleThemeFrom === "function")
                        w.toggleThemeFrom(themeSwitchBtn)
                    else
                        Md3Theme.toggleDark()
                }
            }
            Md3Button {
                visible: winNative.systemAccentSupported
                text: qsTr("System accent")
                variant: Md3Button.FilledTonal
                onClicked: Md3Theme.applySeed(winNative.systemAccentColor())
            }
            Md3Button {
                visible: winNative.systemAccentSupported
                text: qsTr("From wallpaper")
                variant: Md3Button.Outlined
                onClicked: Md3Theme.applySeed(winNative.wallpaperSeedColor())
            }
        }

        Text {
            text: qsTr("Live hue / chroma")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Text {
                text: qsTr("Hue")
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
            }
            Md3Slider {
                id: hueSlider
                Layout.fillWidth: true
                from: 0
                to: 1
                value: Md3Theme.seed.hslHue
                showStopIndicator: false
                onMoved: function (v) {
                    seedDraft.hue = v
                    seedDraft.chroma = chromaSlider.value
                    seedApplyTimer.restart()
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Text {
                text: qsTr("Chroma")
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
            }
            Md3Slider {
                id: chromaSlider
                Layout.fillWidth: true
                from: 0.15
                to: 0.75
                value: Math.max(0.15, Math.min(0.75, Md3Theme.seed.hslSaturation))
                showStopIndicator: false
                onMoved: function (v) {
                    seedDraft.hue = hueSlider.value
                    seedDraft.chroma = v
                    seedApplyTimer.restart()
                }
            }
        }

        Text {
            text: qsTr("Seed presets")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        Flow {
            Layout.fillWidth: true
            spacing: 8
            Repeater {
                model: [
                    { label: qsTr("Purple"), color: "#6750A4" },
                    { label: qsTr("Teal"), color: "#006A6A" },
                    { label: qsTr("Orange"), color: "#8B5000" },
                    { label: qsTr("Blue"), color: "#195D9C" },
                    { label: qsTr("Green"), color: "#2E6B32" },
                    { label: qsTr("Rose"), color: "#A33B5A" },
                    { label: qsTr("Slate"), color: "#4A5C6A" }
                ]
                delegate: Md3Button {
                    required property var modelData
                    text: modelData.label
                    variant: Md3Button.Outlined
                    onClicked: Md3Theme.applySeed(modelData.color)
                }
            }
        }

        Text {
            text: qsTr("Live roles")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 8
            rowSpacing: 8

            Swatch {
                roleName: "primary"
                roleColor: Md3Theme.colorScheme.primary
                labelColor: Md3Theme.colorScheme.colorOnPrimary
            }
            Swatch {
                roleName: "primaryContainer"
                roleColor: Md3Theme.colorScheme.primaryContainer
                labelColor: Md3Theme.colorScheme.colorOnPrimaryContainer
            }
            Swatch {
                roleName: "secondary"
                roleColor: Md3Theme.colorScheme.secondary
                labelColor: Md3Theme.colorScheme.colorOnSecondary
            }
            Swatch {
                roleName: "secondaryContainer"
                roleColor: Md3Theme.colorScheme.secondaryContainer
                labelColor: Md3Theme.colorScheme.colorOnSecondaryContainer
            }
            Swatch {
                roleName: "tertiary"
                roleColor: Md3Theme.colorScheme.tertiary
                labelColor: Md3Theme.colorScheme.colorOnTertiary
            }
            Swatch {
                roleName: "tertiaryContainer"
                roleColor: Md3Theme.colorScheme.tertiaryContainer
                labelColor: Md3Theme.colorScheme.colorOnTertiaryContainer
            }
            Swatch {
                roleName: "surface"
                roleColor: Md3Theme.colorScheme.surface
                labelColor: Md3Theme.colorScheme.colorOnSurface
            }
            Swatch {
                roleName: "surfaceContainer"
                roleColor: Md3Theme.colorScheme.surfaceContainer
                labelColor: Md3Theme.colorScheme.colorOnSurface
            }
            Swatch {
                roleName: "error"
                roleColor: Md3Theme.colorScheme.error
                labelColor: Md3Theme.colorScheme.colorOnError
            }
            Swatch {
                roleName: "outline"
                roleColor: Md3Theme.colorScheme.outline
                labelColor: Md3Theme.colorScheme.colorOnPrimary
            }
        }

        Text {
            text: qsTr("Controls on dynamic scheme")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }

        RowLayout {
            spacing: 12
            Md3Button { text: qsTr("Filled") }
            Md3Button { text: qsTr("Tonal"); variant: Md3Button.FilledTonal }
            Md3Button { text: qsTr("Outlined"); variant: Md3Button.Outlined }
            Md3Fab { icon: "add" }
        }

        RowLayout {
            spacing: 16
            Md3Switch { }
            Md3Switch { checked: true }
            Md3Switch { checked: true; showIcon: true }
            Md3Checkbox { checked: true }
            Md3Checkbox { }
            Md3Radio { checked: true; accessibleName: "A" }
            Md3Radio { accessibleName: "B" }
        }

        Md3Slider {
            Layout.fillWidth: true
            from: 0
            to: 100
            value: 62
            trackHeight: 20
            handleWidth: 10
        }

        Md3FilterChip {
            text: qsTr("Filter chip")
            selected: true
        }

        RowLayout {
            spacing: 12
            Text {
                text: qsTr("Text scale")
                color: Md3Theme.colorScheme.colorOnSurface
            }
            Md3Button {
                text: "100%"
                variant: Md3Button.Text
                onClicked: Md3Theme.textScale = 1.0
            }
            Md3Button {
                text: "125%"
                variant: Md3Button.Text
                onClicked: Md3Theme.textScale = 1.25
            }
            Md3Button {
                text: "150%"
                variant: Md3Button.Text
                onClicked: Md3Theme.textScale = 1.5
            }
        }

        RowLayout {
            spacing: 12
            Text {
                text: qsTr("RTL preview")
                color: Md3Theme.colorScheme.colorOnSurface
            }
            Md3Switch {
                id: rtlSwitch
            }
            Text {
                text: qsTr("LayoutMirroring on this page")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodySmall.size
            }
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("seed=%1  dark=%2  primary=%3")
                  .arg(Md3Theme.seed)
                  .arg(Md3Theme.dark)
                  .arg(Md3Theme.colorScheme.primary)
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }
    }
}

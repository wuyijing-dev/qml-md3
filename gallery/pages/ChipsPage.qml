import QtQuick
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.implicitHeight
    clip: true

    property bool md3PageActive: true

    Md3VStack {
        id: column
        width: root.width
        spacing: 16

        Md3Text {
            text: "Chips"
            role: Md3Text.HeadlineMedium
        }

        Md3Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: "ChipGroup keeps chips as one layout unit — in Md3AnimatedFlow / title bar it moves with spatial easing when the row wraps."
            role: Md3Text.BodyMedium
            tone: Md3Text.OnSurfaceVariant
        }

        Md3Text {
            text: "Chip group (single)"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3ChipGroup {
            selectionMode: Md3ChipGroup.Single
            currentIndex: 1
            model: [
                { text: "News", icon: "newspaper" },
                { text: "Maps", icon: "map" },
                { text: "Images", icon: "image" }
            ]
        }

        Md3Text {
            text: "Chip group (multiple)"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3ChipGroup {
            selectionMode: Md3ChipGroup.Multiple
            selectedIndices: [0, 2]
            model: [
                { text: "Filter A" },
                { text: "Filter B" },
                { text: "Filter C" },
                { text: "Filter D" }
            ]
        }

        Md3Text {
            text: "Animated flow (resize window / narrow the pane)"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3AnimatedFlow {
            width: parent.width
            spacing: 8
            rowSpacing: 8
            Md3ChipGroup {
                model: [
                    { text: "Alpha" },
                    { text: "Beta" },
                    { text: "Gamma" }
                ]
            }
            Md3ButtonGroup {
                layout: Md3ButtonGroup.Standard
                variant: Md3ButtonGroup.Outlined
                model: [
                    { text: "One" },
                    { text: "Two" },
                    { text: "Three" }
                ]
            }
            Md3AssistChip { text: "Assist"; icon: "edit" }
            Md3FilterChip { text: "Filter"; selected: true }
            Md3SuggestionChip { text: "Suggestion" }
            Md3InputChip {
                id: inputChipDemo
                text: "Input"
                avatarIcon: "person"
                onRemoved: inputChipDemo.text = "Removed"
            }
        }

        Md3Text {
            text: "Loose chips"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3AnimatedFlow {
            width: parent.width
            spacing: 8
            Md3AssistChip { text: "Assist"; icon: "edit" }
            Md3AssistChip { text: "Elevated assist"; elevated: true; icon: "add" }
            Md3FilterChip { text: "Filter"; selected: true }
            Md3FilterChip { text: "Unselected" }
            Md3SuggestionChip { text: "Suggestion" }
            Md3SuggestionChip { text: "Elevated"; elevated: true }
        }
    }
}

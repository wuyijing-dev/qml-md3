# Md3KeySequenceField

Desktop shortcut capture field: captures a single chord like Ctrl+K / Shift+Enter.

- **Source:** `src/Md3/components/Md3KeySequenceField.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `label` | `string` | `""` | read/write | `Md3KeySequenceField` | — |
| `placeholderText` | `string` | `qsTr("Press shortcut")` | read/write | `Md3KeySequenceField` | — |
| `supportingText` | `string` | `""` | read/write | `Md3KeySequenceField` | — |
| `captureEnabled` | `bool` | `true` | read/write | `Md3KeySequenceField` | — |
| `autoAcceptOnEnter` | `bool` | `true` | read/write | `Md3KeySequenceField` | — |
| `requireModifier` | `bool` | `true` | read/write | `Md3KeySequenceField` | — |
| `allowSingleKeyFunctionKeys` | `bool` | `true` | read/write | `Md3KeySequenceField` | — |
| `allowSingleKeyNavigation` | `bool` | `false` | read/write | `Md3KeySequenceField` | — |
| `allowSingleKeyLetters` | `bool` | `false` | read/write | `Md3KeySequenceField` | — |
| `allowSingleKeyDigits` | `bool` | `false` | read/write | `Md3KeySequenceField` | — |
| `allowedBaseKeys` | `var` | `[]` | read/write | `Md3KeySequenceField` | — |
| `sequence` | `string` | `""` | read/write | `Md3KeySequenceField` | Normalized display format: "Ctrl+K", "Shift+Enter", etc. |
| `reservedShortcuts` | `var` | `[]` | read/write | `Md3KeySequenceField` | Reserved sequences to detect conflict. |
| `hasConflict` | `bool` | `{…}` | readonly | `Md3KeySequenceField` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `captured(string sequence)` | `Md3KeySequenceField` | — |
| `sequenceAccepted(string sequence)` | `Md3KeySequenceField` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `normalizeSeq(s)` | `Md3KeySequenceField` | — |
| `clear()` | `Md3KeySequenceField` | — |

## Example

```qml
import Md3

Md3KeySequenceField {
    label: ""
    placeholderText: qsTr("Press shortcut")
    supportingText: ""
    captureEnabled: true
    autoAcceptOnEnter: true
}
```

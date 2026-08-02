# Md3KeySequenceField

Desktop shortcut capture field: captures a single chord like Ctrl+K / Shift+Enter.

- **Source:** `src/Md3/components/Md3KeySequenceField.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 14 | 2 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `label` | `string` | `""` | read/write | `Md3KeySequenceField` | Field / control label. |
| `placeholderText` | `string` | `qsTr("Press shortcut")` | read/write | `Md3KeySequenceField` | Placeholder when empty. |
| `supportingText` | `string` | `""` | read/write | `Md3KeySequenceField` | Supporting Text. |
| `captureEnabled` | `bool` | `true` | read/write | `Md3KeySequenceField` | Capture Enabled. |
| `autoAcceptOnEnter` | `bool` | `true` | read/write | `Md3KeySequenceField` | Auto Accept On Enter. |
| `requireModifier` | `bool` | `true` | read/write | `Md3KeySequenceField` | Require Modifier. |
| `allowSingleKeyFunctionKeys` | `bool` | `true` | read/write | `Md3KeySequenceField` | Allow Single Key Function Keys. |
| `allowSingleKeyNavigation` | `bool` | `false` | read/write | `Md3KeySequenceField` | Allow Single Key Navigation. |
| `allowSingleKeyLetters` | `bool` | `false` | read/write | `Md3KeySequenceField` | Allow Single Key Letters. |
| `allowSingleKeyDigits` | `bool` | `false` | read/write | `Md3KeySequenceField` | Allow Single Key Digits. |
| `allowedBaseKeys` | `var` | `[]` | read/write | `Md3KeySequenceField` | optional whitelist like ["K","Enter","F5"] |
| `sequence` | `string` | `""` | read/write | `Md3KeySequenceField` | Normalized display format: "Ctrl+K", "Shift+Enter", etc. |
| `reservedShortcuts` | `var` | `[]` | read/write | `Md3KeySequenceField` | Reserved sequences to detect conflict. |
| `hasConflict` | `bool` | `{…}` | readonly | `Md3KeySequenceField` | Has Conflict. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `captured(string sequence)` | `Md3KeySequenceField` | Emitted when captured. |
| `sequenceAccepted(string sequence)` | `Md3KeySequenceField` | Emitted when sequence Accepted. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `normalizeSeq(s)` | `—` | `Md3KeySequenceField` | Normalize Seq. |
| `clear()` | `—` | `Md3KeySequenceField` | Clear value / selection. |

## Example

```qml
import Md3

Md3KeySequenceField {
    label: ""
    placeholderText: qsTr("Press shortcut")
    supportingText: ""
    captureEnabled: true
    autoAcceptOnEnter: true
    requireModifier: true
}
```

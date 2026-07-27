# Md3Badge

- **Source:** `src/Md3/components/Md3Badge.qml`
- **Extends:** `Item`
- **Related:** `Md3Badged` wraps content and positions a badge at the top-end corner.

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `text` | `string` | `""` | Badge label (numeric or short text). |
| `dot` | `bool` | `false` | Small dot with no label. |
| `max` | `int` | `999` | Cap numeric display (e.g. `99` → `"99+"`). |
| `sizePreset` | `enum` | `Medium` | `Small`, `Medium`, `Large`. |
| `badgeColor` | `color` | `error` | Fill color. |
| `labelColor` | `color` | `onError` | Label color. |
| `displayText` | `string` | readonly | Text after `max` formatting. |
| `large` | `bool` | readonly | Whether a label is shown. |

## Sizing

Label badges use a **fixed height** per preset (Small 14 / Medium 16 / Large 18); width grows with text only. Dots use 6 / 8 / 10. Prefer `Medium` on icon buttons and larger hosts for consistent visual weight.

## Example

```qml
import Md3

Md3Badged {
    badgeText: "128"
    badgeMax: 99
    Md3IconButton { icon: "notifications" }
}

Md3Badge {
    anchors.right: parent.right
    anchors.top: parent.top
    text: "3"
    sizePreset: Md3Badge.Medium
}
```

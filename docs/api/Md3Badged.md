# Md3Badged

- **Source:** `src/Md3/components/Md3Badged.qml`
- **Extends:** `Item`
- **Related:** `Md3Badge`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `badgeText` | `string` | `""` | Text forwarded to the badge. |
| `badgeDot` | `bool` | `false` | Show a dot badge with no label. |
| `badgeMax` | `int` | `99` | Numeric cap used by the embedded badge. |
| `badgeSizePreset` | `enum` | `Md3Badge.Medium` | Badge size preset. |
| `badgeColor` | `color` | `error` | Badge fill color. |
| `badgeLabelColor` | `color` | `onError` | Badge label color. |
| `badgeVisible` | `bool` | `badgeDot || badgeText.length > 0` | Manual visibility override. |
| `badgeOffsetX` | `real` | `2` | Horizontal offset from the top-end corner. |
| `badgeOffsetY` | `real` | `-2` | Vertical offset from the top-end corner. |
| `badge` | `Md3Badge` | readonly | Alias to the embedded badge instance. |
| `content` | `list<Item>` | default | Child content hosted underneath the badge. |

## Example

```qml
import Md3

Md3Badged {
    badgeText: "12"
    badgeMax: 9
    Md3IconButton { icon: "mail" }
}
```

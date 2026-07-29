# Md3ScrollView

- **Source:** `src/Md3/components/Md3ScrollView.qml`
- **Extends:** `Item`

Flickable + themed `Md3ScrollBar` overlays.

## Properties

| Name | Type | Default |
|------|------|---------|
| `content` | default alias | content host children |
| `showVerticalScrollBar` / `showHorizontalScrollBar` | `bool` | `true` |
| `scrollBarAutoHide` | `bool` | `true` |
| `fillContentWidth` | `bool` | `true` |
| `flickable` | alias | inner Flickable |

## Example

```qml
Md3ScrollView {
    height: 200
    Column {
        width: parent.width
        Repeater { model: 30; Text { text: "Row " + index } }
    }
}
```

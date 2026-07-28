# Md3ContextMenuArea

Transparent right-click host over a page / region. Left-clicks pass through; right-click opens `contextMenu` at the cursor.  ```qml Md3ContextMenuArea { anchors.fill: parent contextMenu: pageMenu } Md3Menu { id: pageMenu Md3MenuItem { text: "Refresh" } } ```

- **Source:** `src/Md3/components/Md3ContextMenuArea.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `enabled` | `bool` | `true` | read/write | `Md3ContextMenuArea` | — |
| `contextMenu` | `var` | `null` | read/write | `Md3ContextMenuArea` | Target Md3Menu (required for a useful menu). |
| `menuWidth` | `real` | `0` | read/write | `Md3ContextMenuArea` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `aboutToShow(real x, real y)` | `Md3ContextMenuArea` | — |
| `opened()` | `Md3ContextMenuArea` | — |
| `closed()` | `Md3ContextMenuArea` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `popupAt(x, y)` | `Md3ContextMenuArea` | — |
| `dismiss()` | `Md3ContextMenuArea` | — |

## Example

```qml
import Md3

Md3ContextMenuArea {
    contextMenu: null
    menuWidth: 0
}
```

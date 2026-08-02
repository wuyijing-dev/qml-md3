# Md3ContextMenuArea

Transparent right-click host over a page / region. Left-clicks pass through; right-click opens `contextMenu` at the cursor.  ```qml Md3ContextMenuArea { anchors.fill: parent contextMenu: pageMenu } Md3Menu { id: pageMenu Md3MenuItem { text: qsTr("Refresh") } } ```

- **Source:** `src/Md3/components/Md3ContextMenuArea.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 3 | 3 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `contextMenu` | `var` | `null` | read/write | `Md3ContextMenuArea` | Target Md3Menu (required for a useful menu). |
| `menuWidth` | `real` | `0` | read/write | `Md3ContextMenuArea` | Menu Width. |
| `overlayWindow` | `var` | `null` | read/write | `Md3ContextMenuArea` | Optional explicit Window for overlay mapping (else Window.window). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `aboutToShow(real x, real y)` | `Md3ContextMenuArea` | Emitted when about To Show. |
| `opened()` | `Md3ContextMenuArea` | Emitted when opened. |
| `closed()` | `Md3ContextMenuArea` | Emitted when closed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `popupAt(x, y)` | `—` | `Md3ContextMenuArea` | Popup At. |
| `dismiss()` | `—` | `Md3ContextMenuArea` | Dismiss. |

## Example

```qml
import Md3

Md3ContextMenuArea {
    contextMenu: null
    menuWidth: 0
    overlayWindow: null
}
```

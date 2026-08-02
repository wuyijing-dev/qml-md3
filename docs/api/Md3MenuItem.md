# Md3MenuItem

- **Source:** `src/Md3/components/Md3MenuItem.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 14 | 1 | 3 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3MenuItem` | Primary label text. |
| `icon` | `string` | `""` | read/write | `Md3MenuItem` | Material icon name or empty. |
| `trailingIcon` | `string` | `""` | read/write | `Md3MenuItem` | Trailing Icon. |
| `destructive` | `bool` | `false` | read/write | `Md3MenuItem` | Destructive. |
| `selected` | `bool` | `false` | read/write | `Md3MenuItem` | Selected. |
| `showCheck` | `bool` | `false` | read/write | `Md3MenuItem` | Show Check. |
| `leadingCheck` | `bool` | `true` | read/write | `Md3MenuItem` | Leading Check. |
| `highlighted` | `bool` | `false` | read/write | `Md3MenuItem` | Keyboard highlight from parent Md3Menu. |
| `submenu` | `var` | `null` | read/write | `Md3MenuItem` | Nested cascading menu (Md3Menu). Hover / click opens it to the side. Use `var` so inline / sibling menus assign reliably across Loaders. |
| `hasSubMenu` | `bool` | `submenu !== null && submenu !== undefined` | readonly | `Md3MenuItem` | Has Sub Menu. |
| `itemRadius` | `real` | `Md3Theme.shape.large` | readonly | `Md3MenuItem` | Item Radius. |
| `showLeadingCheck` | `bool` | `showCheck && leadingCheck && selected` | readonly | `Md3MenuItem` | Show Leading Check. |
| `showTrailingCheck` | `bool` | `showCheck && !leadingCheck && selected` | readonly | `Md3MenuItem` | Show Trailing Check. |
| `resolvedTrailing` | `string` | `{…}` | readonly | `Md3MenuItem` | Resolved Trailing. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3MenuItem` | Emitted when clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `ownerMenu()` | `—` | `Md3MenuItem` | Owner Menu. |
| `openSubmenu()` | `—` | `Md3MenuItem` | Open Submenu. |
| `closeSiblingSubmenus()` | `—` | `Md3MenuItem` | Close Sibling Submenus. |

## Example

```qml
import Md3

Md3MenuItem {
    text: ""
    icon: ""
    trailingIcon: ""
    destructive: false
    selected: false
    showCheck: false
}
```

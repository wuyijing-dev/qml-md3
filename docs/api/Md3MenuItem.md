# Md3MenuItem

- **Source:** `src/Md3/components/Md3MenuItem.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3MenuItem` | — |
| `icon` | `string` | `""` | read/write | `Md3MenuItem` | — |
| `trailingIcon` | `string` | `""` | read/write | `Md3MenuItem` | — |
| `enabled` | `bool` | `true` | read/write | `Md3MenuItem` | — |
| `destructive` | `bool` | `false` | read/write | `Md3MenuItem` | — |
| `selected` | `bool` | `false` | read/write | `Md3MenuItem` | — |
| `showCheck` | `bool` | `false` | read/write | `Md3MenuItem` | — |
| `leadingCheck` | `bool` | `true` | read/write | `Md3MenuItem` | — |
| `submenu` | `var` | `null` | read/write | `Md3MenuItem` | Nested cascading menu (Md3Menu). Hover / click opens it to the side. Use `var` so inline / sibling menus assign reliably across Loaders. |
| `hasSubMenu` | `bool` | `submenu !== null && submenu !== undefined` | readonly | `Md3MenuItem` | — |
| `itemRadius` | `real` | `Md3Theme.shape.large` | readonly | `Md3MenuItem` | — |
| `showLeadingCheck` | `bool` | `showCheck && leadingCheck && selected` | readonly | `Md3MenuItem` | — |
| `showTrailingCheck` | `bool` | `showCheck && !leadingCheck && selected` | readonly | `Md3MenuItem` | — |
| `resolvedTrailing` | `string` | `{…}` | readonly | `Md3MenuItem` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3MenuItem` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `ownerMenu()` | `Md3MenuItem` | — |
| `openSubmenu()` | `Md3MenuItem` | — |
| `closeSiblingSubmenus()` | `Md3MenuItem` | — |

## Example

```qml
import Md3

Md3MenuItem {
    text: ""
    icon: ""
    trailingIcon: ""
    destructive: false
    selected: false
}
```

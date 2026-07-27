# Md3NavigationRail

- **Source:** `src/Md3/components/Md3NavigationRail.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `model` | `var` | `[]` | Scrollable destinations: `{ icon, label, destIndex? }` |
| `footerModel` | `var` | `[]` | Bottom-pinned destinations (same shape) |
| `currentIndex` | `int` | `0` | Selected **destIndex** (not visual row) |
| `expanded` | `bool` | `false` | Expanded rail width / labels |
| `headerLabel` | `string` | `""` | Optional header when expanded |
| `showExpandToggle` | `bool` | `true` | Menu expand control |

In `Md3ApplicationWindow` destinations, set `pin: "bottom"` (or `footer: true`) to place an entry in `footerModel`.

## Signals

| Signal | Description |
|--------|-------------|
| `currentIndexChangedByUser(int index)` | User selected a destination (`destIndex`) |
| `destinationHovered(int index)` | Prefetch hint |
| `destinationUnhovered(int index)` | — |
| `expandToggleClicked()` | Expand / collapse |

## Example

```qml
Md3NavigationRail {
    model: [
        { icon: "home", label: "Home", destIndex: 0 },
        { icon: "mail", label: "Inbox", destIndex: 1 }
    ]
    footerModel: [
        { icon: "settings", label: "Settings", destIndex: 5 }
    ]
    currentIndex: 0
}
```

# Md3TabWindow

- **Source:** `src/Md3/window/Md3TabWindow.qml`
- **Extends:** `Md3ApplicationWindow`

Peer window created by document-tab tear-off (`Md3ApplicationWindow.tearOffTab` / `documentTabsTearOff`).

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `catalog` | `var` | `[]` | Destination list (usually copied from the parent window). |
| `initialTabs` | `var` | `[]` | Tab model entries to seed (`documentTabMeta` objects). |
| `initialTabIndex` | `int` | `0` | Used when `initialTabs` is empty. |

Defaults enable managed tabs, tear-off, and `documentTabsCloseWindowWhenEmpty` so closing the last tab closes the peer window.

## Notes

- Uses the normal title bar + tab strip (the old `browserChrome` mode is not required).
- Further tear-offs from a peer window are allowed (`documentTabsTearOff: true`).

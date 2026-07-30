# Md3OverlayHost

- **Source:** `src/Md3/foundation/Md3OverlayHost.qml`
- **Kind:** singleton (`pragma Singleton`)

Resolve overlay parents and popup coordinates without each control re-implementing `Window.window`.

## Functions

| Name | Role |
|------|------|
| `resolveWindow(win, anchor)` | Prefer explicit `win`; else `anchor.Window.window` |
| `contentItem(win, anchor)` | Top-level contentItem for popup reparent |
| `mapToOverlay(fromItem, x, y, win)` | Map local point into overlay content coordinates |
| `ensureHostParent(host, win, anchor, zOrder)` | Reparent `host` to fill overlay contentItem |

## Usage

Controls may expose optional `overlayWindow`. Wired into:

`Md3Menu`, `Md3MenuBar`, `Md3MenuItem`, `Md3ContextMenuArea`, `Md3DateField`, `Md3TimeField`,
`Md3Select`, `Md3DropdownMenu`, `Md3SplitButton`, `Md3DataTable`, `Md3TreeView`, `Md3TextField` (autocomplete).

See [module-boundaries.md](../module-boundaries.md).

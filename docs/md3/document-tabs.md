# Document tabs

Win11 Explorer / browser-style tabs under the title bar.

## Minimal usage (managed)

```qml
Md3ApplicationWindow {
    documentTabsEnabled: true   // that's enough — managed by default
    destinations: [ /* ... */ ]
}
```

Built-in (`documentTabsManaged: true`):

| Action | Behavior |
|--------|----------|
| Rail / `navigateTo` | Updates the **current** tab title/icon/page |
| `+` / `addTab(i)` | New tab with pop-in animation |
| Close / middle-click | Removes tab (`closeTab`) |
| Drag sideways | Reorder |
| Drag outside window | Tear off → new `Md3TabWindow` |
| Last tab on torn window | Closes window if `documentTabsCloseWindowWhenEmpty` |

## API

```qml
openTab(pageIndex, asNew)   // false = replace current tab, true = new tab
addTab(pageIndex)           // alias for openTab(..., true)
closeTab(index)
activateTab(index)
moveTab(from, to)
tearOffTab(index, gx, gy)
documentTabMeta(pageIndex)  // { title, icon, pageIndex }
```

Signals still fire if you need extras (`documentTabActivated`, …). Set `documentTabsManaged: false` to handle everything yourself.

## Visual

Selected tab uses a sheet shape (rounded top, flush with content). New tabs pop in from the `+` control.

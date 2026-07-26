# Document tabs (under title bar)

```qml
Md3ApplicationWindow {
    documentTabsEnabled: true   // managed by default
    // title bar stays visible — tabs sit below it
}
```

Built-in (`documentTabsManaged: true`):

| Action | Behavior |
|--------|----------|
| Click tab | Activate + navigate |
| Close | Close tab (last tab keeps window) |
| `+` / `addTab(i)` | New tab with pop-in animation |
| Drag reorder | Reorder tabs |
| Drag outside | Signal only — tear-off windows are not spawned |

API:

```
openTab(pageIndex, asNew)   // false = replace current tab, true = new tab
addTab(pageIndex)           // alias for openTab(..., true)
closeTab(index)
moveTab(from, to)
activateTab(index)
documentTabMeta(pageIndex)  // { title, icon, pageIndex }
```

Set `documentTabsTearOff: false` (default) to disable tear-off gestures.

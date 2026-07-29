# Md3FileDropZone

Desktop file drop target with scrollable table preview of dropped files.

- **Source:** `src/Md3/components/Md3FileDropZone.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `title` | `string` | `qsTr("Drop files here")` | Empty-state title |
| `subtitle` | `string` | `qsTr("Drag files from Explorer/Finder")` | Empty-state subtitle |
| `emptyHint` | `string` | `qsTr("or click to browse")` | Hint under subtitle |
| `acceptedExtensions` | `var` | `[]` | e.g. `[".qml", ".json"]`; empty = all |
| `allowMultiple` | `bool` | `true` | — |
| `clickable` | `bool` | `true` | Click empty area / Add to browse |
| `appendOnDrop` | `bool` | `true` | Append vs replace on each drop |
| `showTable` | `bool` | `true` | Show scrollable Name/Type/Path table when filled |
| `tableBodyHeight` | `real` | `168` | Scroll viewport height for the file table |
| `droppedItems` | `var` | `[]` | `[{ name, path, url, extension }]` |
| `droppedPaths` / `droppedUrls` | `var` | `[]` | Convenience mirrors |
| `dragActive` | `bool` | — | True while a drag hovers the zone |

## Signals / Methods

- `filesDropped(var items)` — newly accepted items
- `itemRemoved(int index, var item)`
- `clicked()`
- `clear()`, `removeAt(index)`

## Example

```qml
Md3FileDropZone {
    Layout.fillWidth: true
    Layout.preferredHeight: 280
    acceptedExtensions: [".qml", ".json", ".md"]
    onFilesDropped: (items) => Md3Notify.toast(qsTr("Added %1").arg(items.length), {
        severity: Md3Toast.Success,
        position: Md3ToastHost.TopRight
    })
}
```

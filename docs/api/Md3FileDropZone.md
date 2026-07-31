# Md3FileDropZone

Desktop file drop target with scrollable table preview of dropped files.

- **Source:** `src/Md3/components/Md3FileDropZone.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `qsTr("Drop files here")` | read/write | `Md3FileDropZone` | — |
| `subtitle` | `string` | `qsTr("Drag files from Explorer/Finder")` | read/write | `Md3FileDropZone` | — |
| `emptyHint` | `string` | `qsTr("or click to browse")` | read/write | `Md3FileDropZone` | — |
| `acceptedExtensions` | `var` | `[]` | read/write | `Md3FileDropZone` | — |
| `allowMultiple` | `bool` | `true` | read/write | `Md3FileDropZone` | — |
| `clickable` | `bool` | `true` | read/write | `Md3FileDropZone` | — |
| `dragActive` | `bool` | `dropArea.containsDrag` | read/write | `Md3FileDropZone` | — |
| `droppedPaths` | `var` | `[]` | read/write | `Md3FileDropZone` | — |
| `droppedUrls` | `var` | `[]` | read/write | `Md3FileDropZone` | — |
| `droppedItems` | `var` | `[]` | read/write | `Md3FileDropZone` | — |
| `leadingIcon` | `string` | `"upload_file"` | read/write | `Md3FileDropZone` | — |
| `showTable` | `bool` | `true` | read/write | `Md3FileDropZone` | — |
| `tableBodyHeight` | `real` | `168` | read/write | `Md3FileDropZone` | — |
| `rowHeight` | `real` | `44` | read/write | `Md3FileDropZone` | — |
| `appendOnDrop` | `bool` | `true` | read/write | `Md3FileDropZone` | — |
| `lastRejectMessage` | `string` | `""` | read/write | `Md3FileDropZone` | — |
| `rejectExtensionText` | `string` | `qsTr("File type not allowed")` | read/write | `Md3FileDropZone` | — |
| `announceRejections` | `bool` | `true` | read/write | `Md3FileDropZone` | — |
| `hasFiles` | `bool` | `droppedItems && droppedItems.length > 0` | readonly | `Md3FileDropZone` | — |
| `summaryText` | `string` | `{…}` | readonly | `Md3FileDropZone` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `filesDropped(var items)` | `Md3FileDropZone` | — |
| `itemRemoved(int index, var item)` | `Md3FileDropZone` | — |
| `clicked()` | `Md3FileDropZone` | — |
| `rejected(string message)` | `Md3FileDropZone` | Fired when drops/browse picks are rejected (extension / empty). message is localized. |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `clear()` | `Md3FileDropZone` | — |
| `removeAt(index)` | `Md3FileDropZone` | — |

## Example

```qml
import Md3

Md3FileDropZone {
    title: qsTr("Drop files here")
    subtitle: qsTr("Drag files from Explorer/Finder")
    emptyHint: qsTr("or click to browse")
    acceptedExtensions: []
    allowMultiple: true
}
```

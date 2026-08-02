# Md3FileDropZone

Desktop file drop target with scrollable table preview of dropped files.

- **Source:** `src/Md3/components/Md3FileDropZone.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 21 | 4 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `qsTr("Drop files here")` | read/write | `Md3FileDropZone` | Title text. |
| `subtitle` | `string` | `qsTr("Drag files from Explorer/Finder")` | read/write | `Md3FileDropZone` | Secondary supporting text. |
| `emptyHint` | `string` | `qsTr("or click to browse")` | read/write | `Md3FileDropZone` | Empty Hint. |
| `acceptedExtensions` | `var` | `[]` | read/write | `Md3FileDropZone` | [".zip", ".qml"] |
| `allowMultiple` | `bool` | `true` | read/write | `Md3FileDropZone` | Allow Multiple. |
| `clickable` | `bool` | `true` | read/write | `Md3FileDropZone` | Clickable. |
| `dragActive` | `bool` | `dropArea.containsDrag` | read/write | `Md3FileDropZone` | Drag Active. |
| `droppedPaths` | `var` | `[]` | read/write | `Md3FileDropZone` | Dropped Paths. |
| `droppedUrls` | `var` | `[]` | read/write | `Md3FileDropZone` | Dropped Urls. |
| `droppedItems` | `var` | `[]` | read/write | `Md3FileDropZone` | [{ name, path, url, extension }] |
| `leadingIcon` | `string` | `"upload_file"` | read/write | `Md3FileDropZone` | Leading Icon. |
| `showTable` | `bool` | `true` | read/write | `Md3FileDropZone` | Show Table. |
| `tableBodyHeight` | `real` | `168` | read/write | `Md3FileDropZone` | Table Body Height. |
| `rowHeight` | `real` | `44` | read/write | `Md3FileDropZone` | Row Height. |
| `appendOnDrop` | `bool` | `true` | read/write | `Md3FileDropZone` | Append On Drop. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3FileDropZone` | Drop table row Items while page is off-display (chrome height stays). |
| `lastRejectMessage` | `string` | `""` | read/write | `Md3FileDropZone` | Last Reject Message. |
| `rejectExtensionText` | `string` | `qsTr("File type not allowed")` | read/write | `Md3FileDropZone` | Reject Extension Text. |
| `announceRejections` | `bool` | `true` | read/write | `Md3FileDropZone` | Announce Rejections. |
| `hasFiles` | `bool` | `droppedItems && droppedItems.length > 0` | readonly | `Md3FileDropZone` | Has Files. |
| `summaryText` | `string` | `{…}` | readonly | `Md3FileDropZone` | Summary Text. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `filesDropped(var items)` | `Md3FileDropZone` | Emitted when files Dropped. |
| `itemRemoved(int index, var item)` | `Md3FileDropZone` | Emitted when item Removed. |
| `clicked()` | `Md3FileDropZone` | Emitted when clicked. |
| `rejected(string message)` | `Md3FileDropZone` | Fired when drops/browse picks are rejected (extension / empty). message is localized. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `clear()` | `—` | `Md3FileDropZone` | Clear value / selection. |
| `removeAt(index)` | `—` | `Md3FileDropZone` | Remove At. |

## Example

```qml
import Md3

Md3FileDropZone {
    title: qsTr("Drop files here")
    subtitle: qsTr("Drag files from Explorer/Finder")
    emptyHint: qsTr("or click to browse")
    acceptedExtensions: []
    allowMultiple: true
    clickable: true
}
```

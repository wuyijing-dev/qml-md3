# Md3PathField

Path field — open/save file, multi-file, or folder; recent paths, validation, drop, breadcrumb.

- **Source:** `src/Md3/components/Md3PathField.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 31 | 4 | 4 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3PathField.Mode`

`Md3PathField.OpenFile`, `Md3PathField.SaveFile`, `Md3PathField.OpenFiles`, `Md3PathField.Folder`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `mode` | `int (Md3PathField.Mode)` | `Md3PathField.OpenFile` | read/write | `Md3PathField` | Mode. |
| `label` | `alias` | `field.label` | read/write | `Md3PathField` | Field / control label. |
| `supportingText` | `alias` | `field.supportingText` | read/write | `Md3PathField` | Supporting Text. |
| `errorText` | `alias` | `field.errorText` | read/write | `Md3PathField` | Validation error string (empty = ok). |
| `error` | `alias` | `field.error` | read/write | `Md3PathField` | Error. |
| `placeholderText` | `alias` | `field.placeholderText` | read/write | `Md3PathField` | Placeholder when empty. |
| `path` | `string` | `""` | read/write | `Md3PathField` | Path. |
| `paths` | `var` | `[]` | read/write | `Md3PathField` | Paths. |
| `dialogTitle` | `string` | `qsTr("Select")` | read/write | `Md3PathField` | Dialog Title. |
| `nameFilters` | `var` | `["All files (*)"]` | read/write | `Md3PathField` | Name Filters. |
| `currentFolder` | `url` | `""` | read/write | `Md3PathField` | Current Folder. |
| `controlEnabled` | `bool` | `true` | read/write | `Md3PathField` | Control Enabled. |
| `accessibleName` | `string` | `""` | read/write | `Md3PathField` | Accessible name override. |
| `recentPaths` | `var` | `[]` | read/write | `Md3PathField` | Recent Paths. |
| `maxRecent` | `int` | `8` | read/write | `Md3PathField` | Max Recent. |
| `rememberRecent` | `bool` | `true` | read/write | `Md3PathField` | Remember Recent. |
| `recentStoreKey` | `string` | `""` | read/write | `Md3PathField` | e.g. "desktop/recentPaths" |
| `validateExtension` | `bool` | `true` | read/write | `Md3PathField` | Validate Extension. |
| `validateExists` | `bool` | `false` | read/write | `Md3PathField` | Validate Exists. |
| `validateWritable` | `bool` | `false` | read/write | `Md3PathField` | Validate Writable. |
| `allowedExtensions` | `var` | `[]` | read/write | `Md3PathField` | e.g. [".qml", ".json"] |
| `pathValidator` | `var` | `null` | read/write | `Md3PathField` | function(path) -> { valid: bool, message: string } |
| `existsProbe` | `var` | `null` | read/write | `Md3PathField` | function(path)->bool |
| `writableProbe` | `var` | `null` | read/write | `Md3PathField` | function(path)->bool |
| `notFoundText` | `string` | `qsTr("Path does not exist")` | read/write | `Md3PathField` | Localized when existsProbe fails (validateExists). |
| `permissionDeniedText` | `string` | `qsTr("No write permission for this path")` | read/write | `Md3PathField` | Localized when writableProbe fails (validateWritable) — permission / ACL. |
| `announceValidationErrors` | `bool` | `true` | read/write | `Md3PathField` | Announce validation failures via Md3Accessibility (default on). |
| `showBreadcrumb` | `bool` | `false` | read/write | `Md3PathField` | Show Breadcrumb. |
| `acceptDrops` | `bool` | `true` | read/write | `Md3PathField` | Accept Drops. |
| `multiMode` | `bool` | `mode === Md3PathField.OpenFiles` | readonly | `Md3PathField` | Multi Mode. |
| `breadcrumbModel` | `var` | `_splitPath(path)` | readonly | `Md3PathField` | Breadcrumb Model. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(string path)` | `Md3PathField` | Emitted when accepted. |
| `pathsAccepted(var paths)` | `Md3PathField` | Emitted when paths Accepted. |
| `rejected()` | `Md3PathField` | Emitted when rejected. |
| `validationChanged(bool valid, string message)` | `Md3PathField` | Emitted when validation Changed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `browse()` | `—` | `Md3PathField` | Browse. |
| `clear()` | `—` | `Md3PathField` | Clear value / selection. |
| `addRecent(p)` | `—` | `Md3PathField` | Add Recent. |
| `validatePath(p)` | `—` | `Md3PathField` | Validate Path. |

## Example

```qml
import Md3

Md3PathField {
    mode: Md3PathField.OpenFile
    path: ""
    paths: []
    dialogTitle: qsTr("Select")
    nameFilters: ["All files (*)"]
    currentFolder: ""
}
```

# Md3PathField

Path field — open/save file, multi-file, or folder; recent paths, validation, drop, breadcrumb.

- **Source:** `src/Md3/components/Md3PathField.qml`
- **Extends:** `Item`

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
| `mode` | `int` | `Md3PathField.OpenFile` | read/write | `Md3PathField` | — |
| `label` | `alias` | `field.label` | read/write | `Md3PathField` | Alias → `field.label` |
| `supportingText` | `alias` | `field.supportingText` | read/write | `Md3PathField` | Alias → `field.supportingText` |
| `errorText` | `alias` | `field.errorText` | read/write | `Md3PathField` | Alias → `field.errorText` |
| `error` | `alias` | `field.error` | read/write | `Md3PathField` | Alias → `field.error` |
| `placeholderText` | `alias` | `field.placeholderText` | read/write | `Md3PathField` | Alias → `field.placeholderText` |
| `path` | `string` | `""` | read/write | `Md3PathField` | — |
| `paths` | `var` | `[]` | read/write | `Md3PathField` | — |
| `dialogTitle` | `string` | `qsTr("Select")` | read/write | `Md3PathField` | — |
| `nameFilters` | `var` | `["All files (*)"]` | read/write | `Md3PathField` | — |
| `currentFolder` | `url` | `""` | read/write | `Md3PathField` | — |
| `controlEnabled` | `bool` | `true` | read/write | `Md3PathField` | — |
| `accessibleName` | `string` | `""` | read/write | `Md3PathField` | — |
| `recentPaths` | `var` | `[]` | read/write | `Md3PathField` | — |
| `maxRecent` | `int` | `8` | read/write | `Md3PathField` | — |
| `rememberRecent` | `bool` | `true` | read/write | `Md3PathField` | — |
| `recentStoreKey` | `string` | `""` | read/write | `Md3PathField` | — |
| `validateExtension` | `bool` | `true` | read/write | `Md3PathField` | — |
| `validateExists` | `bool` | `false` | read/write | `Md3PathField` | — |
| `validateWritable` | `bool` | `false` | read/write | `Md3PathField` | — |
| `allowedExtensions` | `var` | `[]` | read/write | `Md3PathField` | — |
| `pathValidator` | `var` | `null` | read/write | `Md3PathField` | — |
| `existsProbe` | `var` | `null` | read/write | `Md3PathField` | — |
| `writableProbe` | `var` | `null` | read/write | `Md3PathField` | — |
| `showBreadcrumb` | `bool` | `false` | read/write | `Md3PathField` | — |
| `acceptDrops` | `bool` | `true` | read/write | `Md3PathField` | — |
| `multiMode` | `bool` | `mode === Md3PathField.OpenFiles` | readonly | `Md3PathField` | — |
| `breadcrumbModel` | `var` | `_splitPath(path)` | readonly | `Md3PathField` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(string path)` | `Md3PathField` | — |
| `pathsAccepted(var paths)` | `Md3PathField` | — |
| `rejected()` | `Md3PathField` | — |
| `validationChanged(bool valid, string message)` | `Md3PathField` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `browse()` | `Md3PathField` | — |
| `clear()` | `Md3PathField` | — |
| `addRecent(p)` | `Md3PathField` | — |
| `validatePath(p)` | `Md3PathField` | — |

## Example

```qml
import Md3

Md3PathField {
    mode: Md3PathField.OpenFile
    path: ""
    paths: []
    dialogTitle: qsTr("Select")
    nameFilters: ["All files (*)"]
}
```

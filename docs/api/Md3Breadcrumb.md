# Md3Breadcrumb

Horizontal breadcrumb trail. model: ["Home","Folder"] or [{ title, icon? }, ...]

- **Source:** `src/Md3/components/Md3Breadcrumb.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3Breadcrumb` | — |
| `maxVisible` | `int` | `6` | read/write | `Md3Breadcrumb` | — |
| `spacing` | `real` | `4` | read/write | `Md3Breadcrumb` | — |
| `fontSize` | `real` | `Md3Theme.typography.labelLarge.size` | read/write | `Md3Breadcrumb` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `crumbClicked(int index)` | `Md3Breadcrumb` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3Breadcrumb {
    model: []
    maxVisible: 6
    spacing: 4
    fontSize: Md3Theme.typography.labelLarge.size
}
```

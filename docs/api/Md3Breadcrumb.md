# Md3Breadcrumb

Horizontal breadcrumb trail. model: ["Home","Folder"] or [{ title, icon? }, ...]

- **Source:** `src/Md3/components/Md3Breadcrumb.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 1 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3Breadcrumb` | Data model. |
| `maxVisible` | `int` | `6` | read/write | `Md3Breadcrumb` | Max Visible. |
| `spacing` | `real` | `4` | read/write | `Md3Breadcrumb` | Child spacing. |
| `fontSize` | `real` | `Md3Theme.typography.labelLarge.size` | read/write | `Md3Breadcrumb` | Font Size. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `crumbClicked(int index)` | `Md3Breadcrumb` | Emitted when crumb Clicked. |

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

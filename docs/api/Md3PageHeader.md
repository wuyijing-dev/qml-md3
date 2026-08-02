# Md3PageHeader

Page title row with optional subtitle and trailing actions (overflow on narrow width).  **Children go to the actions row** (`default property` → `actions`). Do not wrap this in another Item that aliases `pageHeader.data`.

- **Source:** `src/Md3/components/Md3PageHeader.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 1 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3PageHeader` | Title text. |
| `subtitle` | `string` | `""` | read/write | `Md3PageHeader` | Secondary supporting text. |
| `actions` | `alias` | `actionsRow.data` | default read/write | `Md3PageHeader` | Actions. |
| `actionsMaxWidth` | `real` | `Math.max(120, width * 0.55)` | read/write | `Md3PageHeader` | Actions Max Width. |
| `overflowEnabled` | `bool` | `true` | read/write | `Md3PageHeader` | Overflow Enabled. |
| `overflowIcon` | `string` | `"more_vert"` | read/write | `Md3PageHeader` | Overflow Icon. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `overflowClicked()` | `Md3PageHeader` | Emitted when overflow Clicked. |

## Methods

_None._

## Example

```qml
import Md3

Md3PageHeader {
    title: ""
    subtitle: ""
    actionsMaxWidth: Math.max(120, width * 0.55)
    overflowEnabled: true
    overflowIcon: "more_vert"
}
```

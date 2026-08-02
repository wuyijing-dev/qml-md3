# Md3SelectionToolbar

Selection action bar: “N selected” + trailing actions (for tables / lists).

- **Source:** `src/Md3/components/Md3SelectionToolbar.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 5 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `selectedCount` | `int` | `0` | read/write | `Md3SelectionToolbar` | Selected Count. |
| `label` | `string` | `selectedCount === 1 ? qsTr("1 selected")` | read/write | `Md3SelectionToolbar` | Field / control label. |
| `autoHide` | `bool` | `true` | read/write | `Md3SelectionToolbar` | Auto Hide. |
| `actions` | `alias` | `actionsRow.data` | default read/write | `Md3SelectionToolbar` | Actions. |
| `bare` | `bool` | `selectedCount <= 0` | readonly | `Md3SelectionToolbar` | Bare. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3SelectionToolbar {
    selectedCount: 0
    label: selectedCount === 1 ? qsTr("1 selected")
    autoHide: true
}
```

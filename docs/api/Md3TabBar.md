# Md3TabBar

Tab strip + optional content pages (WinUI Pivot-style). When `pages` has children, a StackLayout tracks `currentIndex` — no host sync glue.

- **Source:** `src/Md3/components/Md3TabBar.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 7 | 1 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3TabBar.Variant`

`Md3TabBar.Primary`, `Md3TabBar.Secondary`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int (Md3TabBar.Variant)` | `Md3TabBar.Primary` | read/write | `Md3TabBar` | Visual / role variant (see Enums). |
| `model` | `var` | `[]` | read/write | `Md3TabBar` | Data model. |
| `currentIndex` | `int` | `0` | read/write | `Md3TabBar` | Current index. |
| `pages` | `alias` | `pageStack.data` | default read/write | `Md3TabBar` | Content pages (synced with currentIndex). Prefer over external StackLayout. |
| `pageAreaHeight` | `real` | `96` | read/write | `Md3TabBar` | Extra height for page area when `pages` are present (Layout / implicit). |
| `fillHeight` | `bool` | `false` | read/write | `Md3TabBar` | When true with pages, height fills the parent (IDE pageHost). Strip stays 48px. |
| `hasPages` | `bool` | `pageStack.children.length > 0` | readonly | `Md3TabBar` | Has Pages. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3TabBar` | Emitted when current Index Changed By User. |

## Methods

_None._

## Example

```qml
import Md3

Md3TabBar {
    variant: Md3TabBar.Primary
    model: []
    currentIndex: 0
    pageAreaHeight: 96
    fillHeight: false
}
```

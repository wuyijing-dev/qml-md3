# Md3PageScaffold

Page chrome: fixed header, body (scroll or fit), optional sticky footer.

- **Source:** `src/Md3/layout/Md3PageScaffold.qml`
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
| `header` | `alias` | `headerSlot.data` | read/write | `Md3PageScaffold` | Header. |
| `stickyFooter` | `alias` | `footerSlot.data` | read/write | `Md3PageScaffold` | Sticky Footer. |
| `body` | `alias` | `bodySlot.data` | default read/write | `Md3PageScaffold` | Body. |
| `scrollBody` | `bool` | `true` | read/write | `Md3PageScaffold` | When true (default), body is an ``Md3ScrollView`` between header and footer. |
| `verticalScrollbarGutter` | `real` | `0` | read/write | `Md3PageScaffold` | Vertical Scrollbar Gutter. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3PageScaffold {
    scrollBody: true
    verticalScrollbarGutter: 0
}
```

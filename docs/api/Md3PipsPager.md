# Md3PipsPager

Page indicator / WinUI PipsPager — dots or pills bound to a page count.

- **Source:** `src/Md3/components/Md3PipsPager.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3PipsPager.Style`

`Md3PipsPager.Dot`, `Md3PipsPager.Pill`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `count` | `int` | `0` | read/write | `Md3PipsPager` | — |
| `currentIndex` | `int` | `0` | read/write | `Md3PipsPager` | — |
| `style` | `int` | `Md3PipsPager.Pill` | read/write | `Md3PipsPager` | — |
| `spacing` | `real` | `8` | read/write | `Md3PipsPager` | — |
| `inactiveSize` | `real` | `8` | read/write | `Md3PipsPager` | — |
| `activeWidth` | `real` | `18` | read/write | `Md3PipsPager` | — |
| `interactive` | `bool` | `true` | read/write | `Md3PipsPager` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `indexRequested(int index)` | `Md3PipsPager` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `goTo(index)` | `Md3PipsPager` | — |

## Example

```qml
import Md3

Md3PipsPager {
    count: 0
    currentIndex: 0
    style: Md3PipsPager.Pill
    spacing: 8
    inactiveSize: 8
}
```

## WinUI 对照

| WinUI | Md3 |
|-------|-----|
| PipsPager | `Md3PipsPager` |

`style: Dot | Pill`；`indexRequested` 驱动 `Md3Carousel.goTo`。Carousel 内置指示点也使用本控件。

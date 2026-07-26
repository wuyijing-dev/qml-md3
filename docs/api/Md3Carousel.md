# Md3Carousel

- **Source:** `src/Md3/components/Md3Carousel.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[] // [{ title, subtitle?, color?, source? }]` | read/write | `Md3Carousel` | — |
| `currentIndex` | `int` | `0` | read/write | `Md3Carousel` | — |
| `itemHeight` | `real` | `168` | read/write | `Md3Carousel` | — |
| `peekRatio` | `real` | `0.12` | read/write | `Md3Carousel` | Fraction of next item visible (peek). 0 = full-bleed page. |
| `spacing` | `real` | `12` | read/write | `Md3Carousel` | — |
| `showIndicators` | `bool` | `true` | read/write | `Md3Carousel` | — |
| `autoPlay` | `bool` | `false` | read/write | `Md3Carousel` | — |
| `autoPlayInterval` | `int` | `4000` | read/write | `Md3Carousel` | — |
| `wrap` | `bool` | `true` | read/write | `Md3Carousel` | — |
| `shadowPad` | `real` | `10` | read/write | `Md3Carousel` | Shadow bleed around each card so elevation is not clipped. |
| `pageWidth` | `real` | `Math.max(120, width * (1 - peekRatio) - spacing)` | readonly | `Md3Carousel` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `indexChangedByUser(int index)` | `Md3Carousel` | — |
| `itemClicked(int index)` | `Md3Carousel` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `goTo(index)` | `Md3Carousel` | — |
| `next()` | `Md3Carousel` | — |
| `previous()` | `Md3Carousel` | — |

## Example

```qml
import Md3

Md3Carousel {
    model: [] // [{ title, subtitle?, color?, source? }]
    currentIndex: 0
    itemHeight: 168
    peekRatio: 0.12
    spacing: 12
}
```

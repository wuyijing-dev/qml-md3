# Md3Carousel

- **Source:** `src/Md3/components/Md3Carousel.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 14 | 2 | 3 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3Carousel.Mode`

`Md3Carousel.MultiBrowse`, `Md3Carousel.Flip`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3Carousel` | [{ title, subtitle?, color?, source? }] |
| `currentIndex` | `int` | `0` | read/write | `Md3Carousel` | Current index. |
| `mode` | `int (Md3Carousel.Mode)` | `Md3Carousel.MultiBrowse` | read/write | `Md3Carousel` | Mode. |
| `itemHeight` | `real` | `168` | read/write | `Md3Carousel` | Item Height. |
| `peekRatio` | `real` | `0.12` | read/write | `Md3Carousel` | Fraction of next item visible (peek). Ignored in Flip mode. |
| `spacing` | `real` | `12` | read/write | `Md3Carousel` | Child spacing. |
| `showIndicators` | `bool` | `true` | read/write | `Md3Carousel` | Show Indicators. |
| `indicatorStyle` | `int` | `Md3PipsPager.Pill` | read/write | `Md3Carousel` | Indicator Style. |
| `autoPlay` | `bool` | `false` | read/write | `Md3Carousel` | Auto Play. |
| `autoPlayInterval` | `int` | `4000` | read/write | `Md3Carousel` | Auto Play Interval. |
| `wrap` | `bool` | `true` | read/write | `Md3Carousel` | Wrap. |
| `shadowPad` | `real` | `10` | read/write | `Md3Carousel` | Shadow bleed around each card so elevation is not clipped. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3Carousel` | Drop carousel delegates while page is off-display (shell size stays). |
| `pageWidth` | `real` | `Math.max(120, width * (1 - _peek) - _spacing)` | readonly | `Md3Carousel` | Page Width. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `indexChangedByUser(int index)` | `Md3Carousel` | Emitted when index Changed By User. |
| `itemClicked(int index)` | `Md3Carousel` | Emitted when item Clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `goTo(index)` | `—` | `Md3Carousel` | Go To. |
| `next()` | `—` | `Md3Carousel` | Next. |
| `previous()` | `—` | `Md3Carousel` | Previous. |

## Example

```qml
import Md3

Md3Carousel {
    model: []
    currentIndex: 0
    mode: Md3Carousel.MultiBrowse
    itemHeight: 168
    peekRatio: 0.12
    spacing: 12
}
```

## WinUI 对照

| WinUI | Md3 |
|-------|-----|
| FlipView | `mode: Flip` |
| 多浏览轮播 | `mode: MultiBrowse`（默认 peek） |

指示点：`showIndicators` → 内嵌 `Md3PipsPager`。详见 [collections.md](../guides/collections.md)。

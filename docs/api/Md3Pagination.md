# Md3Pagination

Compact pagination bar for tables / lists.

- **Source:** `src/Md3/components/Md3Pagination.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `pageCount` | `int` | `1` | read/write | `Md3Pagination` | — |
| `currentPage` | `int` | `0` | read/write | `Md3Pagination` | — |
| `totalCount` | `int` | `-1` | read/write | `Md3Pagination` | — |
| `pageSize` | `int` | `10` | read/write | `Md3Pagination` | — |
| `showTotal` | `bool` | `true` | read/write | `Md3Pagination` | — |
| `safePageCount` | `int` | `Math.max(1, pageCount)` | readonly | `Md3Pagination` | — |
| `safePage` | `int` | `Math.max(0, Math.min(currentPage, safePageCount - 1))` | readonly | `Md3Pagination` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `pageRequested(int page)` | `Md3Pagination` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `goTo(page)` | `Md3Pagination` | — |
| `next()` | `Md3Pagination` | — |
| `previous()` | `Md3Pagination` | — |

## Example

```qml
import Md3

Md3Pagination {
    pageCount: 1
    currentPage: 0
    totalCount: -1
    pageSize: 10
    showTotal: true
}
```

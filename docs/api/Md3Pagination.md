# Md3Pagination

Compact pagination bar for tables / lists.

- **Source:** `src/Md3/components/Md3Pagination.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 7 | 1 | 3 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `pageCount` | `int` | `1` | read/write | `Md3Pagination` | Page Count. |
| `currentPage` | `int` | `0` | read/write | `Md3Pagination` | 0-based |
| `totalCount` | `int` | `-1` | read/write | `Md3Pagination` | Total Count. |
| `pageSize` | `int` | `10` | read/write | `Md3Pagination` | Rows / items per page. |
| `showTotal` | `bool` | `true` | read/write | `Md3Pagination` | Show Total. |
| `safePageCount` | `int` | `Math.max(1, pageCount)` | readonly | `Md3Pagination` | Safe Page Count. |
| `safePage` | `int` | `Math.max(0, Math.min(currentPage, safePageCount - 1))` | readonly | `Md3Pagination` | Safe Page. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `pageRequested(int page)` | `Md3Pagination` | Emitted when page Requested. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `goTo(page)` | `—` | `Md3Pagination` | Go To. |
| `next()` | `—` | `Md3Pagination` | Next. |
| `previous()` | `—` | `Md3Pagination` | Previous. |

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

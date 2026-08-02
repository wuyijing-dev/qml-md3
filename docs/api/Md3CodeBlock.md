# Md3CodeBlock

Read-only code block with lightweight syntax highlighting (QML / JS / C++ / JSON / plain).

- **Source:** `src/Md3/components/Md3CodeBlock.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 11 | 1 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `code` | `string` | `""` | read/write | `Md3CodeBlock` | Code. |
| `language` | `string` | `"qml"` | read/write | `Md3CodeBlock` | qml \| js \| javascript \| cpp \| c++ \| json \| plain |
| `showLineNumbers` | `bool` | `true` | read/write | `Md3CodeBlock` | Show Line Numbers. |
| `wrap` | `bool` | `false` | read/write | `Md3CodeBlock` | Wrap. |
| `fontSize` | `real` | `12` | read/write | `Md3CodeBlock` | Font Size. |
| `fontFamily` | `string` | `{…}` | read/write | `Md3CodeBlock` | Font Family. |
| `padding` | `int` | `12` | read/write | `Md3CodeBlock` | Uniform padding. |
| `maxHeight` | `int` | `280` | read/write | `Md3CodeBlock` | Max Height. |
| `scrollable` | `bool` | `true` | read/write | `Md3CodeBlock` | When false, height grows with content (still clipped by parent). |
| `showCopyButton` | `bool` | `true` | read/write | `Md3CodeBlock` | Show a copy button in the top-right corner. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3CodeBlock` | Drop RichText HTML while page is off-display (chrome size stays). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `copied(string text)` | `Md3CodeBlock` | Emitted when copied. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `refresh()` | `—` | `Md3CodeBlock` | Refresh content. |
| `requestRefresh()` | `—` | `Md3CodeBlock` | Request Refresh. |

## Example

```qml
import Md3

Md3CodeBlock {
    code: ""
    language: "qml"
    showLineNumbers: true
    wrap: false
    fontSize: 12
    fontFamily: /* … */
}
```

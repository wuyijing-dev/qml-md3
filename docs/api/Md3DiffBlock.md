# Md3DiffBlock

Diff / patch block with optional per-hunk action footer (stage, discard, …).

- **Source:** `src/Md3/components/Md3DiffBlock.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 2 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `code` | `string` | `""` | read/write | `Md3DiffBlock` | Code. |
| `language` | `string` | `"plain"` | read/write | `Md3DiffBlock` | Language. |
| `hunkActions` | `var` | `[]` | read/write | `Md3DiffBlock` | Hunk Actions. |
| `previewLineCount` | `int` | `12` | read/write | `Md3DiffBlock` | Preview Line Count. |
| `expanded` | `bool` | `false` | read/write | `Md3DiffBlock` | Expanded. |
| `showCopyButton` | `bool` | `true` | read/write | `Md3DiffBlock` | Show Copy Button. |
| `maxHeight` | `int` | `280` | read/write | `Md3DiffBlock` | Max Height. |
| `fill` | `bool` | `false` | read/write | `Md3DiffBlock` | Fill. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `hunkActionClicked(int index)` | `Md3DiffBlock` | Emitted when hunk Action Clicked. |
| `copied(string text)` | `Md3DiffBlock` | Emitted when copied. |

## Methods

_None._

## Example

```qml
import Md3

Md3DiffBlock {
    code: ""
    language: "plain"
    hunkActions: []
    previewLineCount: 12
    expanded: false
    showCopyButton: true
}
```

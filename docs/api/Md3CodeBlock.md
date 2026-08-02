# Md3CodeBlock

Read-only code block with lightweight syntax highlighting (QML / JS / C++ / JSON / plain).

- **Source:** `src/Md3/components/Md3CodeBlock.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `code` | `string` | `""` | read/write | `Md3CodeBlock` | — |
| `language` | `string` | `"qml"` | read/write | `Md3CodeBlock` | — |
| `showLineNumbers` | `bool` | `true` | read/write | `Md3CodeBlock` | — |
| `wrap` | `bool` | `false` | read/write | `Md3CodeBlock` | — |
| `fontSize` | `real` | `12` | read/write | `Md3CodeBlock` | — |
| `fontFamily` | `string` | `{…}` | read/write | `Md3CodeBlock` | — |
| `padding` | `int` | `12` | read/write | `Md3CodeBlock` | — |
| `maxHeight` | `int` | `280` | read/write | `Md3CodeBlock` | — |
| `scrollable` | `bool` | `true` | read/write | `Md3CodeBlock` | When false, height grows with content (still clipped by parent). |
| `showCopyButton` | `bool` | `true` | read/write | `Md3CodeBlock` | Show a copy button in the top-right corner. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3CodeBlock` | Drop RichText HTML while page is off-display (chrome size stays). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `copied(string text)` | `Md3CodeBlock` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `refresh()` | `Md3CodeBlock` | — |
| `requestRefresh()` | `Md3CodeBlock` | — |

## Example

```qml
import Md3

Md3CodeBlock {
    code: ""
    language: "qml"
    showLineNumbers: true
    wrap: false
    fontSize: 12
}
```

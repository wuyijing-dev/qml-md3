# Md3EmptyState

Empty / no-results placeholder: icon, title, body, optional CTA.

- **Source:** `src/Md3/components/Md3EmptyState.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `icon` | `string` | `"inbox"` | read/write | `Md3EmptyState` | — |
| `title` | `string` | `qsTr("Nothing here")` | read/write | `Md3EmptyState` | — |
| `body` | `string` | `""` | read/write | `Md3EmptyState` | — |
| `actionText` | `string` | `""` | read/write | `Md3EmptyState` | — |
| `illustration` | `url` | `""` | read/write | `Md3EmptyState` | — |
| `maxContentWidth` | `real` | `360` | read/write | `Md3EmptyState` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionClicked()` | `Md3EmptyState` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3EmptyState {
    icon: "inbox"
    title: qsTr("Nothing here")
    body: ""
    actionText: ""
    illustration: ""
}
```

# Md3EmptyState

Empty / no-results placeholder: icon, title, body, optional CTA.

- **Source:** `src/Md3/components/Md3EmptyState.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 1 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `icon` | `string` | `"inbox"` | read/write | `Md3EmptyState` | Material icon name or empty. |
| `title` | `string` | `qsTr("Nothing here")` | read/write | `Md3EmptyState` | Title text. |
| `body` | `string` | `""` | read/write | `Md3EmptyState` | Body. |
| `actionText` | `string` | `""` | read/write | `Md3EmptyState` | Action Text. |
| `illustration` | `url` | `""` | read/write | `Md3EmptyState` | Illustration. |
| `maxContentWidth` | `real` | `360` | read/write | `Md3EmptyState` | Max Content Width. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionClicked()` | `Md3EmptyState` | Emitted when action Clicked. |

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
    maxContentWidth: 360
}
```

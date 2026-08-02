# Md3PageSection

Page section: title + optional subtitle + content — cuts gallery/form glue.

- **Source:** `src/Md3/layout/Md3PageSection.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3PageSection` | Title text. |
| `subtitle` | `string` | `""` | read/write | `Md3PageSection` | Secondary supporting text. |
| `spacing` | `real` | `Md3Theme.spacingMd` | read/write | `Md3PageSection` | Child spacing. |
| `padding` | `real` | `0` | read/write | `Md3PageSection` | Uniform padding. |
| `fillWidth` | `bool` | `true` | read/write | `Md3PageSection` | Fill Width. |
| `content` | `alias` | `body.data` | default read/write | `Md3PageSection` | Content. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3PageSection {
    title: ""
    subtitle: ""
    spacing: Md3Theme.spacingMd
    padding: 0
    fillWidth: true
}
```

# Md3DialogHost

Imperative confirm / prompt dialogs. ``Md3ApplicationWindow`` registers a host automatically.

- **Source:** `src/Md3/foundation/Md3DialogHost.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 1 | 0 | 4 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `host` | `var` | `null` | read/write | `Md3DialogHost` | Host. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `registerHost(h)` | `—` | `Md3DialogHost` | Register Host. |
| `unregisterHost(h)` | `—` | `Md3DialogHost` | Unregister Host. |
| `confirm(options)` | `—` | `Md3DialogHost` | options: { title, text, confirmText, dismissText, confirmTone, preferredWidth, onConfirmed, onDismissed } |
| `prompt(options)` | `—` | `Md3DialogHost` | options: { title, text, label, placeholder, value, confirmText, dismissText, onConfirmed(value), onDismissed } |

## Example

```qml
import Md3

// Singleton — use as `Md3DialogHost.…`
console.log(Md3DialogHost)
```

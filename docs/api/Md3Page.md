# Md3Page

Base root for Md3PageHost destinations. Declares injectables that PageHost fills — prefer these over Window.window duck-typing.

- **Source:** `src/Md3/window/Md3Page.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 0 | 3 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `md3HostWindow` | `var` | `null` | read/write | `Md3Page` | Md3Host Window. |
| `md3RouteParams` | `var` | `{…}` | read/write | `Md3Page` | Md3Route Params. |
| `md3NavDepth` | `int` | `0` | read/write | `Md3Page` | Md3Nav Depth. |
| `md3PageActive` | `bool` | `true` | read/write | `Md3Page` | Injected by PageHost: true while this page is on-display (incl. mid-transition). |
| `md3GoBack` | `var` | `null` | read/write | `Md3Page` | function (opts) → bool |
| `md3PushRoute` | `var` | `null` | read/write | `Md3Page` | function (index, params, opts) → … |
| `routeParams` | `var` | `md3RouteParams && typeof md3RouteParams === "object"` | readonly | `Md3Page` | Route Params. |
| `navDepth` | `int` | `md3NavDepth` | readonly | `Md3Page` | Nav Depth. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `hostWindow()` | `—` | `Md3Page` | Host Window. |
| `goBack(opts)` | `—` | `Md3Page` | Go Back. |
| `pushRoute(index, params, opts)` | `—` | `Md3Page` | Push Route. |

## Example

```qml
import Md3

Md3Page {
    md3HostWindow: null
    md3RouteParams: /* … */
    md3NavDepth: 0
    md3PageActive: true
    md3GoBack: null
    md3PushRoute: null
}
```

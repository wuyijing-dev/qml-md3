# Md3Page

Base root for Md3PageHost destinations. Declares injectables that PageHost fills — prefer these over Window.window duck-typing.

- **Source:** `src/Md3/window/Md3Page.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `md3HostWindow` | `var` | `null` | read/write | `Md3Page` | — |
| `md3RouteParams` | `var` | `{…}` | read/write | `Md3Page` | — |
| `md3NavDepth` | `int` | `0` | read/write | `Md3Page` | — |
| `md3GoBack` | `var` | `null` | read/write | `Md3Page` | function (opts) → bool |
| `md3PushRoute` | `var` | `null` | read/write | `Md3Page` | function (index, params, opts) → … |
| `routeParams` | `var` | `md3RouteParams && typeof md3RouteParams === "object"` | readonly | `Md3Page` | — |
| `navDepth` | `int` | `md3NavDepth` | readonly | `Md3Page` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `hostWindow()` | `Md3Page` | — |
| `goBack(opts)` | `Md3Page` | — |
| `pushRoute(index, params, opts)` | `Md3Page` | — |

## Example

```qml
import Md3

Md3Page {
    md3HostWindow: null
    md3RouteParams: /* … */
    md3NavDepth: 0
    md3GoBack: null
    md3PushRoute: null
}
```

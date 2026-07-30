# Md3Page

- **Source:** `src/Md3/window/Md3Page.qml`
- **Kind:** base Item for PageHost destinations

Declares injectables filled by `Md3PageHost`. Prefer extending `Md3Page` over duck-typing `Window.window`.

## Injectables

| Property | Type | Filled by PageHost |
|----------|------|--------------------|
| `md3HostWindow` | `var` | `Window.window` |
| `md3RouteParams` | `var` | current route params |
| `md3NavDepth` | `int` | stack depth |
| `md3GoBack` | `var` (fn) | `pageHost.goBack` |
| `md3PushRoute` | `var` (fn) | `pageHost.pushRoute` |

Aliases: `routeParams`, `navDepth`.

## Helpers

| Name | Role |
|------|------|
| `hostWindow()` | `md3HostWindow` or `Window.window` |
| `goBack(opts)` | via inject or host window |
| `pushRoute(index, params, opts)` | via inject or host window |

## Example

```qml
Md3Page {
    id: root
    Md3TopAppBar {
        title: qsTr("Detail")
        leadingIcon: "arrow_back"
        onLeadingClicked: root.goBack()
    }
}
```

See [module-boundaries.md](../module-boundaries.md), [routing.md](../routing.md).

# Module boundaries

Dependency direction for the `Md3` QML module (do not invert):

```text
foundation  →  primitives  →  layout / components  →  charts
                                      ↘
                                       window
```

| Layer | Examples | May depend on |
|-------|----------|---------------|
| **foundation** | `Md3Theme`, `Md3Motion`, `Md3TreeVisibility`, `Md3Notify` | Qt only |
| **primitives** | `Md3Control`, `Md3Ripple`, `Md3Icon` | foundation |
| **layout / components** | `Md3Button`, `Md3HStack`, `Md3DataTable` | foundation, primitives, layout |
| **charts** | `Md3LineChart`, gauges | foundation, primitives, components helpers |
| **window** | `Md3ApplicationWindow`, `Md3PageHost`, title chrome | all of the above |

## Parent / window coupling rules

1. **Components must not** walk `parent` looking for `Md3ApplicationWindow` APIs (`flashTaskbar`, `systemBackdrop`, …).
2. Popups reparent to `Window.window.contentItem`, or take an explicit `hostWindow` / `targetWindow` (see `Md3TrayHost`, `Md3TitleBar`).
3. Live animations that pause when a PageHost slot is hidden use **`Md3TreeVisibility`** — do not copy `while (parent)` opacity walks.
4. Destination pages that need the shell declare injectables and let **`Md3PageHost`** fill them:
   - `md3HostWindow`
   - `md3RouteParams` / `routeParams`
   - `md3NavDepth` / `navDepth`
   - `md3GoBack`, `md3PushRoute`

App-layer routing stays outside PageHost core (thin adapters only) — see [routing.md](routing.md).

Less layout / control glue: [glue-less-api.md](glue-less-api.md), [layout.md](layout.md).

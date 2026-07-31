# Module boundaries

Dependency direction for the `Md3` QML module (do not invert):

```text
foundation  →  primitives  →  layout / components  →  charts
                                      ↘
                                       window
```

| Layer | Examples | May depend on |
|-------|----------|---------------|
| **foundation** | `Md3Theme`, `Md3Motion`, `Md3TreeVisibility`, `Md3OverlayHost`, `Md3Notify` | Qt only |
| **primitives** | `Md3Control`, `Md3Ripple`, `Md3Icon` | foundation |
| **layout / components** | `Md3Button`, `Md3HStack`, `Md3DataTable` | foundation, primitives, layout |
| **charts** | `Md3LineChart`, gauges | foundation, primitives, components helpers |
| **window** | `Md3ApplicationWindow`, `Md3Page`, `Md3PageHost`, title chrome | all of the above |

## Parent / window coupling rules

1. **Components must not** walk `parent` looking for `Md3ApplicationWindow` APIs (`flashTaskbar`, `systemBackdrop`, …).
2. Popups use **`Md3OverlayHost`** (`contentItem` / `mapToOverlay` / `ensureHostParent` / `resolveWindow`) with optional `overlayWindow` / `hostWindow`; do not re-implement `Window.window` walks in each control.
3. Live animations that pause when a PageHost slot is hidden use **`Md3TreeVisibility`** — do not copy `while (parent)` opacity walks.
4. Destination pages should extend **`Md3Page`** (or declare the same injectables). **`Md3PageHost`** fills:
   - `md3HostWindow`
   - `md3RouteParams` / `routeParams`
   - `md3NavDepth` / `navDepth`
   - `md3GoBack`, `md3PushRoute`

Chrome that needs shell tint / bounds (`Md3NavigationRail`, `Md3DocumentTabBar`) takes optional **`hostWindow`** (wired from `Md3WindowBody` / `Md3ApplicationWindow`).

Helpers on `Md3Page`: `hostWindow()`, `goBack()`, `pushRoute()`.

**App / Gallery UI** should prefer `Md3Text`, `Md3VStack` / `Md3HStack`, `Md3PageSection`, and `Md3Page` over bare `Text` / `ColumnLayout` / `Row`. Control **implementations** may keep Qt primitives (`Text`, `Column`) as drawing details.

App-layer routing stays outside PageHost core (thin adapters only) — see [routing.md](../topics/routing.md).

Less layout / control glue: [glue-less-api.md](glue-less-api.md), [layout.md](layout.md).

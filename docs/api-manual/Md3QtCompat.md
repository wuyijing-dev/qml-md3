# Md3QtCompat

Singleton describing the **unified Qt6 behavior policy** across 6.5 / 6.8 / 6.10.

See [Qt version matrix](../topics/qt-version-matrix.md).

## Properties

| Property | Meaning |
|----------|---------|
| `qtVersion` / `qtMinor` | Runtime Qt version string / minor |
| `strictColumnHeight` | Always `true` — layout shells sync `height`←`implicitHeight` |
| `flickableUsesImplicitHeight` | Prefer `contentHeight: item.implicitHeight` |
| `dataTableAvoidHeightLoop` | Do not bind `bodyHeight` to `height` |
| `atLeast68` / `atLeast610` | Minor version helpers |

Link differences (Effects public vs Private) are handled in CMake, not in this singleton.

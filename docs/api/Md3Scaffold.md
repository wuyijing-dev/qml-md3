# Md3Scaffold

- **Source:** `src/Md3/components/Md3Scaffold.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `appBar` | `alias` | `appBarSlot.data` | read/write | `Md3Scaffold` | — |
| `navigationBar` | `alias` | `navBarSlot.data` | read/write | `Md3Scaffold` | — |
| `fab` | `alias` | `fabSlot.data` | read/write | `Md3Scaffold` | — |
| `drawer` | `alias` | `drawerSlot.data` | read/write | `Md3Scaffold` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Scaffold {
    appBar: appBarSlot.data
    navigationBar: navBarSlot.data
    fab: fabSlot.data
    drawer: drawerSlot.data
}
```

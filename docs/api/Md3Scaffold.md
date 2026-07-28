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
| `appBar` | `alias` | `appBarSlot.data` | read/write | `Md3Scaffold` | Alias → `appBarSlot.data` |
| `navigationBar` | `alias` | `navBarSlot.data` | read/write | `Md3Scaffold` | Alias → `navBarSlot.data` |
| `fab` | `alias` | `fabSlot.data` | read/write | `Md3Scaffold` | Alias → `fabSlot.data` |
| `drawer` | `alias` | `drawerSlot.data` | read/write | `Md3Scaffold` | Alias → `drawerSlot.data` |
| `content` | `alias` | `body.data` | default read/write | `Md3Scaffold` | Default property → `body.data` |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Scaffold {
    // see properties above
}
```

# Md3Form

- **Source:** `src/Md3/components/Md3Form.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `errors` | `var` | `({})` | read/write | `Md3Form` | — |
| `values` | `var` | `({})` | read/write | `Md3Form` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `setError(name, message)` | `Md3Form` | — |
| `clearErrors()` | `Md3Form` | — |
| `validate(requiredFields)` | `Md3Form` | — |
| `errorFor(name)` | `Md3Form` | — |

## Example

```qml
import Md3

Md3Form {
    errors: ({})
    values: ({})
}
```

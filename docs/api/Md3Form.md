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
| `errors` | `var` | `{…}` | read/write | `Md3Form` | — |
| `values` | `var` | `{…}` | read/write | `Md3Form` | — |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Form` | — |
| `requiredFields` | `var` | `[]` | read/write | `Md3Form` | Optional required field names used by validate() when no list is passed. |
| `spacing` | `real` | `Md3Theme.spacingMd` | read/write | `Md3Form` | Vertical spacing between direct field children (built-in stack — no Md3VStack glue). |
| `fillFields` | `bool` | `true` | read/write | `Md3Form` | Stretch direct children to form width. |
| `liveGate` | `bool` | `true` | read/write | `Md3Form` | When true, keep `canSubmit` / `hasErrors` fresh while typing (event-driven; no poll). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3Form` | Drop gate polling while page is off-display. |
| `hasErrors` | `bool` | `false` | read/write | `Md3Form` | True when any entry in `errors` is a non-empty string. |
| `canSubmit` | `bool` | `true` | read/write | `Md3Form` | True when required fields are non-empty and `hasErrors` is false (does not run validators). |
| `requiredSatisfied` | `bool` | `true` | read/write | `Md3Form` | True when every `requiredFields` entry has a non-empty value. |
| `content` | `alias` | `formStack.data` | default read/write | `Md3Form` | Default property → `formStack.data` |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `submitted(var values)` | `Md3Form` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `setError(name, message)` | `Md3Form` | — |
| `clearErrors()` | `Md3Form` | — |
| `errorFor(name)` | `Md3Form` | — |
| `collectFields()` | `Md3Form` | — |
| `syncValues()` | `Md3Form` | — |
| `refreshGate()` | `Md3Form` | Refresh `hasErrors` / `requiredSatisfied` / `canSubmit` from current fields + `errors`. |
| `validate(required)` | `Md3Form` | — |
| `focusFirstError()` | `Md3Form` | — |
| `submit()` | `Md3Form` | Run `validate()`; on success emit `submitted(values)` and return true. |

## Example

```qml
import Md3

Md3Form {
    errors: /* … */
    values: /* … */
    layoutMode: Md3ContainerBody.Fit
    requiredFields: []
    spacing: Md3Theme.spacingMd
}
```

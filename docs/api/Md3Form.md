# Md3Form

- **Source:** `src/Md3/components/Md3Form.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 12 | 1 | 9 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `errors` | `var` | `{…}` | read/write | `Md3Form` | Errors. |
| `values` | `var` | `{…}` | read/write | `Md3Form` | Values. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Form` | Layout Mode. |
| `requiredFields` | `var` | `[]` | read/write | `Md3Form` | Optional required field names used by validate() when no list is passed. |
| `spacing` | `real` | `Md3Theme.spacingMd` | read/write | `Md3Form` | Vertical spacing between direct field children (built-in stack — no Md3VStack glue). |
| `fillFields` | `bool` | `true` | read/write | `Md3Form` | Stretch direct children to form width. |
| `liveGate` | `bool` | `true` | read/write | `Md3Form` | When true, keep `canSubmit` / `hasErrors` fresh while typing (event-driven; no poll). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3Form` | Drop gate polling while page is off-display. |
| `hasErrors` | `bool` | `false` | read/write | `Md3Form` | True when any entry in `errors` is a non-empty string. |
| `canSubmit` | `bool` | `true` | read/write | `Md3Form` | True when required fields are non-empty and `hasErrors` is false (does not run validators). |
| `requiredSatisfied` | `bool` | `true` | read/write | `Md3Form` | True when every `requiredFields` entry has a non-empty value. |
| `content` | `alias` | `formStack.data` | default read/write | `Md3Form` | Content. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `submitted(var values)` | `Md3Form` | Emitted when submitted. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `setError(name, message)` | `—` | `Md3Form` | Set Error. |
| `clearErrors()` | `—` | `Md3Form` | Clear Errors. |
| `errorFor(name)` | `—` | `Md3Form` | Error For. |
| `collectFields()` | `—` | `Md3Form` | Collect Fields. |
| `syncValues()` | `—` | `Md3Form` | Sync Values. |
| `refreshGate()` | `—` | `Md3Form` | Refresh `hasErrors` / `requiredSatisfied` / `canSubmit` from current fields + `errors`. |
| `validate(required)` | `—` | `Md3Form` | Run validation and refresh error map. |
| `focusFirstError()` | `—` | `Md3Form` | Focus (and scroll to) the first invalid field. |
| `submit()` | `—` | `Md3Form` | Run `validate()`; on success emit `submitted(values)` and return true. |

## Example

```qml
import Md3

Md3Form {
    errors: /* … */
    values: /* … */
    layoutMode: Md3ContainerBody.Fit
    requiredFields: []
    spacing: Md3Theme.spacingMd
    fillFields: true
}
```

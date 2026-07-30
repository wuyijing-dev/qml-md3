# Md3Form

Container that syncs `values` / `errors` onto named fields (`name` on TextField / Select / NumberField).
Built-in vertical stack — direct children need no wrapping `Md3VStack`.

- **Source:** `src/Md3/components/Md3Form.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `errors` | var | `{}` | name → message |
| `values` | var | `{}` | name → value (from syncValues) |
| `requiredFields` | var | `[]` | Default list for validate() |
| `spacing` | real | `Md3Theme.spacingMd` | Between stacked children |
| `fillFields` | bool | `true` | Stretch children to form width |
| `liveGate` | bool | `true` | Poll fields so `canSubmit` updates while typing |
| `hasErrors` | bool | `false` | Any non-empty `errors` entry |
| `requiredSatisfied` | bool | `true` | All required fields non-empty |
| `canSubmit` | bool | `true` | `requiredSatisfied && !hasErrors` |
| `layoutMode` | int | `Fit` | — |
| `content` | alias | default | Fields |

## Signals

| Signal | Description |
|--------|-------------|
| `submitted(var values)` | After successful `submit()` |

## Methods

| Method | Description |
|--------|-------------|
| `setError(name, message)` | Set one error and apply to fields |
| `clearErrors()` | Clear all |
| `errorFor(name)` | Lookup |
| `syncValues()` | Read named fields into `values` |
| `collectFields()` | List items with `name` |
| `refreshGate()` | Recompute `canSubmit` / `hasErrors` |
| `validate(required?)` | Required check + auto `errorText` |
| `submit()` | `validate()` then emit `submitted` |

## Example

```qml
Md3Form {
    id: form
    requiredFields: ["email"]
    Md3TextField { name: "email"; label: qsTr("Email") }
    Md3Button {
        text: qsTr("Save")
        enabled: form.canSubmit
        onClicked: form.submit()
    }
    onSubmitted: (values) => { /* … */ }
}
```

See also: [design-guidelines.md](../design-guidelines.md) § 表单.

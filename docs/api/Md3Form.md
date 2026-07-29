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
| `spacing` | real | `12` | Between stacked children |
| `fillFields` | bool | `true` | Stretch children to form width |
| `layoutMode` | int | `Fit` | — |
| `content` | alias | default | Fields |

## Methods

| Method | Description |
|--------|-------------|
| `setError(name, message)` | Set one error and apply to fields |
| `clearErrors()` | Clear all |
| `errorFor(name)` | Lookup |
| `syncValues()` | Read named fields into `values` |
| `collectFields()` | List items with `name` |
| `validate(required?)` | Required check + auto `errorText` |

## Example

```qml
Md3Form {
    id: form
    requiredFields: ["email"]
    Md3TextField { name: "email"; label: qsTr("Email") }
    Md3Button { text: qsTr("OK"); onClicked: form.validate() }
}
```

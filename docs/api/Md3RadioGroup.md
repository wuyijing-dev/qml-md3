# Md3RadioGroup

Model-driven radio row/column — no host `QtObject` + manual `Md3Radio` list.

- **Source:** `src/Md3/components/Md3RadioGroup.qml`

## Enums

`Horizontal`, `Vertical`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `model` | var | `[]` | `[{ text, value?, enabled? }]` |
| `value` | var | `null` | Selected value |
| `orientation` | int | `Horizontal` | Row or column |
| `spacing` | real | `8` | — |
| `currentIndex` | int | readonly | Index of `value` in model |

## Signals

`selected(var value)` — user changed selection

## Example

```qml
Md3RadioGroup {
    value: "a"
    model: [
        { text: qsTr("A"), value: "a" },
        { text: qsTr("B"), value: "b" }
    ]
}
```
